import '../../domain/repositories/ai_repository.dart';
import '../services/gemini_service.dart';

class AiRepositoryImpl implements AiRepository {
  final GeminiService _service;

  AiRepositoryImpl(this._service);

  @override
  Future<String> sendMessage(String message) async {
    return _service.sendMessage(message);
  }
}
