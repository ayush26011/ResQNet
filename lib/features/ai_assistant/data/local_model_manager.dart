import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ModelStatus {
  missing,      // Model Missing
  loading,      // Model Loading
  importing,    // Model Importing
  ready,        // Model Ready
  invalid,      // Model Invalid
  loadFailed,   // Model Load Failed
}

class LocalModelManager {
  static final LocalModelManager instance = LocalModelManager._init();
  LocalModelManager._init();

  ModelStatus _status = ModelStatus.missing;
  String? _lastErrorMessage;
  String? _resolvedModelPath;

  ModelStatus get status => _status;
  String? get lastErrorMessage => _lastErrorMessage;
  String? get resolvedModelPath => _resolvedModelPath;

  void setStatus(ModelStatus status, [String? errorMessage]) {
    _status = status;
    _lastErrorMessage = errorMessage;
  }

  Future<String?> getModelDirectoryPath() async {
    if (kIsWeb) return null;
    try {
      final docDir = await getApplicationDocumentsDirectory();
      final modelsDir = Directory(p.join(docDir.path, 'models'));
      if (!await modelsDir.exists()) {
        await modelsDir.create(recursive: true);
      }
      return modelsDir.path;
    } catch (_) {
      return null;
    }
  }

  Future<String?> getCustomModelPath() async {
    if (kIsWeb) return null;
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('custom_llm_model_path');
    } catch (_) {
      return null;
    }
  }

  Future<void> setCustomModelPath(String? path) async {
    if (kIsWeb) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      if (path == null || path.trim().isEmpty) {
        await prefs.remove('custom_llm_model_path');
      } else {
        await prefs.setString('custom_llm_model_path', path.trim());
      }
    } catch (_) {}
  }

  Future<bool> _isValidGguf(File file) async {
    if (!file.path.toLowerCase().endsWith('.gguf')) return false;
    try {
      if (await file.length() < 4) return false;
      final randomAccessFile = await file.open(mode: FileMode.read);
      final bytes = await randomAccessFile.read(4);
      await randomAccessFile.close();
      // GGUF magic bytes: 'G', 'G', 'U', 'F' (0x47, 0x47, 0x55, 0x46)
      return bytes.length == 4 &&
          bytes[0] == 0x47 &&
          bytes[1] == 0x47 &&
          bytes[2] == 0x55 &&
          bytes[3] == 0x46;
    } catch (_) {
      return false;
    }
  }

  Future<bool> importModelFile(String sourceFilePath) async {
    if (kIsWeb) return false;
    try {
      final sourceFile = File(sourceFilePath);
      if (!await sourceFile.exists()) {
        _lastErrorMessage = 'Source file does not exist: $sourceFilePath';
        _status = ModelStatus.missing;
        return false;
      }

      // Check size
      final size = await sourceFile.length();
      if (size == 0) {
        _lastErrorMessage = 'File is empty.';
        _status = ModelStatus.invalid;
        return false;
      }

      // Validate GGUF magic bytes
      final isValid = await _isValidGguf(sourceFile);
      if (!isValid) {
        _lastErrorMessage = 'Invalid GGUF model format. Header must contain magic bytes "GGUF".';
        _status = ModelStatus.invalid;
        return false;
      }

      final docDirPath = await getModelDirectoryPath();
      if (docDirPath == null) {
        _lastErrorMessage = 'Could not access application documents directory.';
        _status = ModelStatus.missing;
        return false;
      }

      final fileName = p.basename(sourceFilePath);
      final targetFilePath = p.join(docDirPath, fileName);
      final targetFile = File(targetFilePath);

      _status = ModelStatus.importing;
      _lastErrorMessage = null;

      // Copy source to target documents path
      await sourceFile.copy(targetFilePath);

      // Verify copied file exists
      if (await targetFile.exists() && await targetFile.length() > 0) {
        _resolvedModelPath = targetFilePath;
        await setCustomModelPath(targetFilePath);
        _status = ModelStatus.ready;
        _lastErrorMessage = null;
        return true;
      }
      _status = ModelStatus.missing;
      _lastErrorMessage = 'Failed to copy model file.';
      return false;
    } catch (e) {
      _status = ModelStatus.loadFailed;
      _lastErrorMessage = 'Import error: ${e.toString()}';
      return false;
    }
  }

  Future<ModelStatus> checkModelStatus(String modelFileName) async {
    if (kIsWeb) {
      _status = ModelStatus.missing;
      _lastErrorMessage = 'Offline LLM is available on Android/Desktop builds. Web preview cannot run native GGUF inference.';
      return _status;
    }

    _status = ModelStatus.missing;
    try {
      // 1. Check custom path first (useful for development & user imported models)
      final customPath = await getCustomModelPath();
      print('[LocalModelManager] Custom path from prefs: $customPath');
      if (customPath != null && customPath.trim().isNotEmpty) {
        final file = File(customPath);
        final exists = await file.exists();
        print('[LocalModelManager] Custom path file exists: $exists');
        if (exists && await file.length() > 0) {
          final isValid = await _isValidGguf(file);
          if (isValid) {
            _resolvedModelPath = customPath;
            _status = ModelStatus.ready;
            _lastErrorMessage = null;
            return _status;
          } else {
            _status = ModelStatus.invalid;
            _lastErrorMessage = 'Invalid GGUF model format.';
            return _status;
          }
        }
      }

      // 2. Check default local documents directory next
      final docDirPath = await getModelDirectoryPath();
      print('[LocalModelManager] Default doc directory path: $docDirPath');
      if (docDirPath != null) {
        final localFilePath = p.join(docDirPath, modelFileName);
        final file = File(localFilePath);
        final exists = await file.exists();
        print('[LocalModelManager] Default path file ($localFilePath) exists: $exists');
        if (exists && await file.length() > 0) {
          final isValid = await _isValidGguf(file);
          if (isValid) {
            _resolvedModelPath = localFilePath;
            _status = ModelStatus.ready;
            _lastErrorMessage = null;
            return _status;
          } else {
            _status = ModelStatus.invalid;
            _lastErrorMessage = 'Invalid GGUF model format.';
            return _status;
          }
        }
      }

      _status = ModelStatus.missing;
      _lastErrorMessage = 'Place model file in app storage and select/import it.';
    } catch (e, stack) {
      print('[LocalModelManager] Error checking status: $e\n$stack');
      _lastErrorMessage = e.toString();
      _status = ModelStatus.loadFailed;
    }
    return _status;
  }
}
