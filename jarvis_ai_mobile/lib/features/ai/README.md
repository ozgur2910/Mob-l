# AI feature

This folder contains the Gemini AI integration using a clean architecture approach.

Structure (already implemented):

lib/features/ai/
├── data/
│   ├── providers/
│   │   └── gemini_provider.dart
│   ├── repositories/
│   │   └── ai_repository_impl.dart
│   └── services/
│       └── gemini_service.dart
│
├── domain/
│   ├── repositories/
│   │   └── ai_repository.dart
│   └── models/
│       └── ai_exceptions.dart
└── presentation/
    └── (chat screen is wired to use the ai repository provider)
