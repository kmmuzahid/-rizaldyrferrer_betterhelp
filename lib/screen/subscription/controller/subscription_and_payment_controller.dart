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
import 'package:better_help/screen/subscription/model/payment_verification_model.dart';
import 'package:better_help/screen/subscription/model/subscription_model.dart';
import 'package:better_help/sockets/support_message_socket.dart';
import 'package:better_help/core/compatibility/corekit_compat.dart';
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
  var currentPage = 0.obs;

  final InAppPurchase _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  final RxMap<String, ProductDetails> storeProducts =
      <String, ProductDetails>{}.obs;

  bool isRestoreChecked = false;
  RxBool isVerifying = false.obs;

  _fetchSubscriptionPlan() async {
    String platform = 'apple';
    if (Platform.isAndroid) {
      platform = 'google';
    }

    final response = await CkTransport.request(
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

      if (productIds.isNotEmpty) {
        final ProductDetailsResponse response = await _iap.queryProductDetails(
          productIds,
        );
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
      if (period != null) {
        final numberOfUnits = period.numberOfUnits;
        final unitName = period.unit.name.toLowerCase();
        String unitStr = '';
        if (unitName.contains('month')) {
          unitStr = numberOfUnits == 1 ? 'Month' : 'Months';
        } else if (unitName.contains('year')) {
          unitStr = numberOfUnits == 1 ? 'Year' : 'Years';
        } else if (unitName.contains('week')) {
          unitStr = numberOfUnits == 1 ? 'Week' : 'Weeks';
        } else if (unitName.contains('day')) {
          unitStr = numberOfUnits == 1 ? 'Day' : 'Days';
        } else {
          unitStr = period.unit.name;
        }
        return numberOfUnits == 1 ? unitStr : '$numberOfUnits $unitStr';
      }
    }

    if (Platform.isAndroid && product is GooglePlayProductDetails) {
      final phases = product.productDetails.subscriptionOfferDetails;
      if (phases != null && phases.isNotEmpty) {
        final recurringPhase = phases.first.pricingPhases.last;
        final period = recurringPhase.billingPeriod; // e.g. "P1M", "P1Y", "P1W"
        final regExp = RegExp(r'P(\d+)([WMYD])');
        final match = regExp.firstMatch(period);
        if (match != null) {
          final amount = int.tryParse(match.group(1) ?? '1') ?? 1;
          final unit = match.group(2);
          String unitStr = '';
          if (unit == 'M') {
            unitStr = amount == 1 ? 'Month' : 'Months';
          } else if (unit == 'Y') {
            unitStr = amount == 1 ? 'Year' : 'Years';
          } else if (unit == 'W') {
            unitStr = amount == 1 ? 'Week' : 'Weeks';
          } else if (unit == 'D') {
            unitStr = amount == 1 ? 'Day' : 'Days';
          }
          return amount == 1 ? unitStr : '$amount $unitStr';
        }
        return period;
      }
    }

    return '';
  }

  String getPlanDuration(SubscriptionModel plan) {
    if ((plan.price ?? 0) == 0) {
      return plan.duration ?? "Lifetime";
    }
    final product = storeProducts[plan.productId];
    if (product == null) {
      return plan.duration ?? "Month";
    }
    final durationStr = getDuration(product);
    return durationStr.isEmpty ? (plan.duration ?? "Month") : durationStr;
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
    final plan = subscriptionPlan[index + (routeFromDrawer ? 1 : 0)];

    try {
      if ((plan.price ?? 0) == 0) {
        //buy free plan
        isPurchaseLoading.value = true;
        final response = await _sendVerifyRequest(packageId: plan.id);
        isPurchaseLoading.value = false;

        _onSuccess(response, newSubscription: true);
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
    } catch (e) {
      isPurchaseLoading.value = false;
      debugPrint("Subscribe error: $e");
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
          final response = await _sendVerifyRequest(
            packageId: plandId(purchaseDetails) ?? '',
            purchaseDetails: purchaseDetails,
          );

          final isNewSubscription =
              Get.find<MyProfileScreenController>()
                  .profileData
                  .value
                  ?.subscriptionPackageId ==
              null;

          _onSuccess(response, newSubscription: isNewSubscription);
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await _iap.completePurchase(purchaseDetails);
        }
      }
    });
  }

  void _onSuccess(
    PaymentVerificationModel? response, {
    bool newSubscription = false,
  }) async {
    if (response == null) {
      CkSnackBar('Failed to verify purchase', type: .warning);
      return;
    }

    await Get.find<MyProfileScreenController>().fetchProfile();
    if ((response.active == true && !routeFromDrawer) || newSubscription) {
      Get.offAllNamed(AppRoute.bottomNav);
    } else if (routeFromDrawer && response.active == true) {
      CkSnackBar('Subscription successful!', type: .success);
      Get.back();
    }
  }

  String? plandId(PurchaseDetails purchaseDetails) => subscriptionPlan
      .firstWhereOrNull((e) => e.productId == purchaseDetails.productID)
      ?.id;

  Future<PaymentVerificationModel?> _sendVerifyRequest({
    String? packageId,
    PurchaseDetails? purchaseDetails,
  }) async {
    if (isVerifying.value) return null;
    isVerifying.value = true;
    try {
      final response = await CkTransport.request(
        input: RequestInput(
          endpoint: ApiEndPoints.createSubscription,
          method: RequestMethod.POST,
          jsonBody: {
            "packageId": packageId,
            "productId": purchaseDetails?.productID,
            "purchaseId": purchaseDetails?.purchaseID,
            "platform": Platform.isAndroid ? "google" : "apple",
            "trasactionDate": purchaseDetails?.transactionDate,
            "status": purchaseDetails?.status.name,
            "isRestore": purchaseDetails?.status == PurchaseStatus.restored,
          },
        ),
        responseBuilder: (data) => PaymentVerificationModel.fromJson(data),
      );
      return response.data;
    } catch (e) {
      debugPrint("Verification request error: $e");
      return null;
    } finally {
      isVerifying.value = false;
    }
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

    if (!routeFromDrawer) await onRestore(showLoader: false);

    final planType = profileController.profileData.value?.subscriptionPlanType;
    if (planType == null || planType == 'free' || routeFromDrawer) {
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
