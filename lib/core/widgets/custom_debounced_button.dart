import 'package:flutter/material.dart';

enum ButtonState { idle, pressed, loading }

class CustomDebouncedButton extends StatefulWidget {
  const CustomDebouncedButton({
    super.key,
    required this.text,
    this.icon,
    this.onPressed,
    this.debounceDuration = const Duration(milliseconds: 300),
    this.backgroundColor,
    this.foregroundColor,
    this.disabledBackgroundColor,
    this.disabledForegroundColor,
    this.padding,
    this.borderRadius,
    this.elevation,
    this.minimumSize,
    this.textStyle,
    this.iconSize = 20.0,
  });

  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final Duration debounceDuration;
  final Color? disabledBackgroundColor;
  final Color? disabledForegroundColor;
  final double? elevation;
  final Color? foregroundColor;
  final IconData? icon;
  final double? iconSize;
  final Size? minimumSize;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry? padding;
  final String text;
  final TextStyle? textStyle;

  @override
  State<CustomDebouncedButton> createState() => _CustomDebouncedButtonState();
}

class _CustomDebouncedButtonState extends State<CustomDebouncedButton>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  ButtonState _currentState = ButtonState.idle;
  bool _isDisabled = false;
  late Animation<double> _scaleAnimation;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  void _handlePress() async {
    if (_isDisabled || widget.onPressed == null) return;

    // Start press animation
    _animationController.forward();
    
    setState(() {
      _currentState = ButtonState.pressed;
      _isDisabled = true;
    });

    // Show icon briefly
    await Future.delayed(const Duration(milliseconds: 200));
    
    if (mounted) {
      setState(() {
        _currentState = ButtonState.loading;
      });
    }

    // Reverse press animation
    _animationController.reverse();

    // Execute the callback
    try {
      widget.onPressed?.call();
    } catch (e) {
      // Handle any errors from the callback
      debugPrint('Button callback error: $e');
    }

    // Debounce delay
    await Future.delayed(widget.debounceDuration);

    // Reset state
    if (mounted) {
      setState(() {
        _currentState = ButtonState.idle;
        _isDisabled = false;
      });
    }
  }

  Widget _buildChild() {
    switch (_currentState) {
      case ButtonState.idle:
        return Text(
          widget.text,
          style: widget.textStyle,
        );
      case ButtonState.pressed:
        return widget.icon != null
            ? Icon(
                widget.icon,
                size: widget.iconSize,
              )
            : Text(
                widget.text,
                style: widget.textStyle,
              );
      case ButtonState.loading:
        return SizedBox(
          width: widget.iconSize ?? 20.0,
          height: widget.iconSize ?? 20.0,
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
            valueColor: AlwaysStoppedAnimation<Color>(
              widget.foregroundColor ?? Colors.white,
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: ElevatedButton(
            onPressed: _isDisabled ? null : _handlePress,
            style: ElevatedButton.styleFrom(
              backgroundColor: _isDisabled
                  ? (widget.disabledBackgroundColor ?? 
                     colorScheme.onSurface.withValues(alpha: 0.12))
                  : (widget.backgroundColor ?? colorScheme.primary),
              foregroundColor: _isDisabled
                  ? (widget.disabledForegroundColor ?? 
                     colorScheme.onSurface.withValues(alpha: 0.38))
                  : (widget.foregroundColor ?? colorScheme.onPrimary),
              padding: widget.padding ?? 
                       const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
              ),
              elevation: widget.elevation ?? 2,
              minimumSize: widget.minimumSize ?? const Size(88, 36),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale: animation,
                    child: child,
                  ),
                );
              },
              child: _buildChild(),
            ),
          ),
        );
      },
    );
  }
}

// Example usage widget
class ButtonExample extends StatelessWidget {
  const ButtonExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Debounced Button'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomDebouncedButton(
              text: 'Submit',
              icon: Icons.check,
              onPressed: () {
                // Simulate API call or async operation
                debugPrint('Button pressed - performing async operation');
              },
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              debounceDuration: const Duration(seconds: 2),
            ),
            const SizedBox(height: 20),
            CustomDebouncedButton(
              text: 'Save',
              icon: Icons.save,
              onPressed: () {
                debugPrint('Save button pressed');
              },
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              debounceDuration: const Duration(milliseconds: 1500),
              borderRadius: BorderRadius.circular(25),
            ),
            const SizedBox(height: 20),
            CustomDebouncedButton(
              text: 'Delete',
              icon: Icons.delete,
              onPressed: () {
                debugPrint('Delete button pressed');
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              debounceDuration: const Duration(seconds: 1),
              minimumSize: const Size(120, 50),
            ),
          ],
        ),
      ),
    );
  }
}