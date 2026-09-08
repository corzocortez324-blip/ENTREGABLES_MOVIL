# Revisión de la entrega

Fecha: 8 de septiembre de 2026. Entorno: Windows, Flutter 3.47.0 y Dart 3.13.0.

## Análisis y pruebas

| Proyecto | flutter analyze | Pruebas aprobadas |
| --- | --- | ---: |
| calculadora_flutter | Sin incidencias | 11 |
| flutter_application_1 | Sin incidencias | 1 |
| proyecto_productos | Sin incidencias | 1 |
| interfaz_adaptativa_y_sensores | Sin incidencias | 6 |
| temu_clone_flutter | Sin incidencias | 2 |

Los cinco proyectos compilaron correctamente con `flutter build apk --debug`. Los APK permanecen en `build/app/outputs/flutter-apk/app-debug.apk` dentro de cada proyecto local y se excluyen del repositorio.

Durante la compilación se regeneró una caché de Gradle bloqueada en el SDK de Flutter y se instaló Android SDK Platform 34, requerido por el proyecto de sensores.

## Correcciones

- Calculadora: entradas decimales válidas, protección ante división por cero, recuperación de errores, operaciones encadenadas, borrado y comportamiento de igual sin operación. Sustitución de la prueba de contador por casos reales de cálculo.
- Aplicación inicial: eliminación de un archivo vacío que importaba Riverpod sin declarar la dependencia.
- Productos: nombre de paquete e identificadores propios para evitar conflictos con sensores, color de tema opaco, dependencia HTTP explícita, tiempo límite de las solicitudes y permisos de Internet en Android/macOS. Se conserva la maqueta original y sus servicios preparados.
- Sensores: manejo de errores de consulta y del flujo de conectividad, tarjetas que crecen con su contenido y etiquetas ajustables en pantallas pequeñas. Pruebas de 320, 600 y 1024 píxeles, navegación y fallo del sensor.
- Temu: proporción de imagen preservada en vertical y horizontal, pruebas de tamaño y generación de las plataformas Android y web que faltaban.
- Repositorio: una carpeta por aplicación, sin proyectos anidados ni cachés versionadas. Se mantienen los archivos de bloqueo de dependencias.

## Repetir la revisión

Desde PowerShell, ejecutar `./validar.ps1`. El script se detiene si falla una dependencia, el formato, el análisis o alguna prueba.

## Alcance

No se probó en un teléfono físico ni se compilaron iOS, macOS o Linux. Windows requiere componentes adicionales de Visual Studio en este equipo. Los servicios HTTP no se probaron contra la API en vivo. Productos conserva datos de ejemplo y Temu es una imagen estática; no se añadieron funciones comerciales.
