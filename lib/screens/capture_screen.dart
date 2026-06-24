import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../core/theme.dart';
import '../models/classification_result.dart';
import '../widgets/bottom_nav.dart';
import 'classification_screen.dart';
import 'history_screen.dart';
import 'guide_screen.dart';
import 'settings_screen.dart';

class CaptureScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  const CaptureScreen({super.key, required this.cameras});

  @override
  State<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen>
    with TickerProviderStateMixin {
  CameraController? _controller;
  int _selectedSample = 0; // 0=Leaf, 1=Bark, 2=Trunk, 3=Wood Grain
  bool _isScanning = false;
  bool _flashOn = false;

  late AnimationController _scanLineController;
  late Animation<double> _scanLineAnim;

  final List<Map<String, dynamic>> _sampleTypes = [
    {'label': 'Leaf', 'icon': Icons.eco_outlined},
    {'label': 'Bark', 'icon': Icons.park_outlined},
    {'label': 'Trunk', 'icon': Icons.forest_outlined},
    {'label': 'Wood Grain', 'icon': Icons.waves_outlined},
  ];

  @override
  void initState() {
    super.initState();
    globalNavIndex.addListener(_onNavChanged);
    _initCamera();
    _scanLineController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _scanLineAnim = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_scanLineController);
  }

  Future<void> _initCamera() async {
    if (widget.cameras.isEmpty) return;
    _controller = CameraController(
      widget.cameras.first,
      ResolutionPreset.high,
      enableAudio: false,
    );
    try {
      await _controller!.initialize();
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('Camera init error: $e');
    }
  }

  @override
  void dispose() {
    globalNavIndex.removeListener(_onNavChanged);
    _controller?.dispose();
    _scanLineController.dispose();
    super.dispose();
  }

  void _onNavChanged() {
    if (mounted) setState(() {});
  }

  void _onCapture() {
    if (_isScanning) return;
    setState(() => _isScanning = true);

    // Simulate processing delay then show mock result
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _isScanning = false);
      // Alternate between Narra and Molave as mock data
      final result = _selectedSample % 2 == 0
          ? MockResults.narra
          : MockResults.molave;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ClassificationScreen(result: result)),
      );
    });
  }

  void _toggleFlash() {
    if (_controller == null) return;
    setState(() => _flashOn = !_flashOn);
    _controller!.setFlashMode(_flashOn ? FlashMode.torch : FlashMode.off);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'Capture',
          style: TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: AppColors.textDark,
          ),
        ),
        centerTitle: true,
      ),
      body: IndexedStack(
        index: globalNavIndex.value,
        children: [
          // Tab 0: Capture View
          Column(
            children: [
              // ── Camera Viewfinder ──────────────────────────────
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Camera preview or dark fallback
                        _buildCameraPreview(),

                        // Corner scan brackets
                        _buildScanCorners(),

                        // Scan mode label
                        Positioned(
                          top: 16,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'SCAN MODE',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  letterSpacing: 1.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Animated scan line when scanning
                        if (_isScanning)
                          AnimatedBuilder(
                            animation: _scanLineAnim,
                            builder: (_, _) => Positioned(
                              top:
                                  _scanLineAnim.value *
                                  (MediaQuery.of(context).size.height * 0.4),
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 2,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      AppColors.accent.withValues(alpha: 0.8),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                        // Scanning overlay
                        if (_isScanning)
                          Container(
                            color: Colors.black.withValues(alpha: 0.3),
                            child: const Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    'Analyzing sample...',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        // Bottom hint
                        Positioned(
                          bottom: 16,
                          left: 16,
                          right: 16,
                          child: Text(
                            'Align leaf, bark, trunk or wood grain',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.85),
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ── Sample Type Selector ───────────────────────────
              SizedBox(
                height: 44,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _sampleTypes.length,
                  itemBuilder: (_, i) {
                    final bool active = i == _selectedSample;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedSample = i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: active ? AppColors.primary : AppColors.cardBg,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: active
                                ? AppColors.primary
                                : const Color(0xFFDDD9D3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _sampleTypes[i]['icon'] as IconData,
                              size: 18,
                              color: active ? Colors.white : AppColors.textDark,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _sampleTypes[i]['label'] as String,
                              style: TextStyle(
                                color: active
                                    ? Colors.white
                                    : AppColors.textDark,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // ── Camera Controls ────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Gallery button
                    _CircleButton(
                      icon: Icons.photo_library_outlined,
                      onTap: () {},
                    ),

                    // Shutter
                    GestureDetector(
                      onTap: _onCapture,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _isScanning
                              ? AppColors.textLight
                              : Colors.white,
                          border: Border.all(
                            color: const Color(0xFFCCCCCC),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: _isScanning
                            ? const Padding(
                                padding: EdgeInsets.all(20),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.primary,
                                ),
                              )
                            : null,
                      ),
                    ),

                    // Flash button
                    _CircleButton(
                      icon: _flashOn
                          ? Icons.flash_on_rounded
                          : Icons.flash_off_rounded,
                      onTap: _toggleFlash,
                      active: _flashOn,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),
            ],
          ),
        ],
      ),
      bottomNavigationBar: WoodConNetBottomNav(
        currentIndex: globalNavIndex.value,
        onTap: (i) {
          if (i == globalNavIndex.value) return;
          switch (i) {
            case 1:
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const HistoryScreen()), (route) => false);
              break;
            case 2:
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const GuideScreen()), (route) => false);
              break;
            case 3:
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const SettingsScreen()), (route) => false);
              break;
            default:
              break;
          }
        },
      ),
    );
  }

  Widget _buildCameraPreview() {
    if (_controller != null && _controller!.value.isInitialized) {
      return CameraPreview(_controller!);
    }
    // Fallback when camera isn't available
    return Container(
      color: const Color(0xFF2A2A2A),
      child: const Center(
        child: Text(
          'Camera not available\nin this environment',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white54, fontSize: 13),
        ),
      ),
    );
  }

  Widget _buildScanCorners() {
    return Positioned.fill(child: CustomPaint(painter: _CornerPainter()));
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool active;

  const _CircleButton({
    required this.icon,
    required this.onTap,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: active
              ? AppColors.primary.withValues(alpha: 0.15)
              : AppColors.cardBg,
          border: Border.all(color: const Color(0xFFDDD9D3)),
        ),
        child: Icon(
          icon,
          size: 20,
          color: active ? AppColors.primary : AppColors.textDark,
        ),
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    const len = 28.0;
    const pad = 24.0;

    // Top-left
    canvas.drawLine(Offset(pad, pad + len), Offset(pad, pad), paint);
    canvas.drawLine(Offset(pad, pad), Offset(pad + len, pad), paint);
    // Top-right
    canvas.drawLine(
      Offset(size.width - pad - len, pad),
      Offset(size.width - pad, pad),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - pad, pad),
      Offset(size.width - pad, pad + len),
      paint,
    );
    // Bottom-left
    canvas.drawLine(
      Offset(pad, size.height - pad - len),
      Offset(pad, size.height - pad),
      paint,
    );
    canvas.drawLine(
      Offset(pad, size.height - pad),
      Offset(pad + len, size.height - pad),
      paint,
    );
    // Bottom-right
    canvas.drawLine(
      Offset(size.width - pad - len, size.height - pad),
      Offset(size.width - pad, size.height - pad),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - pad, size.height - pad - len),
      Offset(size.width - pad, size.height - pad),
      paint,
    );
  }

  @override
  bool shouldRepaint(_) => false;
}
