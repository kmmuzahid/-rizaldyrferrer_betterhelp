// import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

double getResponsiveAspectRatio({
  required BuildContext context,
  double ratioAdjuster = 0.0,
}) {
  final screenWidth = MediaQuery.of(context).size.width;

  // Utilize common mobile pixel widths for more granular control
  if (screenWidth < 320) {
    // Extra Small Devices (e.g., old iPhones, very compact Androids)
    return screenWidth / 600 + ratioAdjuster;
  } else if (screenWidth < 375) {
    // Small Devices (e.g., iPhone SE, some compact Androids - 360-374px range)
    return screenWidth / 680 + ratioAdjuster;
  } else if (screenWidth < 414) {
    // Medium Devices (e.g., standard iPhones, many Androids - 375-413px range)
    return screenWidth / 790 + ratioAdjuster;
  } else if (screenWidth < 480) {
    // Larger Phone Devices (e.g., iPhone Plus/Max, larger Androids - 414-479px range)
    return screenWidth / 850 + ratioAdjuster;
  } else if (screenWidth < 600) {
    // Small Tablets / Foldable Phone Inner Screens (portrait)
    return screenWidth / 900 + ratioAdjuster;
  } else if (screenWidth < 768) {
    // Medium Tablets (e.g., iPad Mini - portrait)
    return screenWidth / 1000 + ratioAdjuster;
  } else if (screenWidth < 1024) {
    // Large Tablets (e.g., iPad - portrait, many laptops)
    return screenWidth / 1200 + ratioAdjuster;
  } else {
    // Desktops and very Large Tablets (landscape)
    return screenWidth / 1400 + ratioAdjuster;
  }
}
