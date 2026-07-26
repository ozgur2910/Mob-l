# JARVIS AI Mobile

This repository contains a starter Flutter project named `jarvis_ai_mobile` — a production-ready skeleton for an AI assistant app (JARVIS AI).

Key features in this scaffold:
- Clean Architecture (feature-first folders)
- State management: Riverpod
- Routing: GoRouter
- Secure storage for API key using flutter_secure_storage
- Local persistence with Hive
- Dark theme, blue neon accent, glassmorphism UI primitives
- Smooth animations and reusable widgets
- Linting and analysis options configured
- GitHub Actions workflow for analyze & test

Getting started

1. Install Flutter (stable) and ensure `flutter` is on your PATH.
2. From this repo, open the project folder:

   cd jarvis_ai_mobile

3. Get packages:

   flutter pub get

4. Run the app:

   flutter run

Notes

- On first run the app shows the First Setup screen to enter a Gemini API key. The key is stored securely in flutter_secure_storage.
- Conversation history and simple settings are stored in Hive.

Development

- The code follows a feature-first layout under `lib/` with placeholder modules for ai_core, voice, memory, vision, documents, internet, settings, and widgets.
- Reusable UI components live in `lib/widgets`.

CI

- A GitHub Actions workflow is included at `.github/workflows/flutter-ci.yml` that runs `flutter analyze` and `flutter test` on push and pull requests.
