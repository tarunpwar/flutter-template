import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension WidgetExtensions on Widget {
  /// Wraps widget with Padding
  Widget padding(EdgeInsetsGeometry padding) {
    return Padding(padding: padding, child: this);
  }

  /// Adds symmetric padding
  Widget paddingSymmetric({double horizontal = 0.0, double vertical = 0.0}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
      child: this,
    );
  }

  /// Adds padding on all sides
  Widget paddingAll(double padding) {
    return Padding(padding: EdgeInsets.all(padding), child: this);
  }

  /// Adds padding only on specific sides
  Widget paddingOnly({
    double left = 0.0,
    double top = 0.0,
    double right = 0.0,
    double bottom = 0.0,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        left: left,
        top: top,
        right: right,
        bottom: bottom,
      ),
      child: this,
    );
  }

  /// Wraps widget with Margin (Container with margin)
  Widget margin(EdgeInsetsGeometry margin) {
    return Container(margin: margin, child: this);
  }

  /// Adds symmetric margin
  Widget marginSymmetric({double horizontal = 0.0, double vertical = 0.0}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
      child: this,
    );
  }

  /// Adds margin on all sides
  Widget marginAll(double margin) {
    return Container(margin: EdgeInsets.all(margin), child: this);
  }

  /// Adds margin only on specific sides
  Widget marginOnly({
    double left = 0.0,
    double top = 0.0,
    double right = 0.0,
    double bottom = 0.0,
  }) {
    return Container(
      margin: EdgeInsets.only(
        left: left,
        top: top,
        right: right,
        bottom: bottom,
      ),
      child: this,
    );
  }

  /// Centers the widget
  Widget get center => Center(child: this);

  /// Aligns widget to specific alignment
  Widget align(AlignmentGeometry alignment) {
    return Align(alignment: alignment, child: this);
  }

  /// Aligns widget to center left
  Widget get centerLeft => Align(alignment: Alignment.centerLeft, child: this);

  /// Aligns widget to center right
  Widget get centerRight =>
      Align(alignment: Alignment.centerRight, child: this);

  /// Aligns widget to top center
  Widget get topCenter => Align(alignment: Alignment.topCenter, child: this);

  /// Aligns widget to bottom center
  Widget get bottomCenter =>
      Align(alignment: Alignment.bottomCenter, child: this);

  /// Expands the widget
  Widget get expanded => Expanded(child: this);

  /// Expands the widget with flex
  Widget expand({int flex = 1}) => Expanded(flex: flex, child: this);

  /// Wraps with Flexible
  Widget get flexible => Flexible(child: this);

  /// Wraps with Flexible with flex
  Widget flex({int flex = 1}) => Flexible(flex: flex, child: this);

  /// Sets fixed width and height
  Widget size({double? width, double? height}) {
    return SizedBox(width: width, height: height, child: this);
  }

  /// Sets fixed width
  Widget width(double width) => SizedBox(width: width, child: this);

  /// Sets fixed height
  Widget height(double height) => SizedBox(height: height, child: this);

  /// Makes widget take full width
  Widget get fullWidth => SizedBox(width: double.infinity, child: this);

  /// Makes widget take full height
  Widget get fullHeight => SizedBox(height: double.infinity, child: this);

  /// Wraps with Container
  Widget container({
    Key? key,
    AlignmentGeometry? alignment,
    EdgeInsetsGeometry? padding,
    Color? color,
    Decoration? decoration,
    Decoration? foregroundDecoration,
    double? width,
    double? height,
    BoxConstraints? constraints,
    EdgeInsetsGeometry? margin,
    Matrix4? transform,
    AlignmentGeometry? transformAlignment,
    Clip clipBehavior = Clip.none,
  }) {
    return Container(
      key: key,
      alignment: alignment,
      padding: padding,
      color: color,
      decoration: decoration,
      foregroundDecoration: foregroundDecoration,
      width: width,
      height: height,
      constraints: constraints,
      margin: margin,
      transform: transform,
      transformAlignment: transformAlignment,
      clipBehavior: clipBehavior,
      child: this,
    );
  }

  /// Adds background color
  Widget backgroundColor(Color color) {
    return Container(color: color, child: this);
  }

  /// Adds border radius
  Widget borderRadius(double radius) {
    return ClipRRect(borderRadius: BorderRadius.circular(radius), child: this);
  }

  /// Adds custom border radius
  Widget borderRadiusCustom(BorderRadius borderRadius) {
    return ClipRRect(borderRadius: borderRadius, child: this);
  }

  /// Adds circular border radius
  Widget get circular =>
      ClipRRect(borderRadius: BorderRadius.circular(1000), child: this);

  /// Adds elevation (shadow)
  Widget elevation(
    double elevation, {
    Color shadowColor = Colors.black54,
    double? blurRadius,
  }) {
    return Material(
      elevation: elevation,
      shadowColor: shadowColor,
      child: this,
    );
  }

  /// Makes widget clickable with InkWell
  Widget onTap(
    VoidCallback? onTap, {
    VoidCallback? onDoubleTap,
    VoidCallback? onLongPress,
    Color? splashColor,
    Color? highlightColor,
    double? borderRadius,
  }) {
    return InkWell(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      onLongPress: onLongPress,
      splashColor: splashColor,
      highlightColor: highlightColor,
      borderRadius: borderRadius != null
          ? BorderRadius.circular(borderRadius)
          : null,
      child: this,
    );
  }

  /// Makes widget clickable with GestureDetector
  Widget onGesture({
    VoidCallback? onTap,
    VoidCallback? onDoubleTap,
    VoidCallback? onLongPress,
    VoidCallback? onTapDown,
    VoidCallback? onTapUp,
    VoidCallback? onTapCancel,
  }) {
    return GestureDetector(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      onLongPress: onLongPress,
      child: this,
    );
  }

  /// Adds opacity
  Widget opacity(double opacity) {
    return Opacity(opacity: opacity, child: this);
  }

  /// Adds visibility control
  Widget visible(bool visible) {
    return Visibility(visible: visible, child: this);
  }

  /// Conditionally shows widget
  Widget showIf(bool condition) {
    return condition ? this : const SizedBox.shrink();
  }

  /// Adds rotation
  Widget rotate(double angle) {
    return Transform.rotate(angle: angle, child: this);
  }

  /// Adds scaling
  Widget scale(double scale) {
    return Transform.scale(scale: scale, child: this);
  }

  /// Adds translation
  Widget translate({double x = 0.0, double y = 0.0}) {
    return Transform.translate(offset: Offset(x, y), child: this);
  }

  /// Adds custom decoration
  Widget decorated({
    Color? color,
    DecorationImage? image,
    Border? border,
    BorderRadius? borderRadius,
    List<BoxShadow>? boxShadow,
    Gradient? gradient,
    BlendMode? backgroundBlendMode,
    BoxShape shape = BoxShape.rectangle,
  }) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        image: image,
        border: border,
        borderRadius: borderRadius,
        boxShadow: boxShadow,
        gradient: gradient,
        backgroundBlendMode: backgroundBlendMode,
        shape: shape,
      ),
      child: this,
    );
  }

  /// Adds gradient background
  Widget gradient(Gradient gradient) {
    return Container(
      decoration: BoxDecoration(gradient: gradient),
      child: this,
    );
  }

  /// Adds linear gradient background
  Widget linearGradient({
    required List<Color> colors,
    AlignmentGeometry begin = Alignment.centerLeft,
    AlignmentGeometry end = Alignment.centerRight,
    List<double>? stops,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: begin,
          end: end,
          stops: stops,
        ),
      ),
      child: this,
    );
  }

  /// Adds radial gradient background
  Widget radialGradient({
    required List<Color> colors,
    AlignmentGeometry center = Alignment.center,
    double radius = 0.5,
    List<double>? stops,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: colors,
          center: center,
          radius: radius,
          stops: stops,
        ),
      ),
      child: this,
    );
  }

  /// Adds shadow
  Widget shadow({
    Color color = Colors.black26,
    double blurRadius = 6.0,
    Offset offset = const Offset(0, 2),
  }) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: color, blurRadius: blurRadius, offset: offset),
        ],
      ),
      child: this,
    );
  }

  /// Adds border
  Widget border({
    Color color = Colors.grey,
    double width = 1.0,
    BorderStyle style = BorderStyle.solid,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: color, width: width, style: style),
      ),
      child: this,
    );
  }

  /// Wraps with Card
  Widget card({
    Color? color,
    double? elevation,
    ShapeBorder? shape,
    bool borderOnForeground = true,
    EdgeInsetsGeometry? margin,
    Clip? clipBehavior,
    Color? shadowColor,
    Color? surfaceTintColor,
  }) {
    return Card(
      color: color,
      elevation: elevation,
      shape: shape,
      borderOnForeground: borderOnForeground,
      margin: margin,
      clipBehavior: clipBehavior,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      child: this,
    );
  }

  /// Wraps with Hero animation
  Widget hero(String tag) {
    return Hero(tag: tag, child: this);
  }

  /// Adds fade transition
  Widget fadeIn({
    Duration duration = const Duration(milliseconds: 300),
    double begin = 0.0,
    double end = 1.0,
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      tween: Tween<double>(begin: begin, end: end),
      builder: (context, value, child) => Opacity(opacity: value, child: child),
      child: this,
    );
  }

  /// Adds slide transition
  Widget slideIn({
    Duration duration = const Duration(milliseconds: 300),
    Offset begin = const Offset(0, 1),
    Offset end = Offset.zero,
  }) {
    return TweenAnimationBuilder<Offset>(
      duration: duration,
      tween: Tween<Offset>(begin: begin, end: end),
      builder: (context, value, child) => Transform.translate(
        offset: Offset(value.dx * 100, value.dy * 100),
        child: child,
      ),
      child: this,
    );
  }

  /// Wraps with SafeArea
  Widget get safeArea => SafeArea(child: this);

  /// Wraps with SafeArea with custom options
  Widget safeAreaCustom({
    bool left = true,
    bool top = true,
    bool right = true,
    bool bottom = true,
  }) {
    return SafeArea(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      child: this,
    );
  }

  /// Wraps with Positioned (for Stack children)
  Widget positioned({
    double? left,
    double? top,
    double? right,
    double? bottom,
    double? width,
    double? height,
  }) {
    return Positioned(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      width: width,
      height: height,
      child: this,
    );
  }

  /// Positions widget at top-left
  Widget get positionedTopLeft => positioned(top: 0, left: 0);

  /// Positions widget at top-right
  Widget get positionedTopRight => positioned(top: 0, right: 0);

  /// Positions widget at bottom-left
  Widget get positionedBottomLeft => positioned(bottom: 0, left: 0);

  /// Positions widget at bottom-right
  Widget get positionedBottomRight => positioned(bottom: 0, right: 0);

  /// Adds tooltip
  Widget tooltip(String message) {
    return Tooltip(message: message, child: this);
  }

  /// Wraps with Scrollable SingleChildScrollView
  Widget scrollable({
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    EdgeInsetsGeometry? padding,
    ScrollPhysics? physics,
  }) {
    return SingleChildScrollView(
      scrollDirection: scrollDirection,
      reverse: reverse,
      padding: padding,
      physics: physics,
      child: this,
    );
  }

  /// Makes widget dismissible
  Widget dismissible({
    required String key,
    VoidCallback? onDismissed,
    DismissDirection direction = DismissDirection.endToStart,
    Widget? background,
    Widget? secondaryBackground,
  }) {
    return Dismissible(
      key: Key(key),
      onDismissed: (_) => onDismissed?.call(),
      direction: direction,
      background: background,
      secondaryBackground: secondaryBackground,
      child: this,
    );
  }

  /// Adds haptic feedback on tap
  Widget hapticFeedback({
    required VoidCallback onTap,
    HapticFeedbackType type = HapticFeedbackType.selection,
  }) {
    return GestureDetector(
      onTap: () {
        switch (type) {
          case HapticFeedbackType.selection:
            HapticFeedback.selectionClick();
            break;
          case HapticFeedbackType.impact:
            HapticFeedback.mediumImpact();
            break;
          case HapticFeedbackType.light:
            HapticFeedback.lightImpact();
            break;
          case HapticFeedbackType.medium:
            HapticFeedback.mediumImpact();
            break;
          case HapticFeedbackType.heavy:
            HapticFeedback.heavyImpact();
            break;
        }
        onTap();
      },
      child: this,
    );
  }

  /// Wraps with AnimatedContainer for smooth transitions
  Widget animatedContainer({
    Duration duration = const Duration(milliseconds: 200),
    Curve curve = Curves.ease,
    double? width,
    double? height,
    Color? color,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Decoration? decoration,
  }) {
    return AnimatedContainer(
      duration: duration,
      curve: curve,
      width: width,
      height: height,
      color: color,
      padding: padding,
      margin: margin,
      decoration: decoration,
      child: this,
    );
  }
}

enum HapticFeedbackType { selection, impact, light, medium, heavy }


// Basic styling and spacing
// Text('Hello World')
//     .paddingAll(16)
//     .backgroundColor(Colors.blue)
//     .borderRadius(12)
//     .center;

// // Complex styling chain
// Container(child: Text('Styled Widget'))
//     .paddingSymmetric(horizontal: 20, vertical: 10)
//     .backgroundColor(Colors.white)
//     .borderRadius(15)
//     .shadow(color: Colors.black26, blurRadius: 8)
//     .marginAll(16)
//     .onTap(() => print('Tapped!'));

// // Gradient backgrounds
// Text('Gradient Text')
//     .paddingAll(20)
//     .linearGradient(
//       colors: [Colors.purple, Colors.blue],
//       begin: Alignment.topLeft,
//       end: Alignment.bottomRight,
//     )
//     .borderRadius(25);

// // Animations
// Text('Fade In')
//     .fadeIn(duration: Duration(milliseconds: 500))
//     .slideIn(begin: Offset(0, 0.5));

// // Layout helpers
// Column(
//   children: [
//     Text('Item 1').expanded,
//     Text('Item 2').flex(flex: 2),
//     Text('Item 3').height(50),
//   ],
// );

// // Conditional display
// Text('Conditional')
//     .showIf(someCondition)
//     .paddingAll(8);

// // Touch interactions
// Container(child: Text('Tap me'))
//     .paddingAll(16)
//     .backgroundColor(Colors.blue)
//     .borderRadius(8)
//     .hapticFeedback(
//       onTap: () => print('Tapped with haptic!'),
//       type: HapticFeedbackType.medium,
//     );

// // Card-like styling
// Text('Card Content')
//     .paddingAll(16)
//     .card(elevation: 4, margin: EdgeInsets.all(8))
//     .borderRadius(12);

// // Positioning in Stack
// Stack(
//   children: [
//     Container(width: 200, height: 200, color: Colors.grey),
//     Text('Top Right').positionedTopRight,
//     Text('Bottom Left').positionedBottomLeft,
//   ],
// );

// // Custom decorations
// Text('Decorated')
//     .paddingAll(20)
//     .decorated(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(15),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.black26,
//           blurRadius: 10,
//           offset: Offset(0, 5),
//         ),
//       ],
//     );