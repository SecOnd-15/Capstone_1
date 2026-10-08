import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class FarmMapViewerScreen extends StatefulWidget {
  const FarmMapViewerScreen({super.key});

  static void show(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        barrierColor: Colors.black.withValues(alpha: 0.85),
        transitionDuration: const Duration(milliseconds: 350),
        reverseTransitionDuration: const Duration(milliseconds: 280),
        pageBuilder: (context, animation, secondaryAnimation) {
          return const FarmMapViewerScreen();
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          );
          return FadeTransition(
            opacity: curved,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.92, end: 1.0).animate(curved),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  State<FarmMapViewerScreen> createState() => _FarmMapViewerScreenState();
}

class _FarmMapViewerScreenState extends State<FarmMapViewerScreen> {
  final TransformationController _transController = TransformationController();
  double _currentScale = 1.0;

  @override
  void dispose() {
    _transController.dispose();
    super.dispose();
  }

  void _zoomIn() {
    setState(() {
      _currentScale = (_currentScale * 1.3).clamp(1.0, 4.0);
      _transController.value = Matrix4.diagonal3Values(_currentScale, _currentScale, 1.0);
    });
  }

  void _zoomOut() {
    setState(() {
      _currentScale = (_currentScale / 1.3).clamp(1.0, 4.0);
      _transController.value = Matrix4.diagonal3Values(_currentScale, _currentScale, 1.0);
    });
  }

  void _resetZoom() {
    setState(() {
      _currentScale = 1.0;
      _transController.value = Matrix4.identity();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Header with Exit / Back button ───────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 22),
                      tooltip: 'Back to Landing Page',
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Gran Verde Agroforest Map',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Interactive Farm Layout • Pinch or double-tap to zoom',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 11,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.close_rounded, color: Colors.white, size: 22),
                      tooltip: 'Close Map',
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ),

            // ── Interactive Map Viewport with Hero Animation ─────────
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAE3D2),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                  border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.5),
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    // Interactive Zoomable Map Image
                    Positioned.fill(
                      child: InteractiveViewer(
                        transformationController: _transController,
                        minScale: 0.8,
                        maxScale: 4.5,
                        boundaryMargin: const EdgeInsets.all(80),
                        child: Center(
                          child: Hero(
                            tag: 'gran_verde_farm_map_hero',
                            child: Image.asset(
                              'assets/images/farm_map.jpg',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: const Color(0xFFD7CCC8),
                                  alignment: Alignment.center,
                                  child: const Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.map_rounded, size: 48, color: AppColors.primary),
                                      SizedBox(height: 10),
                                      Text(
                                        'Gran Verde Agroforest Map',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.primaryDark,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Floating Zoom Controls (Bottom Right)
                    Positioned(
                      right: 14,
                      bottom: 14,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.92),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.add_rounded, color: AppColors.primaryDark, size: 20),
                              tooltip: 'Zoom In',
                              onPressed: _zoomIn,
                            ),
                            const Divider(height: 1, indent: 6, endIndent: 6),
                            IconButton(
                              icon: const Icon(Icons.remove_rounded, color: AppColors.primaryDark, size: 20),
                              tooltip: 'Zoom Out',
                              onPressed: _zoomOut,
                            ),
                            const Divider(height: 1, indent: 6, endIndent: 6),
                            IconButton(
                              icon: const Icon(Icons.restart_alt_rounded, color: AppColors.primaryDark, size: 20),
                              tooltip: 'Reset View',
                              onPressed: _resetZoom,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Scale & Guide Badge (Top Left of Map)
                    Positioned(
                      top: 14,
                      left: 14,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1B5E20).withValues(alpha: 0.88),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.touch_app_rounded, color: AppColors.accent, size: 14),
                            SizedBox(width: 5),
                            Text(
                              'Pan & Pinch to Explore Zones',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
