import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'core/theme.dart';
import 'screens/capture_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Fetch available cameras — gracefully handle if unavailable
  List<CameraDescription> cameras = [];
  try {
    cameras = await availableCameras();
  } catch (e) {
    debugPrint('Camera unavailable: $e');
  }

  runApp(WoodConNetApp(cameras: cameras));
}

class WoodConNetApp extends StatelessWidget {
  final List<CameraDescription> cameras;
  const WoodConNetApp({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WoodConNet',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: CaptureScreen(cameras: cameras),
    );
  }
}
