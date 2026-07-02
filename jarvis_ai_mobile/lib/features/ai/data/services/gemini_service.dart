import 'dart:async';
import 'dart:io';

import 'package:google_generative_ai/google_generative_ai.dart';

import '../domain/models/ai_exceptions.dart';

/// A small wrapper around the google_generative_ai GenerativeModel.
class GeminiService {
  final GenerativeModel _model;
  final Duration timeout;

  GeminiService(this._model, {this.timeout = const Duration(seconds: 20)});

  Future<String> sendMessage(String message) async {
    try {
      // The google_generative_ai package has multiple APIs; using generateContent as a simple text endpoint.
      final response = await _model.generateContent(Content.text(message)).timeout(timeout);

      // The response object may contain text or structured content; map to a string.
      return response.text ?? '';
    } on TimeoutException catch (e) {
      throw RequestTimeoutException(e.toString());
    } on SocketException catch (e) {
      throw NoInternetException(e.message);
    } catch (e) {
      final s = e.toString();
      // heuristics for invalid api key
      if (s.contains('401') || s.toLowerCase().contains('unauthor')) {
        throw InvalidApiKeyException(s);
      }
      throw UnknownAiException(s);
    }
  }
}
