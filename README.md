# AGROSAFE

Base multiplataforma de la aplicación AGROSAFE creada con Flutter. Este repositorio no contiene funcionalidades de negocio todavía: es el punto de partida para desarrollarlas de forma aislada.

## Requisitos

- Flutter SDK `3.38.1` o compatible
- Dart SDK incluido con Flutter

## Ejecutar el proyecto

```bash
flutter pub get
flutter run
```

## Estructura

```text
lib/
├── app/                  # Código de la capa de UI y widgets principales
├── core/                 # Código transversal (tema, servicios, utilidades)
├── feature/              # Módulos de negocio independientes (una carpeta por feature)
└── main.dart             # Punto de entrada de la aplicación
```

Cada nueva funcionalidad debe vivir en una rama `feature/<nombre>` creada desde `develop`. Al terminarla, se integra mediante pull request hacia `develop`.

## Flujo de ramas

- `main`: versiones estables.
- `develop`: base de integración para el desarrollo.
- `feature/<nombre>`: una funcionalidad aislada por rama.
