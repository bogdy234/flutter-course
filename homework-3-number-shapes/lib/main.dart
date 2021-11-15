import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Shapes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Number Shapes'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

bool isSquare(num value) {
  final num x = sqrt(value).round();
  return x * x == value;
}

bool isCube(num value) {
  final num x = pow(value, 1 / 3).round();
  return x * x * x == value;
}

bool isSquareAndCube(num value) {
  return isSquare(value) && isCube(value);
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController inputController = TextEditingController();
  String isSquareCubeText = '';

  Widget _buildPopupDialog(BuildContext context) {
    return AlertDialog(
      title: Text(inputController.text),
      content: Text(isSquareCubeText),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(
                left: 15.0,
                top: 15.0,
                right: 20.0,
                bottom: 20.0,
              ),
              child: const Text('Please input a number to see if it is square or cube.',
                  style: TextStyle(
                    fontSize: 20,
                  )),
            ),
            FractionallySizedBox(
              widthFactor: 0.8,
              child: TextField(
                controller: inputController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final num? value = num.tryParse(inputController.text);
          if (value != null) {
            setState(() {
              if (isSquareAndCube(value)) {
                isSquareCubeText = 'Number $value is both SQUARE and CUBE.';
              } else if (isSquare(value)) {
                isSquareCubeText = 'Number $value is SQUARE.';
              } else if (isCube(value)) {
                isSquareCubeText = 'Number $value is CUBE.';
              } else {
                isSquareCubeText = 'Number $value is neither SQUARE or CUBE.';
              }
            });
            FocusScope.of(context).unfocus();
            showDialog<void>(
              context: context,
              builder: (BuildContext context) => _buildPopupDialog(context),
            );
          }
        },
        child: const Icon(
          Icons.check,
        ),
      ),
    );
  }
}
