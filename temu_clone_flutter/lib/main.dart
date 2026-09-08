import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const StaticCloneApp());
}

class StaticCloneApp extends StatelessWidget {
  const StaticCloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Compras - Replica estatica',
      theme: ThemeData(useMaterial3: true),
      home: const StaticHomePage(),
    );
  }
}

class StaticHomePage extends StatelessWidget {
  const StaticHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          // La referencia original tiene una proporcion de 709 x 1600.
          // Se mantiene esa proporcion para que la replica se vea igual
          // en diferentes tamanos de pantalla.
          const referenceWidth = 709.0;
          const referenceHeight = 1600.0;

          return ColoredBox(
            color: const Color(0xFFFF6500),
            child: Center(
              child: AspectRatio(
                aspectRatio: referenceWidth / referenceHeight,
                child: FittedBox(
                  fit: BoxFit.fill,
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: referenceWidth,
                    height: referenceHeight,
                    child: Image.asset(
                      'assets/reference.png',
                      fit: BoxFit.fill,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
