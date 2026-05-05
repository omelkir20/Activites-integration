# Projet Étudiants — Spring Boot + Flutter + Docker

## Lancer l'API avec Docker

```bash
docker compose up --build
```

API accessible sur : http://localhost:8080/api/etudiants

## Lancer l'app Flutter

```bash
cd mobile-app
flutter pub get
flutter run
```

> Modifier l'IP dans `lib/services/api_service.dart` selon votre réseau local.