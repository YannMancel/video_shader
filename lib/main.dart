import 'dart:async' show Future;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show Color, FontWeight, Matrix4, Rect, TextAlign, rootBundle;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const kAppName = 'Video Shader';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: kAppName,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(title: kAppName),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  Gradient get _gradient => const SweepGradient(
        colors: <Color>[
          Colors.red,
          Colors.pink,
          Colors.purple,
          Colors.deepPurple,
          Colors.deepPurple,
          Colors.indigo,
          Colors.blue,
          Colors.lightBlue,
          Colors.cyan,
          Colors.teal,
          Colors.green,
          Colors.lightGreen,
          Colors.lime,
          Colors.yellow,
          Colors.amber,
          Colors.orange,
          Colors.deepOrange,
        ],
      );

  @override
  Widget build(BuildContext context) {
    const kText = Text(
      "Yann Mancel\nTest",
      style: TextStyle(
        fontSize: 60.0,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (bounds) => _gradient.createShader(
              Rect.fromLTWH(0, 0, bounds.width, bounds.height),
            ),
            child: kText,
          ),
          const _ImageShaderByAsset(
            child: kText,
          ),
        ],
      ),
    );
  }
}

class _ImageShaderByAsset extends StatelessWidget {
  const _ImageShaderByAsset({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  Future<Shader> _generateShaderByAsset({required String path}) async {
    final byteData = await rootBundle.load(path);
    final image = await decodeImageFromList(byteData.buffer.asUint8List());

    return ImageShader(
      image,
      TileMode.mirror,
      TileMode.mirror,
      Matrix4.identity().storage,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Shader>(
      future: _generateShaderByAsset(path: 'assets/image_16_9.jpg'),
      builder: (_, snapshot) {
        return snapshot.connectionState != ConnectionState.done ||
                snapshot.hasError
            ? const SizedBox.shrink()
            : ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (_) => snapshot.data!,
                child: child,
              );
      },
    );
  }
}
