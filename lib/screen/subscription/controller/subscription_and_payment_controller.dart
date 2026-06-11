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
import 'package:better_help/core/compatibility/corekit_compat.dart';
import 'package:better_help/corekit_config_impl.dart';
import 'package:better_help/screen/menu_drawer/my_profile/profile_screen/controller/my_profile_screen_controller.dart';
import 'package:better_help/screen/subscription/model/payment_verification_model.dart';
import 'package:better_help/screen/subscription/model/subscription_model.dart';
import 'package:better_help/sockets/support_message_socket.dart';
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

  // Restore runs exactly once per controller lifecycle (at init).
  // After that it is never triggered again.
  bool _restoreDone = false;

  // True while a real store purchase (not restore) is in progress.
  // Prevents empty-stream events from incorrectly triggering plan fetch.
  bool _isPurchasing = false;

  Future<void> _fetchSubscriptionPlan() async {
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

      final Set<String> productIds = subscriptionPlan
          .where(
            (e) =>
                (e.price ?? 0) > 0 &&
                e.productId != null &&
                e.productId!.isNotEmpty,
          )
          .map((e) => e.productId!)
          .toSet();

      if (productIds.isNotEmpty) {
        final ProductDetailsResponse productResponse = await _iap
            .queryProductDetails(productIds);
        if (productResponse.error != null) {
          debugPrint("IAP Error: ${productResponse.error}");
          subscriptionPlan.value = subscriptionPlan
              .takeWhile((e) => (e.price ?? 0) == 0)
              .toList();
          isLoadingDependency.value = false;
          return;
        }

        for (var product in productResponse.productDetails) {
          storeProducts[product.id] = product;
        }

        // Only show plans available in Google or Apple Store
        final availableProductIds = productResponse.productDetails
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

  Future<void> onRestore({bool showLoader = true}) async {
    // Guard: restore can only run once per controller lifecycle
    if (_restoreDone) return;
    _restoreDone = true;

    if (showLoader) isPurchaseLoading.value = true;
    try {
      await _iap.restorePurchases();
      debugPrint("Restore completed");
    } catch (e) {
      if (showLoader) isPurchaseLoading.value = false;
      Get.snackbar('Error', 'Failed to restore purchases: $e');
      debugPrint("Restore error: $e");
    }
    // Note: Do NOT set isPurchaseLoading = false here.
    // The restore results are delivered asynchronously via purchaseStream.
    // The loader will be hidden in _listenToPurchaseUpdated when processing is done.
  }

  Future<void> onSubscribe(SubscriptionModel plan) async {
    if (isPurchaseLoading.value) return;

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
          _isPurchasing = true; // mark real purchase in progress
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
      _isPurchasing = false;
      isPurchaseLoading.value = false;
      debugPrint("Subscribe error: $e");
    }
  }

  Future<void> _listenToPurchaseUpdated(
    List<PurchaseDetails> purchaseDetailsList,
  ) async {
    // 1. Check if anything is still pending
    final hasPending = purchaseDetailsList.any(
      (p) => p.status == PurchaseStatus.pending,
    );

    if (hasPending) {
      isPurchaseLoading.value = true;
      return;
    }

    // Show errors for any failed purchases
    for (final purchase in purchaseDetailsList) {
      if (purchase.status == PurchaseStatus.error) {
        Get.snackbar('Error', purchase.error?.message ?? 'Purchase failed');
      }
    }

    // 2. Filter successful or restored purchases
    final validPurchases = purchaseDetailsList
        .where(
          (p) =>
              p.status == PurchaseStatus.purchased ||
              p.status == PurchaseStatus.restored,
        )
        .toList();

    if (validPurchases.isNotEmpty) {
      // Find the latest purchase based on transactionDate
      PurchaseDetails latestPurchase = validPurchases.first;
      int latestTime = _parseTransactionDate(latestPurchase.transactionDate);

      for (var i = 1; i < validPurchases.length; i++) {
        final currentPurchase = validPurchases[i];
        final currentTime = _parseTransactionDate(
          currentPurchase.transactionDate,
        );
        if (currentTime > latestTime) {
          latestPurchase = currentPurchase;
          latestTime = currentTime;
        }
      }

      // Verify the latest purchase with the backend FIRST
      final response = await _sendVerifyRequest(
        packageId: plandId(latestPurchase) ?? '',
        purchaseDetails: latestPurchase,
      );

      // 3. Only acknowledge purchases to the store AFTER backend verification
      // This prevents the store treating the transaction as "done" if backend failed
      for (final purchase in purchaseDetailsList) {
        if (purchase.pendingCompletePurchase && purchase.purchaseID != null) {
          await _iap.completePurchase(purchase);
        }
      }

      isPurchaseLoading.value = false;
      _isPurchasing = false;

      final isNewSubscription = ckAuth.profile?.subscriptionPackageId == null;

      _onSuccess(response, newSubscription: isNewSubscription);
    } else {
      // Stream emitted but no valid purchases — hide loader
      isPurchaseLoading.value = false;
      _isPurchasing = false;

      // Complete any remaining pending-complete purchases even with no valid ones
      for (final purchase in purchaseDetailsList) {
        if (purchase.pendingCompletePurchase) {
          await _iap.completePurchase(purchase);
        }
      }
    }
  }

  int _parseTransactionDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 0;
    // Try to parse as integer (milliseconds since epoch)
    final ms = int.tryParse(dateStr);
    if (ms != null) return ms;
    // Fallback to DateTime parse (ISO-8601)
    final dt = DateTime.tryParse(dateStr);
    return dt?.millisecondsSinceEpoch ?? 0;
  }

  void _onSuccess(
    PaymentVerificationModel? response, {
    bool newSubscription = false,
  }) async {
    if (response == null) {
      CkSnackBar('Failed to verify purchase', type: .warning);
      return;
    }

    await ckAuth.fetchProfile();
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
            "purchaseId": purchaseDetails is GooglePlayPurchaseDetails
                ? purchaseDetails.billingClientPurchase.purchaseToken
                : purchaseDetails?.purchaseID,
            "platform": Platform.isAndroid ? "google" : "apple",
            // Fixed typo: was "trasactionDate"
            "transactionDate": purchaseDetails?.transactionDate,
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
    return Get.toNamed(AppRoute.bottomNav);

    bool performRestoreCheck = false;
    if (Get.arguments != null && Get.arguments is Map) {
      routeFromDrawer = Get.arguments['route_from'] == "drawer";
      performRestoreCheck = Get.arguments['perform_restore_check'] == true;
    }
    pageController = PageController();
    isLoadingDependency.value = true;

    final bool isAvailable = await _iap.isAvailable();
    if (!isAvailable) {
      debugPrint("Store is not available");
    }

    final Stream<List<PurchaseDetails>> purchaseUpdated = _iap.purchaseStream;

    _subscription = purchaseUpdated.listen(
      (purchaseDetailsList) {
        if (purchaseDetailsList.isNotEmpty) {
          // unawaited intentionally — stream callbacks cannot be async.
          // All internal sequencing is handled inside _listenToPurchaseUpdated.
          _listenToPurchaseUpdated(purchaseDetailsList);
        } else if (!isRestoreChecked && !_isPurchasing) {
          // Empty stream event from restore (no purchases found).
          // Skip if a real purchase is in progress — don't interfere with it.
          isRestoreChecked = true;
          isPurchaseLoading.value = false;
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

    SocketService.instance.connect();
    await ckAuth.fetchProfile();

    if (performRestoreCheck || !routeFromDrawer) {
      // Always run restore silently (no overlay loader).
      // On iOS, if there are no restorable purchases, the stream may never
      // fire an empty event — using showLoader: true would cause infinite loading.
      // The isLoadingDependency spinner already covers this wait.
      await onRestore(showLoader: false);
    }

    final planType = ckAuth.profile?.subscriptionPlanType;
    if (planType == null ||
        planType == 'free' ||
        routeFromDrawer ||
        performRestoreCheck) {
      _fetchSubscriptionPlan();
    } else {
      isLoadingDependency.value = false;
    }

    super.onInit();
  }

  @override
  void onClose() {
    pageController.dispose();
    _subscription.cancel();
    super.onClose();
  }
}
