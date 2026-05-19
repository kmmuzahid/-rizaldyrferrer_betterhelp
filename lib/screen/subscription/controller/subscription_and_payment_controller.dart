// ignore_for_file: duplicate_import, depend_on_referenced_packages, unused_import

/*
 * @Author: Km Muzahid
 * @Date: 2026-01-09 09:41:39
 * @Email: km.muzahid@gmail.com
 */
import 'dart:async';
import 'dart:io';

import 'package:better_help/core/app_apiurl/api_end_points.dart';
import 'package:better_help/core/app_route/app_route.dart';
import 'package:better_help/screen/menu_drawer/my_profile/profile_screen/controller/my_profile_screen_controller.dart';
import 'package:better_help/screen/subscription/model/subscription_model.dart';
import 'package:better_help/sockets/support_message_socket.dart';
import 'package:core_kit/network/dio_service.dart';
import 'package:core_kit/network/request_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';

class SubscriptionAndPaymentController extends GetxController {
  var isLoadingDependency = true.obs;
  bool routeFromDrawer = false;
  var isPurchaseLoading = false.obs;
  late PageController pageController;
  final RxList<SubscriptionModel> subscriptionPlan =
      RxList<SubscriptionModel>();

  final InAppPurchase _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  final RxMap<String, ProductDetails> storeProducts =
      <String, ProductDetails>{}.obs;

  bool isRestoreChecked = false;

  _fetchSubscriptionPlan() async {
    String platform = 'apple';
    if (Platform.isAndroid) {
      platform = 'google';
    }

    final response = await DioService.instance.request(
      input: RequestInput(
        endpoint: ApiEndPoints.package,
        method: RequestMethod.GET,
        queryParams: {"platform": platform, 'sort': 'price'},
      ),
      responseBuilder: (data) {
        return List<SubscriptionModel>.from(
          data.map((x) => SubscriptionModel.fromJson(x)),
        );
      },
    );

    if (response.isSuccess) {
      subscriptionPlan.value = response.data ?? [];

      final productIds = subscriptionPlan
          .where(
            (e) =>
                (e.price ?? 0) > 0 &&
                e.productId != null &&
                e.productId!.isNotEmpty,
          )
          .map((e) => e.productId!)
          .toSet();

      print(productIds);

      if (productIds.isNotEmpty) {
        final ProductDetailsResponse response = await _iap.queryProductDetails(
          productIds,
        );
        print("Product IDs: $productIds");
        if (response.error != null) {
          debugPrint("IAP Error: ${response.error}");
          subscriptionPlan.value = subscriptionPlan
              .takeWhile((e) => (e.price ?? 0) == 0)
              .toList();
          isLoadingDependency.value = false;
          return;
        }

        for (var product in response.productDetails) {
          storeProducts[product.id] = product;
        }

        // Only show plans available in Google or Apple Store
        final availableProductIds = response.productDetails
            .map((p) => p.id)
            .toSet();

        subscriptionPlan.value = subscriptionPlan.where((plan) {
          if ((plan.price ?? 0) == 0) return true;
          return availableProductIds.contains(plan.productId);
        }).toList();
      }
    }
    isLoadingDependency.value = false;
  }

  ProductDetails? getProduct(String productId) {
    return storeProducts[productId];
  }

  String getDuration(ProductDetails product) {
    if (Platform.isIOS && product is AppStoreProductDetails) {
      final period = product.skProduct.subscriptionPeriod;

      return "/${period?.numberOfUnits} ${period?.unit.name}";
    }

    if (Platform.isAndroid && product is GooglePlayProductDetails) {
      final phases = product.productDetails.subscriptionOfferDetails;

      final recurringPhase = phases?.first.pricingPhases.last;

      return "/${recurringPhase?.billingPeriod}";
    }

    return '';
  }

  onRestore({bool showLoader = true}) async {
    if (showLoader) isPurchaseLoading.value = true;
    try {
      await _iap.restorePurchases();
      print("Restore completed");
    } catch (e) {
      if (showLoader) {
        Get.snackbar('Error', 'Failed to restore purchases: $e');
      }
      print("Restore error: $e");
    } finally {
      if (showLoader) isPurchaseLoading.value = false;
    }
  }

  onSubscribe(int index) async {
    if (isPurchaseLoading.value) return;
    final plan = subscriptionPlan[index];

    if ((plan.price ?? 0) == 0) {
      //buy free plan
      isPurchaseLoading.value = true;
      final response = await DioService.instance.request(
        showMessage: true,
        input: RequestInput(
          endpoint: ApiEndPoints.createSubscription,
          method: RequestMethod.POST,
          jsonBody: {"packageId": plan.id},
        ),
        responseBuilder: (data) {
          return data;
        },
      );
      isPurchaseLoading.value = false;

      if (response.isSuccess) {
        _onSuccess();
      }
    } else {
      //buy subscription from store
      final product = storeProducts[plan.productId];
      if (product != null) {
        isPurchaseLoading.value = true;
        final PurchaseParam purchaseParam = PurchaseParam(
          productDetails: product,
        );
        _iap.buyNonConsumable(purchaseParam: purchaseParam);
      } else {
        Get.snackbar('Error', 'Product not available in store');
      }
    }
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        isPurchaseLoading.value = true;
      } else {
        isPurchaseLoading.value = false;
        if (purchaseDetails.status == PurchaseStatus.error) {
          Get.snackbar(
            'Error',
            purchaseDetails.error?.message ?? 'Purchase failed',
          );
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            _onSuccess();
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await _iap.completePurchase(purchaseDetails);
        }
      }
    });
  }

  void _onSuccess() {
    Get.find<MyProfileScreenController>().fetchProfile();
    Get.offAllNamed(AppRoute.bottomNav);
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    final plan = subscriptionPlan.firstWhereOrNull(
      (e) => e.productId == purchaseDetails.productID,
    );

    final response = await DioService.instance.request(
      showMessage: true,
      input: RequestInput(
        endpoint: ApiEndPoints.createSubscription,
        method: RequestMethod.POST,
        jsonBody: {
          "packageId": plan?.id,
          "productId": purchaseDetails.productID,
          "purchaseToken":
              purchaseDetails.verificationData.serverVerificationData,
          "platform": Platform.isAndroid ? "google" : "apple",
          "isRestore": purchaseDetails.status == PurchaseStatus.restored,
        },
      ),
      responseBuilder: (data) => data,
    );
    return response.isSuccess;
  }

  @override
  void onInit() async {
    if (Get.arguments != null) {
      routeFromDrawer = Get.arguments['route_from'] == "drawer";
    }
    pageController = PageController();
    isLoadingDependency.value = true;

    final bool isAvailable = await _iap.isAvailable();
    if (isAvailable) {
      print("Store is available");
    }

    final Stream<List<PurchaseDetails>> purchaseUpdated = _iap.purchaseStream;

    _subscription = purchaseUpdated.listen(
      (purchaseDetailsList) {
        if (purchaseDetailsList.isNotEmpty) {
          _listenToPurchaseUpdated(purchaseDetailsList);
        } else if (!isRestoreChecked) {
          isRestoreChecked = true;
          _fetchSubscriptionPlan();
        }
      },
      onDone: () {
        _subscription.cancel();
      },
      onError: (error) {
        isPurchaseLoading.value = false;
        debugPrint("Purchase stream error: $error");
      },
    );

    //get product id from the server

    SocketService.instance.connect();
    final profileController = Get.find<MyProfileScreenController>();
    await profileController.fetchProfile();

    await onRestore(showLoader: false);

    if (profileController.profileData.value?.subscriptionPlanType == null) {
      _fetchSubscriptionPlan();
    } else {
      isLoadingDependency.value = false;
    }

    //to skip subscription and payment
    // if (!routeFromDrawer) {
    //   _onSuccess();
    // }
    super.onInit();
  }

  @override
  void onClose() {
    pageController.dispose();
    _subscription.cancel();
    super.onClose();
  }
}
