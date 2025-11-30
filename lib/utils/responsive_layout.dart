import 'package:flutter/material.dart';

/// Breakpoints for responsive design
class Breakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
}

/// Maximum widths for content on large screens
class MaxWidths {
  static const double content = 1200.0;
  static const double card = 800.0;
  static const double form = 600.0;
  static const double studyCard = 700.0;
}

/// Responsive helper to determine current screen size category
enum ScreenSize { mobile, tablet, desktop }

/// Extension methods for responsive design
extension ResponsiveExtension on BuildContext {
  /// Returns true if screen width is mobile size
  bool get isMobile => MediaQuery.of(this).size.width < Breakpoints.mobile;

  /// Returns true if screen width is tablet size
  bool get isTablet =>
      MediaQuery.of(this).size.width >= Breakpoints.mobile &&
      MediaQuery.of(this).size.width < Breakpoints.desktop;

  /// Returns true if screen width is desktop size
  bool get isDesktop => MediaQuery.of(this).size.width >= Breakpoints.desktop;

  /// Returns the current screen size category
  ScreenSize get screenSize {
    final width = MediaQuery.of(this).size.width;
    if (width < Breakpoints.mobile) return ScreenSize.mobile;
    if (width < Breakpoints.desktop) return ScreenSize.tablet;
    return ScreenSize.desktop;
  }

  /// Returns the screen width
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Returns the screen height
  double get screenHeight => MediaQuery.of(this).size.height;
}

/// Widget that centers content with a maximum width on large screens
class ResponsiveCenter extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsets? padding;

  const ResponsiveCenter({
    super.key,
    required this.child,
    this.maxWidth = MaxWidths.content,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        padding: padding,
        child: child,
      ),
    );
  }
}

/// Widget that provides responsive padding based on screen size
class ResponsivePadding extends StatelessWidget {
  final Widget child;
  final double mobilePadding;
  final double tabletPadding;
  final double desktopPadding;

  const ResponsivePadding({
    super.key,
    required this.child,
    this.mobilePadding = 16.0,
    this.tabletPadding = 24.0,
    this.desktopPadding = 32.0,
  });

  @override
  Widget build(BuildContext context) {
    final padding =
        context.isMobile
            ? mobilePadding
            : context.isTablet
            ? tabletPadding
            : desktopPadding;

    return Padding(padding: EdgeInsets.all(padding), child: child);
  }
}

/// Widget that provides responsive grid layout
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final int mobileColumns;
  final int tabletColumns;
  final int desktopColumns;
  final double spacing;
  final double runSpacing;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.mobileColumns = 1,
    this.tabletColumns = 2,
    this.desktopColumns = 3,
    this.spacing = 16.0,
    this.runSpacing = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    final columns =
        context.isMobile
            ? mobileColumns
            : context.isTablet
            ? tabletColumns
            : desktopColumns;

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth =
            (constraints.maxWidth - (spacing * (columns - 1))) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          children:
              children.map((child) {
                return SizedBox(width: itemWidth, child: child);
              }).toList(),
        );
      },
    );
  }
}

/// Returns appropriate column count for grid based on screen size
int getResponsiveColumns(BuildContext context) {
  if (context.isMobile) return 1;
  if (context.isTablet) return 2;
  return 3;
}

/// Returns appropriate spacing based on screen size
double getResponsiveSpacing(BuildContext context) {
  if (context.isMobile) return 12.0;
  if (context.isTablet) return 16.0;
  return 20.0;
}
