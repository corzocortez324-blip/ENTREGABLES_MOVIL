# Entregables de desarrollo móvil

Cinco proyectos Flutter independientes, organizados en una sola rama (`master`).

| Carpeta | Contenido |
| --- | --- |
| `calculadora_flutter` | Calculadora con operaciones básicas, decimales y control de errores. |
| `flutter_application_1` | Aplicación inicial Hello World y modelos/servicios de productos. |
| `proyecto_productos` | Maqueta de productos con servicios HTTP y proveedores Riverpod preparados. La pantalla conserva datos de ejemplo. |
| `interfaz_adaptativa_y_sensores` | Panel adaptable con navegación y detección del tipo de conexión de red. |
| `temu_clone_flutter` | Réplica visual estática basada en una imagen; no implementa compras ni navegación. |

## Requisitos y ejecución

Validado con Flutter 3.47.0 y Dart 3.13.0. Desde la carpeta del proyecto elegido:

```sh
flutter pub get
flutter analyze
flutter test
flutter run
```

Para compilar Android: `flutter build apk --debug`. Se necesita Android SDK.

Para validar todos los proyectos desde PowerShell: `./validar.ps1`. Los resultados y el alcance de las comprobaciones están en [REVISION.md](REVISION.md).

Los servicios de productos consultan DummyJSON y requieren acceso a Internet.
El panel de red detecta el medio de conexión; no mide intensidad celular ni garantiza acceso a Internet.

## Organización

Se conserva una copia de cada aplicación. `repo_temporal`, las calculadoras repetidas y la carpeta incompleta `miprimerapp` no forman parte de esta entrega. Las plataformas generadas de cada aplicación sí se incluyen; las cachés y compilaciones se excluyen con `.gitignore`. Los archivos `pubspec.lock` se conservan para reproducir dependencias.
