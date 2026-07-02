import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../../domain/repositories/ai_repository.dart';
import '../repositories/ai_repository_impl.dart';
import '../services/gemini_service.dart';

const _apiKeyStorageKey = 'gemini_api_key';

/// Reads the API key from secure storage.
final geminiApiKeyProvider = FutureProvider<String?>((ref) async {
  final storage = const FlutterSecureStorage();
  final key = await storage.read(key: _apiKeyStorageKey);
  return key;
});

/// Provides a GenerativeModel instance configured with the stored API key.
final generativeModelProvider = FutureProvider<GenerativeModel?>((ref) async {
  final apiKey = await ref.watch(geminiApiKeyProvider.future);
  if (apiKey == null || apiKey.isEmpty) return null;
  // Choose a default model. Adjust as needed to a valid Gemini model identifier.
  return GenerativeModel(model: 'models/text-bison-001', apiKey: apiKey);
});

/// Provides a GeminiService backed by the GenerativeModel.
final geminiServiceProvider = FutureProvider<GeminiService?>((ref) async {
  final model = await ref.watch(generativeModelProvider.future);
  if (model == null) return null;
  return GeminiService(model);
});

/// Provides the AiRepository implementation.
final aiRepositoryProvider = FutureProvider<AiRepository?>((ref) async {
  final service = await ref.watch(geminiServiceProvider.future);
  if (service == null) return null;
  return AiRepositoryImpl(service);
});
