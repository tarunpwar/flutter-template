import 'package:flutter/material.dart';

/// App Dimensions
/// 
/// This class contains all the dimension constants used throughout the app.
/// It follows Material Design guidelines and ensures consistent spacing
/// and sizing across all screens and devices.
class AppDimensions {
  // Private constructor to prevent instantiation
  AppDimensions._();

  // ==========================================================================
  // SPACING & PADDING
  // ==========================================================================
  
  /// Extra small spacing - 4dp
  static const double spacingXXS = 4.0;
  
  /// Extra small spacing - 8dp
  static const double spacingXS = 8.0;
  
  /// Small spacing - 12dp
  static const double spacingS = 12.0;
  
  /// Medium spacing - 16dp (Base unit)
  static const double spacingM = 16.0;
  
  /// Large spacing - 24dp
  static const double spacingL = 24.0;
  
  /// Extra large spacing - 32dp
  static const double spacingXL = 32.0;
  
  /// Extra extra large spacing - 48dp
  static const double spacingXXL = 48.0;
  
  /// Huge spacing - 64dp
  static const double spacingHuge = 64.0;

  // ==========================================================================
  // MARGINS
  // ==========================================================================
  
  /// Screen horizontal margin
  static const double screenMarginHorizontal = spacingM;
  
  /// Screen vertical margin
  static const double screenMarginVertical = spacingL;
  
  /// Card margin
  static const double cardMargin = spacingS;
  
  /// List item margin
  static const double listItemMargin = spacingXS;
  
  /// Section margin
  static const double sectionMargin = spacingL;

  // ==========================================================================
  // PADDING
  // ==========================================================================
  
  /// Default screen padding
  static const EdgeInsets screenPadding = EdgeInsets.all(spacingM);
  
  /// Screen padding with safe area
  static const EdgeInsets screenPaddingWithSafeArea = EdgeInsets.only(
    left: spacingM,
    right: spacingM,
    top: spacingL,
    bottom: spacingM,
  );
  
  /// Card padding
  static const EdgeInsets cardPadding = EdgeInsets.all(spacingM);
  
  /// Button padding
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: spacingL,
    vertical: spacingS,
  );
  
  /// Small button padding
  static const EdgeInsets smallButtonPadding = EdgeInsets.symmetric(
    horizontal: spacingM,
    vertical: spacingXS,
  );
  
  /// Large button padding
  static const EdgeInsets largeButtonPadding = EdgeInsets.symmetric(
    horizontal: spacingXL,
    vertical: spacingM,
  );
  
  /// Input field padding
  static const EdgeInsets inputPadding = EdgeInsets.symmetric(
    horizontal: spacingM,
    vertical: spacingS,
  );
  
  /// List item padding
  static const EdgeInsets listItemPadding = EdgeInsets.symmetric(
    horizontal: spacingM,
    vertical: spacingS,
  );
  
  /// Dialog padding
  static const EdgeInsets dialogPadding = EdgeInsets.all(spacingL);
  
  /// Bottom sheet padding
  static const EdgeInsets bottomSheetPadding = EdgeInsets.all(spacingM);
  
  /// Tab padding
  static const EdgeInsets tabPadding = EdgeInsets.symmetric(
    horizontal: spacingM,
    vertical: spacingS,
  );

  // ==========================================================================
  // HEIGHTS
  // ==========================================================================
  
  /// App bar height
  static const double appBarHeight = 56.0;
  
  /// Bottom navigation bar height
  static const double bottomNavHeight = 60.0;
  
  /// Tab bar height
  static const double tabBarHeight = 48.0;
  
  /// Button height - small
  static const double buttonHeightSmall = 32.0;
  
  /// Button height - medium (default)
  static const double buttonHeightMedium = 48.0;
  
  /// Button height - large
  static const double buttonHeightLarge = 56.0;
  
  /// Input field height
  static const double inputHeight = 48.0;
  
  /// Large input field height (multiline)
  static const double inputHeightLarge = 96.0;
  
  /// List item height - small
  static const double listItemHeightSmall = 48.0;
  
  /// List item height - medium
  static const double listItemHeightMedium = 64.0;
  
  /// List item height - large
  static const double listItemHeightLarge = 72.0;
  
  /// Card minimum height
  static const double cardMinHeight = 120.0;
  
  /// Drawer header height
  static const double drawerHeaderHeight = 164.0;
  
  /// Loading indicator height
  static const double loadingIndicatorHeight = 48.0;
  
  /// Floating Action Button height
  static const double fabHeight = 56.0;
  
  /// Small FAB height
  static const double fabSmallHeight = 40.0;

  // ==========================================================================
  // WIDTHS
  // ==========================================================================
  
  /// Button minimum width
  static const double buttonMinWidth = 64.0;
  
  /// Dialog minimum width
  static const double dialogMinWidth = 280.0;
  
  /// Dialog maximum width
  static const double dialogMaxWidth = 400.0;
  
  /// Drawer width
  static const double drawerWidth = 304.0;
  
  /// Side panel width (tablet/desktop)
  static const double sidePanelWidth = 320.0;
  
  /// Maximum content width (for large screens)
  static const double maxContentWidth = 600.0;
  
  /// Avatar size - small
  static const double avatarSizeSmall = 24.0;
  
  /// Avatar size - medium
  static const double avatarSizeMedium = 40.0;
  
  /// Avatar size - large
  static const double avatarSizeLarge = 64.0;
  
  /// Avatar size - extra large
  static const double avatarSizeXL = 96.0;

  // ==========================================================================
  // BORDER RADIUS
  // ==========================================================================
  
  /// Border radius - small (4dp)
  static const double radiusSmall = 4.0;
  
  /// Border radius - medium (8dp)
  static const double radiusMedium = 8.0;
  
  /// Border radius - large (12dp)
  static const double radiusLarge = 12.0;
  
  /// Border radius - extra large (16dp)
  static const double radiusXL = 16.0;
  
  /// Border radius - huge (24dp)
  static const double radiusHuge = 24.0;
  
  /// Circular border radius
  static const double radiusCircular = 50.0;
  
  /// Card border radius
  static const double cardRadius = radiusMedium;
  
  /// Button border radius
  static const double buttonRadius = radiusMedium;
  
  /// Input field border radius
  static const double inputRadius = radiusMedium;
  
  /// Dialog border radius
  static const double dialogRadius = radiusLarge;

  // ==========================================================================
  // BORDER WIDTHS
  // ==========================================================================
  
  /// Thin border width
  static const double borderWidthThin = 0.5;
  
  /// Default border width
  static const double borderWidthDefault = 1.0;
  
  /// Thick border width
  static const double borderWidthThick = 2.0;
  
  /// Focus border width
  static const double borderWidthFocus = 2.0;

  // ==========================================================================
  // ELEVATION
  // ==========================================================================
  
  /// No elevation
  static const double elevationNone = 0.0;
  
  /// Low elevation
  static const double elevationLow = 2.0;
  
  /// Medium elevation
  static const double elevationMedium = 4.0;
  
  /// High elevation
  static const double elevationHigh = 8.0;
  
  /// App bar elevation
  static const double elevationAppBar = elevationMedium;
  
  /// Card elevation
  static const double elevationCard = elevationLow;
  
  /// Dialog elevation
  static const double elevationDialog = elevationHigh;
  
  /// FAB elevation
  static const double elevationFAB = 6.0;

  // ==========================================================================
  // ICON SIZES
  // ==========================================================================
  
  /// Small icon size
  static const double iconSizeSmall = 16.0;
  
  /// Default icon size
  static const double iconSizeDefault = 24.0;
  
  /// Large icon size
  static const double iconSizeLarge = 32.0;
  
  /// Extra large icon size
  static const double iconSizeXL = 48.0;
  
  /// App bar icon size
  static const double iconSizeAppBar = iconSizeDefault;
  
  /// Tab icon size
  static const double iconSizeTab = iconSizeDefault;
  
  /// FAB icon size
  static const double iconSizeFAB = iconSizeDefault;

  // ==========================================================================
  // RESPONSIVE BREAKPOINTS
  // ==========================================================================
  
  /// Mobile breakpoint
  static const double breakpointMobile = 600.0;
  
  /// Tablet breakpoint
  static const double breakpointTablet = 960.0;
  
  /// Desktop breakpoint
  static const double breakpointDesktop = 1280.0;
  
  /// Large desktop breakpoint
  static const double breakpointLargeDesktop = 1920.0;

  // ==========================================================================
  // ANIMATION DURATIONS
  // ==========================================================================
  
  /// Short animation duration
  static const Duration animationDurationShort = Duration(milliseconds: 150);
  
  /// Medium animation duration
  static const Duration animationDurationMedium = Duration(milliseconds: 300);
  
  /// Long animation duration
  static const Duration animationDurationLong = Duration(milliseconds: 500);
  
  /// Page transition duration
  static const Duration pageTransitionDuration = Duration(milliseconds: 250);

  // ==========================================================================
  // UTILITY METHODS
  // ==========================================================================
  
  /// Get responsive padding based on screen width
  static EdgeInsets getResponsivePadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (screenWidth >= breakpointDesktop) {
      return const EdgeInsets.all(spacingXL);
    } else if (screenWidth >= breakpointTablet) {
      return const EdgeInsets.all(spacingL);
    } else {
      return const EdgeInsets.all(spacingM);
    }
  }
  
  /// Get responsive margin based on screen width
  static EdgeInsets getResponsiveMargin(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (screenWidth >= breakpointDesktop) {
      return const EdgeInsets.symmetric(horizontal: spacingXXL);
    } else if (screenWidth >= breakpointTablet) {
      return const EdgeInsets.symmetric(horizontal: spacingXL);
    } else {
      return const EdgeInsets.symmetric(horizontal: spacingM);
    }
  }
  
  /// Check if screen is mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < breakpointMobile;
  }
  
  /// Check if screen is tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= breakpointMobile && width < breakpointDesktop;
  }
  
  /// Check if screen is desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= breakpointDesktop;
  }
  
  /// Get appropriate content width for current screen
  static double getContentWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (screenWidth >= breakpointDesktop) {
      return maxContentWidth;
    } else {
      return screenWidth - (screenMarginHorizontal * 2);
    }
  }
}

/// Extension methods for EdgeInsets to work with AppDimensions
extension AppDimensionsEdgeInsets on EdgeInsets {
  /// Add spacing to all sides
  EdgeInsets addAll(double spacing) {
    return EdgeInsets.only(
      left: left + spacing,
      top: top + spacing,
      right: right + spacing,
      bottom: bottom + spacing,
    );
  }
  
  /// Add horizontal spacing
  EdgeInsets addHorizontal(double spacing) {
    return EdgeInsets.only(
      left: left + spacing,
      top: top,
      right: right + spacing,
      bottom: bottom,
    );
  }
  
  /// Add vertical spacing
  EdgeInsets addVertical(double spacing) {
    return EdgeInsets.only(
      left: left,
      top: top + spacing,
      right: right,
      bottom: bottom + spacing,
    );
  }
}

// usage example
// Container(
//   margin: EdgeInsets.all(AppDimensions.spacingM),
//   padding: AppDimensions.cardPadding,
//   child: Text('Hello World'),
// )

// // Responsive padding
// Container(
//   padding: AppDimensions.getResponsivePadding(context),
//   child: MyWidget(),
// )

// // Standard button
// ElevatedButton(
//   style: ElevatedButton.styleFrom(
//     minimumSize: Size(AppDimensions.buttonMinWidth, AppDimensions.buttonHeightMedium),
//     padding: AppDimensions.buttonPadding,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
//     ),
//   ),
//   onPressed: () {},
//   child: Text('Button'),
// )