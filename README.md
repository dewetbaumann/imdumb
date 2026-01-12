# IMDUMB - Flutter Movie App

## Resumen del Proyecto
Aplicación móvil en Flutter para consultar categorías de películas, ver detalles y "recomendar" títulos. Desarrollada como prueba técnica demostrando arquitectura limpia, buenas prácticas y manejo de estado moderno.

## Arquitectura
Se ha implementado **Clean Architecture** dividida en 3 capas principales:

1. **Presentation**: UI y Manejo de Estado.
   - Usa `Riverpod` para inyección de dependencias y reactividad.
   - Widgets segregados (`screens` y `widgets`).
2. **Domain**: Reglas de negocio.
   - `Entities`: Objetos de negocio (`Movie`, `Genre`).
   - `UseCases`: Acciones específicas (`GetMoviesByGenre`).
   - `Repositories` (Interfaces): Contratos de acceso a datos.
3. **Data**: Acceso a fuentes externas.
   - `Repositories` (Implementación): Coordina fuentes de datos.
   - `DataSources`: Llamadas a API mediante `IHttp` (Dio Wrapper).
   - `Models`: DTOs con lógica de serialización JSON.

## Tech Stack
- **Framework**: Flutter 3.35.7 (Dart 3.9.2)
- **State Management**: Riverpod (v3.x / flutter_riverpod)
- **Networking**: Dio (v5.x) con implementación personalizada (`HttpImpl`)
- **Functional utility**: Dartz (Either type for error handling)
- **Persistence**: SharedPreferences
- **Backend/Config**: Firebase (Remote Config, Analytics) con estrategia de fallback.
- **UI Utils**: Flutter Carousel Widget, Cached Network Image, Overlay Support
- **Logging/Utility**: `print_map` (Autoría propia) - Herramienta para formatear logs de mapas/JSON.
  - [Documentación GitHub](https://github.com/dewetbaumann/dart-print-map/blob/main/README.md)
  - [Paquete Pub.dev](https://pub.dev/packages/print_map)

## Instalación y Ejecución

1. Clonar el repositorio.
2. Obtener dependencias:
   ```bash
   flutter pub get
   ```
3. Ejecutar la aplicación:
   ```bash
   flutter run
   ```

## Variantes de Construcción (Flavors)

El proyecto soporta múltiples "flavors" (ambientes) para Android:

- **prod**: Versión de producción (default).
- **qa**: Versión de control de calidad. Distintivo: Suffix de ID `.qa`, App Name "ImDumb QA" y **Banner visual "QA"** en pantalla.

Para ejecutar el flavor QA:
```bash
flutter run --flavor qa
```

## CI/CD y Calidad

Se han integrado herramientas para automatizar el ciclo de desarrollo:

- **CI (GitHub Actions)**:
  - Ejecución automática de tests unitarios y goldens en cada push/PR a `main` y `develop`.
  - Archivo de flujo: `.github/workflows/flutter_ci.yml`.

- **Golden Tests (Visual Regression Testing)**:
  - **Propósito**: Validar que los cambios en código no alteren visualmente los widgets de forma inesperada.
  - **Estrategia**: Se capturan imágenes de referencia de los widgets renderizados en los goldens. En cada ejecución, se comparan píxel-por-píxel.
  - **Tolerancia**: Se utiliza una tolerancia del 10% de diferencia de píxeles para permitir variaciones menores por diferencias de renderizado entre máquinas (anti-aliasing, subpixel rendering, etc.).
  - **Ubicación**: Los goldens se almacenan en `test/presentation/widgets/goldens/`.
  - **Actualización**: Cuando haya cambios visuales intencionales y validados, actualizar con:
    ```bash
    flutter test --update-goldens
    ```
  - **Por qué este enfoque**: 
    - Detecta regresiones visuales automáticamente sin inspección manual.
    - Documenta el aspecto esperado de cada widget visualmente.
    - Diferencia entre cambios intencionales (actualizar golden) vs. regresiones (fallar el test).

- **CD (Codemagic)**:
  - Generación automatizada de artefactos (`.apk`, `.aab`) para el ambiente QA.
  - Archivo de configuración: `codemagic.yaml`.

- **Pull Request Template**:
  - Se ha incluido una plantilla predefinida para estandarizar las descripciones de los Pull Requests.
  - Ubicación: `.github/PULL_REQUEST_TEMPLATE.md`.
  - **Ejemplo de referencia**: [Pull Request #1 - Actualización de documentación](https://github.com/dewetbaumann/imdumb/pull/1)

- **Estrategia Micro-Frontend y Versionado**:
  - El proyecto adopta una arquitectura de estilo **Micro-Frontend** modularizando capacidades a través de paquetes independientes (ej: `imdumb_dependencies`).
  - Cada módulo (app principal y paquetes satélite) tiene su propio ciclo de vida y versionado mediante **Tags** de Git.
  - El despliegue es atómico: crear un tag en cualquiera de los repositorios desencadena su pipeline específico de CI/CD para release y publicación.


*Nota:* La inicialización de Firebase está deshabilitada en este entorno (sin `google-services.json`/`GoogleService-Info.plist`). La app implementa una estrategia robusta de **graceful degradation**: continúa funcionando en "offline mode" usando valores en caché. Ver [ConfigService](lib/core/services/config_service.dart) para más detalles.

## Implementación de Firebase - Buenas Prácticas

La integración de Firebase en este proyecto sigue principios SOLID y patrones de arquitectura limpia:

### Arquitectura
- **Repository Pattern**: `ConfigService` abstrae la implementación de Firebase, permitiendo fácilmente intercambiar con mocks o alternativas.
- **Dependency Injection**: `ConfigService` recibe `SharedPreferences` como dependencia inyectada a través de Riverpod.
- **Single Responsibility**: El servicio solo maneja obtención y cacheo de configuración.

### Error Handling y Resilencia
- **Graceful Degradation**: Si Firebase no está disponible, la app continúa funcionando con valores en caché.
- **Fallback Strategies**: 
  - Si Firebase está deshabilitado → usa modo offline
  - Si fetch falla → usa valores previamente cacheados
  - Si no hay cache → usa defaults predefinidos
- **Logging Estructurado**: Mensajes de error claro con emojis para visibilidad.

### Testabilidad
```dart
// Fácil de mockear en tests
configServiceProvider.overrideWithValue(MockConfigService())
```

### Offline-First Approach
- Todas las configuraciones se cachean localmente en SharedPreferences
- El app es totalmente funcional sin conexión a Firebase
- Sincronización silenciosa cuando Firebase esté disponible

## Principios SOLID Documentados

Los principios SOLID se aplican en todo el proyecto. Ejemplos concretos documentados en código:

1. **Single Responsibility Principle (SRP)**: Documentado en `lib/presentation/widgets/category_section.dart`.
2. **Open/Closed Principle (OCP)**: Documentado en `lib/presentation/screens/detail/detail_screen.dart`.
3. **Dependency Inversion Principle (DIP)**: Documentado en `lib/data/repositories/movie_repository_impl.dart`.
4. **Liskov Substitution Principle (LSP)**: Documentado en `lib/data/models/movie_model.dart`.

## Configuración de Entorno
El API Key y Token se encuentran en `lib/core/app/env.dart`.
Endpoint API: The Movie Database (TMDb).
