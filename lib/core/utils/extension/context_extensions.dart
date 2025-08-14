// context_extensions.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Extension methods for BuildContext to add common functionality
extension BuildContextExtensions on BuildContext {
  // ==================== THEME EXTENSIONS ====================

  /// Gets the current theme data
  ThemeData get theme => Theme.of(this);

  /// Gets the current text theme
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Gets the current color scheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Gets primary color
  Color get primaryColor => Theme.of(this).primaryColor;

  /// Gets accent color
  Color get accentColor => Theme.of(this).colorScheme.secondary;

  /// Gets background color
  Color get backgroundColor => Theme.of(this).scaffoldBackgroundColor;

  /// Gets surface color
  Color get surfaceColor => Theme.of(this).colorScheme.surface;

  /// Gets error color
  Color get errorColor => Theme.of(this).colorScheme.error;

  /// Checks if current theme is dark
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  /// Checks if current theme is light
  bool get isLightMode => Theme.of(this).brightness == Brightness.light;

  // ==================== MEDIA QUERY EXTENSIONS ====================

  /// Gets the current media query data
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Gets screen size
  Size get screenSize => MediaQuery.of(this).size;

  /// Gets screen width
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Gets screen height
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Gets device pixel ratio
  double get pixelRatio => MediaQuery.of(this).devicePixelRatio;

  /// Gets text scale factor
  double get textScaleFactor => MediaQuery.of(this).textScaler.scale(1);

  /// Gets system padding (status bar, notch, etc.)
  EdgeInsets get padding => MediaQuery.of(this).padding;

  /// Gets view insets (keyboard, etc.)
  EdgeInsets get viewInsets => MediaQuery.of(this).viewInsets;

  /// Gets view padding
  EdgeInsets get viewPadding => MediaQuery.of(this).viewPadding;

  /// Gets status bar height
  double get statusBarHeight => MediaQuery.of(this).padding.top;

  /// Gets bottom safe area height
  double get bottomSafeArea => MediaQuery.of(this).padding.bottom;

  /// Gets keyboard height
  double get keyboardHeight => MediaQuery.of(this).viewInsets.bottom;

  /// Checks if keyboard is visible
  bool get isKeyboardVisible => MediaQuery.of(this).viewInsets.bottom > 0;

  // ==================== RESPONSIVE DESIGN EXTENSIONS ====================

  /// Checks if screen is mobile size (< 600px)
  bool get isMobile => screenWidth < 600;

  /// Checks if screen is tablet size (600px - 1024px)
  bool get isTablet => screenWidth >= 600 && screenWidth < 1024;

  /// Checks if screen is desktop size (>= 1024px)
  bool get isDesktop => screenWidth >= 1024;

  /// Gets responsive value based on screen size
  T responsive<T>({required T mobile, T? tablet, T? desktop}) {
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }

  /// Gets percentage of screen width
  double widthPercent(double percent) => screenWidth * (percent / 100);

  /// Gets percentage of screen height
  double heightPercent(double percent) => screenHeight * (percent / 100);

  // ==================== NAVIGATION EXTENSIONS ====================

  /// Pushes a new route
  Future<T?> push<T>(Widget page) {
    return Navigator.of(this).push<T>(MaterialPageRoute(builder: (_) => page));
  }

  /// Pushes a route with custom page route
  Future<T?> pushRoute<T>(Route<T> route) {
    return Navigator.of(this).push<T>(route);
  }

  /// Pushes and replaces current route
  Future<T?> pushReplacement<T, TO>(Widget page, {TO? result}) {
    return Navigator.of(this).pushReplacement<T, TO>(
      MaterialPageRoute(builder: (_) => page),
      result: result,
    );
  }

  /// Pushes and removes all previous routes
  Future<T?> pushAndClearStack<T>(Widget page) {
    return Navigator.of(this).pushAndRemoveUntil<T>(
      MaterialPageRoute(builder: (_) => page),
      (route) => false,
    );
  }

  /// Pops current route
  void pop<T>([T? result]) {
    Navigator.of(this).pop<T>(result);
  }

  /// Pops until a specific route
  void popUntil(RoutePredicate predicate) {
    Navigator.of(this).popUntil(predicate);
  }

  /// Checks if can pop
  bool get canPop => Navigator.of(this).canPop();

  /// Pushes named route
  Future<T?> pushNamed<T>(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushNamed<T>(routeName, arguments: arguments);
  }

  /// Pushes named route and replaces current
  Future<T?> pushNamedReplacement<T, TO>(
    String routeName, {
    Object? arguments,
    TO? result,
  }) {
    return Navigator.of(this).pushReplacementNamed<T, TO>(
      routeName,
      arguments: arguments,
      result: result,
    );
  }

  // Usage example
  // Basic usage (most common)
  // context.pushNamedReplacement('/home');

  // // With arguments
  // context.pushNamedReplacement('/profile', arguments: {'userId': 123});

  // // With result for the replaced route
  // context.pushNamedReplacement<String, bool>(
  //   '/settings',
  //   result: true, // This gets passed to the route being replaced
  // );

  // // Full typed usage
  // Future<UserData?> result = context.pushNamedReplacement<UserData, void>(
  //   '/user-details',
  //   arguments: {'id': userId},
  // );

  // ==================== SNACKBAR EXTENSIONS ====================

  /// Shows a snackbar with message
  void showSnackBar(
    String message, {
    Color? backgroundColor,
    Color? textColor,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: textColor)),
        backgroundColor: backgroundColor,
        duration: duration,
        action: action,
      ),
    );
  }

  /// Shows success snackbar
  void showSuccessSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    showSnackBar(
      message,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      duration: duration,
    );
  }

  /// Shows error snackbar
  void showErrorSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 4),
  }) {
    showSnackBar(
      message,
      backgroundColor: errorColor,
      textColor: Colors.white,
      duration: duration,
    );
  }

  /// Shows warning snackbar
  void showWarningSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    showSnackBar(
      message,
      backgroundColor: Colors.orange,
      textColor: Colors.white,
      duration: duration,
    );
  }

  /// Hides current snackbar
  void hideSnackBar() {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
  }

  // ==================== DIALOG EXTENSIONS ====================

  /// Shows a simple alert dialog
  Future<T?> showAlertDialog<T>({
    required String title,
    required String content,
    String confirmText = 'OK',
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return showDialog<T>(
      context: this,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          if (cancelText != null)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onCancel?.call();
              },
              child: Text(cancelText),
            ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              onConfirm?.call();
            },
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  /// Shows a confirmation dialog
  Future<bool?> showConfirmDialog({
    required String title,
    required String content,
    String confirmText = 'Yes',
    String cancelText = 'No',
  }) {
    return showDialog<bool>(
      context: this,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  /// Shows loading dialog
  void showLoadingDialog({String? message}) {
    showDialog(
      context: this,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 20),
            Text(message ?? 'Loading...'),
          ],
        ),
      ),
    );
  }

  /// Hides loading dialog
  void hideLoadingDialog() {
    Navigator.of(this).pop();
  }

  // ==================== MODAL BOTTOM SHEET EXTENSIONS ====================

  /// Shows modal bottom sheet
  Future<T?> showBottomSheet<T>(Widget child) {
    return showModalBottomSheet<T>(context: this, builder: (_) => child);
  }

  /// Shows scrollable modal bottom sheet
  Future<T?> showScrollableBottomSheet<T>(Widget child) {
    return showModalBottomSheet<T>(
      context: this,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, controller) => child,
      ),
    );
  }

  // ==================== FOCUS EXTENSIONS ====================

  /// Unfocuses current focus (hides keyboard)
  void unfocus() {
    FocusScope.of(this).unfocus();
  }

  /// Requests focus for a specific focus node
  void requestFocus(FocusNode focusNode) {
    FocusScope.of(this).requestFocus(focusNode);
  }

  /// Gets current focus node
  FocusNode? get currentFocus => FocusScope.of(this).focusedChild;

  // ==================== FORM EXTENSIONS ====================

  /// Gets closest form state
  FormState? get form => Form.of(this);

  /// Validates form
  bool validateForm() => form?.validate() ?? false;

  /// Saves form
  void saveForm() => form?.save();

  /// Resets form
  void resetForm() => form?.reset();

  // ==================== SCAFFOLD EXTENSIONS ====================

  /// Gets scaffold state
  ScaffoldState get scaffold => Scaffold.of(this);

  /// Opens drawer
  void openDrawer() => scaffold.openDrawer();

  /// Opens end drawer
  void openEndDrawer() => scaffold.openEndDrawer();

  /// Closes drawer
  void closeDrawer() => scaffold.closeDrawer();

  /// Closes end drawer
  void closeEndDrawer() => scaffold.closeEndDrawer();

  // ==================== UTILITY EXTENSIONS ====================

  /// Copies text to clipboard
  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    showSuccessSnackBar('Copied to clipboard');
  }

  /// Gets text direction
  TextDirection get textDirection => Directionality.of(this);

  /// Checks if text direction is RTL
  bool get isRTL => textDirection == TextDirection.rtl;

  /// Checks if text direction is LTR
  bool get isLTR => textDirection == TextDirection.ltr;

  /// Delays execution
  Future<void> delay(Duration duration) {
    return Future.delayed(duration);
  }

  /// Posts frame callback
  void postFrame(VoidCallback callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) => callback());
  }
}
