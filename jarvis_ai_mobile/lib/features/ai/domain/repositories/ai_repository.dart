// Domain layer - repository interface

abstract class AiRepository {
  /// Sends a message to the AI and returns the AI response text.
  Future<String> sendMessage(String message);
}
