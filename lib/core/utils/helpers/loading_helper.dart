import 'package:flutter/material.dart';

class FullScreenLoader {
  static bool _isShowing = false;
  static OverlayEntry? _overlayEntry;

  /// Show the full screen loader
  /// Only one instance can exist at a time - subsequent calls will be ignored
  static void show(
    BuildContext context, {
    String? message,
    Color backgroundColor = Colors.black54,
    Color indicatorColor = Colors.white,
  }) {
    // If loader is already showing, ignore the request
    if (_isShowing) {
      return;
    }

    _isShowing = true;

    _overlayEntry = OverlayEntry(
      builder: (context) => _LoaderWidget(
        message: message,
        backgroundColor: backgroundColor,
        indicatorColor: indicatorColor,
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  /// Hide the full screen loader
  static void hide() {
    if (!_isShowing || _overlayEntry == null) return;

    _overlayEntry!.remove();
    _overlayEntry = null;
    _isShowing = false;
  }

  /// Check if loader is currently showing
  static bool get isShowing => _isShowing;
}

class _LoaderWidget extends StatefulWidget {
  const _LoaderWidget({
    this.message,
    required this.backgroundColor,
    required this.indicatorColor,
  });

  final Color backgroundColor;
  final Color indicatorColor;
  final String? message;

  @override
  State<_LoaderWidget> createState() => _LoaderWidgetState();
}

class _LoaderWidgetState extends State<_LoaderWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: widget.backgroundColor,
              child: PopScope(
                canPop: false, // Prevent back button
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Loading indicator
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(
                          strokeWidth: 4,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            widget.indicatorColor,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Loading message
                      if (widget.message != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            widget.message!,
                            style: TextStyle(
                              color: widget.indicatorColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Extension for easier usage
extension LoaderContext on BuildContext {
  void showLoader({
    String? message,
    Color backgroundColor = Colors.black54,
    Color indicatorColor = Colors.white,
  }) {
    FullScreenLoader.show(
      this,
      message: message,
      backgroundColor: backgroundColor,
      indicatorColor: indicatorColor,
    );
  }

  void hideLoader() {
    FullScreenLoader.hide();
  }
}