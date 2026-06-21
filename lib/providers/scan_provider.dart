import 'package:flutter/material.dart';
import '../data/models/scan_result.dart';
import '../data/services/mock_inference_service.dart';

enum ScanState { idle, loading, success, error }

class ScanProvider extends ChangeNotifier {
  final MockInferenceService _service = MockInferenceService();

  ScanState _state = ScanState.idle;
  ScanResult? _currentResult;
  String? _errorMessage;

  ScanState get state => _state;
  ScanResult? get currentResult => _currentResult;
  String? get errorMessage => _errorMessage;

  Future<void> analyzeImage(String imagePath, InputModality modality) async {
    _state = ScanState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentResult = await _service.analyzeImage(imagePath, modality);
      _state = ScanState.success;
    } catch (e) {
      _state = ScanState.error;
      _errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  void reset() {
    _state = ScanState.idle;
    _currentResult = null;
    _errorMessage = null;
    notifyListeners();
  }
}
