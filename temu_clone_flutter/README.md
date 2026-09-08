# Replica estatica en Flutter

Esta carpeta contiene una replica visual estatica de la pantalla de referencia proporcionada.

## Caracteristicas
- Flutter puro, sin paquetes externos.
- No tiene botones ni navegacion funcional.
- Mantiene la proporcion visual 709x1600 de la referencia.
- La pantalla se muestra a pantalla completa para conservar el aspecto del mockup.

## Ejecutar

```bash
flutter pub get
flutter run
```

Para Android:

```bash
flutter build apk --release
```

## Nota
La replica utiliza la imagen de referencia como recurso visual para conseguir una coincidencia pixel-a-pixel de la pantalla solicitada. Si necesitas una segunda version construida 100% con widgets Flutter (sin usar la captura como recurso), se puede sustituir `main.dart` por una implementacion de componentes visuales equivalentes.
