# Projet Étudiants — Spring Boot + Flutter + Docker
## Description

Mini-projet fullstack composé d'une API REST Spring Boot 4, une base de données
PostgreSQL, un cache Redis, un déploiement Docker et Kubernetes (K3S), et une
application mobile Flutter.
## Prérequis

- Java 21
- Maven 3.9+
- Docker Desktop
- Flutter SDK
- kubectl + K3S (pour le déploiement Kubernetes)
- Compte Docker Hub
- Compte Jira (atlassian.com)
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

## Partie 1

### Entité Etudiant

| Champ | Type                    |
|-------|-------------------------|
| id | Long (auto-généré)      |
| cin | String                  |
| nom | String                  |
| dateNaissance | LocalDate               |
| email | String                  |
| anneePremiereInscription | int                     |
| departement | Departement (ManyToOne) |
|departementId | Long                    |
| age | int                     |

## Captures

### GET /api/etudiants
![Captures](images/api-get-etudiant.png)

### Mobile App
![Captures](images/appmobile.png)
### Page index.html
![Captures](images/index-html-cap.png)
## Partie 2
### Endpoints disponibles
| Méthode | URL | Description |
|---------|-----|-------------|
| GET | /api/etudiants | Liste tous les étudiants |
| GET | /api/etudiants/{id} | Récupère un étudiant |
| POST | /api/etudiants | Crée un étudiant |
| PUT | /api/etudiants/{id} | Met à jour un étudiant |
| DELETE | /api/etudiants/{id} | Supprime un étudiant |
| GET | /api/etudiants?annee=2022 | Filtre par année |
| GET | /api/departements | Liste tous les départements |
| GET | /api/departements/{id} | Récupère un département |
| POST | /api/departements | Crée un département |
| PUT | /api/departements/{id} | Met à jour un département |
| DELETE | /api/departements/{id} | Supprime un département |
### Prérequis
- Docker Desktop installé et démarré

### Lancer l'application

```bash
docker compose up --build
```

### Services démarrés

| Service | Port | Description |
|---------|------|-------------|
| API Spring Boot | 8080 | API REST |
| PostgreSQL | 5432 | Base de données |
| Redis | 6379 | Cache |

### Documentation Swagger
http://localhost:8080/swagger-ui/index.html
![Documentation Swagger](images/swagger-cap-1.png)
![Documentation Swagger](images/swagger-cap-2.png)
### Redis
![Redis](images/Capture-redis.png)
### index .html
![index .html](images/Capture-3.png)