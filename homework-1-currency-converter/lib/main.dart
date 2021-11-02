import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Converter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Currency Converter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController euroController = TextEditingController();
  String _ronValue = '';
  bool _validate = true;

  void _convert() {
    try {
      setState(() {
        _ronValue =
            (double.parse(euroController.text) * 4.5).toStringAsFixed(2) +
                ' RON';
        _validate = true;
      });
    } on Exception catch (_) {
      setState(() {
        _ronValue = '';
        _validate = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image.network(
                'https://i0.1616.ro/media/2/2621/33211/20372704/1/9v8a2732.jpg'),
            FractionallySizedBox(
              child: TextField(
                controller: euroController,
                decoration: InputDecoration(
                  hintText: 'Enter the amount in EUR',
                  errorText: _validate ? null : 'Please enter a number',
                ),
                keyboardType: TextInputType.number,
              ),
              widthFactor: 0.9,
            ),
            ElevatedButton(
                onPressed: _convert,
                child: const Text('CONVERT!'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white24,
                  onPrimary: Colors.black,
                )),
            Text(
              _ronValue,
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
    );
  }
}
