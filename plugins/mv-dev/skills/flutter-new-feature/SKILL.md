---
description: Scaffold completo de una nueva feature en un proyecto Flutter de MV - sigue la arquitectura del proyecto, aplica design tokens y genera tests
---

# Flutter New Feature - Nueva Feature en Flutter

Crea una feature completa en un proyecto Flutter de Manzana Verde, siguiendo la arquitectura establecida del proyecto, aplicando los design tokens de MV y con tests desde el inicio.

---

## Cuando usar este skill

- Cuando hay que agregar una funcionalidad nueva a la app Flutter
- Cuando se recibe un nuevo requerimiento o ticket de Jira/Notion
- Cuando se va a implementar un flujo nuevo (login, pedidos, perfil, etc.)

---

## Paso 0: Entender el proyecto

**Antes de hacer cualquier pregunta, leer el proyecto:**

1. Buscar `docs/ARCHITECTURE.md` para entender la arquitectura elegida
2. Buscar `pubspec.yaml` para conocer las dependencias (estado, navegacion)
3. Revisar una feature existente para entender los patrones en uso
4. Si no hay arquitectura documentada, usar `/mv-dev:flutter-architecture` primero

**Si no se puede determinar la arquitectura con certeza, preguntar:**
```
No encontre documentacion de arquitectura en el proyecto.
¿Que patron de arquitectura usa el proyecto?

A) Simple (pantallas con su logica adentro, sin separacion clara)
B) MVVM (ViewModel separado de la pantalla)
C) Clean Architecture con BLoC
D) No se / necesito que revises el codigo y me digas
```

---

## Paso 1: Preguntar sobre la feature

### Pregunta 1: Nombre y descripcion

```
¿Que feature vamos a crear?

Necesito saber:
1. Nombre de la feature (ej: "seguimiento-pedido", "selector-plan", "perfil-usuario")
2. ¿Que debe hacer? Describir el flujo desde la perspectiva del usuario
```

### Pregunta 2: Alcance

```
¿Que tan grande es esta feature?

A) Solo UI - Muestra informacion que ya tenemos, sin conexion a API nueva
B) UI + API - Necesita conectarse al backend de MV para obtener o enviar datos
C) UI + API + Logica compleja - Tiene reglas de negocio complejas (validaciones, calculos, flujos condicionales)
D) No se bien cual aplica
```

### Pregunta 3: Pantallas involucradas

```
¿Cuantas pantallas tiene esta feature?

A) Una pantalla
B) 2-3 pantallas con navegacion entre ellas
C) Mas de 3 pantallas / es un flujo completo (ej: checkout completo)
```

### Pregunta 4: Integracion con el API de MV

Si el alcance incluye API:

```
¿Tienes documentacion del endpoint que necesitas consumir?

A) Si, tengo la URL, metodo y estructura de datos
   → Comparte la documentacion o URL de Notion
B) Si, esta en Notion
   → Usar /mv-dev:mv-docs para buscarla
C) No, necesito que el backend lo cree
   → Usar /mv-dev:create-api para crear el endpoint primero
D) No se si ya existe
   → Usar /mv-dev:discovery para investigar
```

---

## Paso 2: Generar la estructura de la feature

Basado en la arquitectura del proyecto, generar la estructura de carpetas correcta:

### Opcion A: Arquitectura Simple

```
lib/features/[feature-name]/
├── [feature_name]_screen.dart    # Pantalla principal con UI + logica
├── widgets/
│   └── [feature_name]_card.dart  # Widgets especificos de esta feature
├── [feature_name]_service.dart   # Llamadas al API
└── [feature_name]_model.dart     # Modelos de datos
```

### Opcion B: MVVM

```
lib/features/[feature-name]/
├── presentation/
│   ├── [feature_name]_screen.dart     # Solo UI, no logica
│   └── widgets/
│       └── [WidgetName].dart
├── viewmodel/
│   └── [feature_name]_viewmodel.dart  # Estado y logica de la pantalla
├── data/
│   ├── [feature_name]_repository.dart # Habla con el API
│   └── [feature_name]_model.dart      # Estructura de datos
└── [feature_name]_module.dart         # Configuracion / providers
```

### Opcion C: Clean Architecture + BLoC

```
lib/features/[feature-name]/
├── presentation/
│   ├── bloc/
│   │   ├── [feature_name]_bloc.dart
│   │   ├── [feature_name]_event.dart
│   │   └── [feature_name]_state.dart
│   ├── screens/
│   │   └── [feature_name]_screen.dart
│   └── widgets/
│       └── [WidgetName].dart
├── domain/
│   ├── entities/
│   │   └── [feature_name]_entity.dart
│   ├── repositories/
│   │   └── [feature_name]_repository.dart  # Interface/abstract
│   └── usecases/
│       └── get_[feature_name]_usecase.dart
└── data/
    ├── datasources/
    │   └── [feature_name]_remote_datasource.dart
    ├── models/
    │   └── [feature_name]_model.dart
    └── repositories/
        └── [feature_name]_repository_impl.dart
```

---

## Paso 3: Crear los archivos base

### 3.1 Modelo de datos

Siempre empezar por los modelos (tipos de datos):

```dart
// data/[feature_name]_model.dart
class [FeatureName]Model {
  final String id;
  final String nombre;
  // ... otros campos

  const [FeatureName]Model({
    required this.id,
    required this.nombre,
  });

  /// Crear desde JSON del API de MV
  factory [FeatureName]Model.fromJson(Map<String, dynamic> json) {
    return [FeatureName]Model(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
    );
  }

  /// Convertir a JSON para enviar al API
  Map<String, dynamic> toJson() => {
    'id': id,
    'nombre': nombre,
  };

  /// Comparacion e igualdad
  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
    other is [FeatureName]Model && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => '[FeatureName]Model(id: $id, nombre: $nombre)';
}
```

### 3.2 Servicio/Repository (conexion al API MV)

```dart
// data/[feature_name]_repository.dart
import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/error/app_exception.dart';
import '[feature_name]_model.dart';

class [FeatureName]Repository {
  final ApiClient _client;

  const [FeatureName]Repository(this._client);

  Future<List<[FeatureName]Model>> get[FeatureName]s() async {
    try {
      final response = await _client.get('/api/v1/[feature-name]');

      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data'];
        return data
          .map((json) => [FeatureName]Model.fromJson(json))
          .toList();
      } else {
        throw AppException(response.data['error'] ?? 'Error desconocido');
      }
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }
}
```

### 3.3 Pantalla principal

```dart
// presentation/[feature_name]_screen.dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';

class [FeatureName]Screen extends StatelessWidget {
  const [FeatureName]Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPage,
      appBar: AppBar(
        title: Text(
          '[Nombre de la pantalla]',
          style: AppTypography.h4,
        ),
        backgroundColor: AppColors.backgroundCard,
        elevation: 0,
        foregroundColor: AppColors.mvGray900,
      ),
      body: const _[FeatureName]Body(),
    );
  }
}

class _[FeatureName]Body extends StatelessWidget {
  const _[FeatureName]Body();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('[FeatureName] - En construccion'),
    );
  }
}
```

---

## Paso 4: Tests desde el inicio

**IMPORTANTE:** Antes de implementar la logica completa, crear los tests.

### 4.1 Tests del modelo

```dart
// test/features/[feature-name]/[feature_name]_model_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:[proyecto]/features/[feature-name]/data/[feature_name]_model.dart';

void main() {
  group('[FeatureName]Model', () {
    const testJson = {
      'id': '1',
      'nombre': 'Test',
    };

    test('fromJson crea el modelo correctamente', () {
      final model = [FeatureName]Model.fromJson(testJson);
      expect(model.id, equals('1'));
      expect(model.nombre, equals('Test'));
    });

    test('toJson convierte el modelo correctamente', () {
      const model = [FeatureName]Model(id: '1', nombre: 'Test');
      final json = model.toJson();
      expect(json, equals(testJson));
    });
  });
}
```

### 4.2 Tests del ViewModel/BLoC

```dart
// test/features/[feature-name]/[feature_name]_viewmodel_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:[proyecto]/features/[feature-name]/viewmodel/[feature_name]_viewmodel.dart';
import 'package:[proyecto]/features/[feature-name]/data/[feature_name]_repository.dart';

class Mock[FeatureName]Repository extends Mock implements [FeatureName]Repository {}

void main() {
  late [FeatureName]ViewModel viewModel;
  late Mock[FeatureName]Repository mockRepository;

  setUp(() {
    mockRepository = Mock[FeatureName]Repository();
    viewModel = [FeatureName]ViewModel(mockRepository);
  });

  group('[FeatureName]ViewModel', () {
    test('estado inicial es loading=false y datos vacios', () {
      expect(viewModel.isLoading, false);
      expect(viewModel.items, isEmpty);
    });

    test('carga datos correctamente', () async {
      // Arrange
      when(mockRepository.get[FeatureName]s())
        .thenAnswer((_) async => []);

      // Act
      await viewModel.loadData();

      // Assert
      expect(viewModel.isLoading, false);
      verify(mockRepository.get[FeatureName]s()).called(1);
    });

    test('maneja error de API correctamente', () async {
      // Arrange
      when(mockRepository.get[FeatureName]s())
        .thenThrow(Exception('Error de red'));

      // Act
      await viewModel.loadData();

      // Assert
      expect(viewModel.errorMessage, isNotNull);
      expect(viewModel.isLoading, false);
    });
  });
}
```

### 4.3 Tests de widget

```dart
// test/features/[feature-name]/[feature_name]_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:[proyecto]/features/[feature-name]/presentation/[feature_name]_screen.dart';

void main() {
  group('[FeatureName]Screen', () {
    testWidgets('muestra la pantalla correctamente', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: [FeatureName]Screen(),
        ),
      );

      expect(find.byType([FeatureName]Screen), findsOneWidget);
    });

    testWidgets('muestra estado de carga mientras obtiene datos', (tester) async {
      // Configurar mock
      await tester.pumpWidget(
        const MaterialApp(home: [FeatureName]Screen()),
      );
      await tester.pump();

      // Verificar spinner de carga
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
```

---

## Paso 5: Integrar la feature al proyecto

1. **Agregar la ruta** en el archivo de navegacion (GoRouter o Navigator):

```dart
// En app_router.dart
GoRoute(
  path: '/[feature-name]',
  name: '[FeatureName]Route',
  builder: (context, state) => const [FeatureName]Screen(),
),
```

2. **Registrar los providers/BLoC** en el punto de entrada apropiado

3. **Agregar acceso a la feature** desde donde corresponda (boton, tab, menu)

---

## Paso 6: Actualizar documentacion

**Obligatorio despues de completar la feature:**

1. Actualizar `docs/ARCHITECTURE.md` con la feature nueva
2. Actualizar `docs/PROJECT_SCOPE.md`:
   - Incrementar version
   - Marcar la feature como ✅ completada
   - Actualizar estructura de archivos

3. Si la feature consume un API, actualizar `docs/API.md` con los endpoints usados

4. Actualizar `docs/CHANGELOG.md`:
```markdown
## [fecha] - Claude
- ✅ Feature [FeatureName]: [descripcion corta de lo que hace]
```

---

## Reglas criticas

1. **NUNCA** crear una feature sin primero entender la arquitectura del proyecto
2. **NUNCA** hacer llamadas al API directamente en un widget
3. **NUNCA** usar colores o tamaños hardcodeados, siempre tokens de `AppColors`, `AppTypography`, `AppSpacing`
4. **SIEMPRE** crear tests antes de implementar la logica completa
5. **SIEMPRE** manejar los 3 estados: cargando, con datos, con error
6. **SIEMPRE** documentar la feature al terminar

---

## Relacionado

- Skill `/mv-dev:flutter-architecture` - Si necesitas definir/revisar la arquitectura primero
- Skill `/mv-dev:flutter-new-screen` - Para crear pantallas individuales
- Skill `/mv-dev:flutter-component` - Para crear widgets reutilizables
- Skill `/mv-dev:flutter-visual-style` - Para aplicar el design system de MV
- Skill `/mv-dev:mv-docs` - Para buscar la documentacion del API en Notion
