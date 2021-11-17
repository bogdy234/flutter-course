import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './presentation/my_flutter_app_icons.dart';

void main() {
  runApp(const MyApp());
  sharedPrefInit();
}

void sharedPrefInit() async {
  try {
    /// Checks if shared preference exist
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    prefs.getString("app-name");
  } catch (err) {
    /// setMockInitialValues initiates shared preference
    /// Adds app-name
    // SharedPreferences.setMockInitialValues({});
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    prefs.setString("app-name", "my-app");
  }
}

/// Adding a list or object
/// Use import 'dart:convert'; for jsonEncode
dynamic putJson(key, val) async {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final SharedPreferences prefs = await _prefs;
  var valString = jsonEncode(val);
  var _res = prefs.setString("$key", valString);
  return _res;
}

/// Get list or object
/// Use import 'dart:convert'; for jsonEncode
/// Argument [key]
dynamic getJson(key) async {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final SharedPreferences prefs = await _prefs;
  String? jsonString = prefs.getString("$key");
  var _res = jsonDecode(jsonString!);
  return _res;
}

Future reset() async {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final SharedPreferences prefs = await _prefs;
  prefs.clear();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guess Number',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Guess my number'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class CustomMinMaxValueInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text != '') {
      int parsedValue = int.parse(newValue.text);
      if (parsedValue < 1 || parsedValue > 100) {
        return oldValue;
      }
    }
    return newValue;
  }
}

int generateRandomNumber() {
  return Random().nextInt(99) + 1;
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController inputController = TextEditingController();
  int randomNumber = generateRandomNumber();
  String resultText = '';
  String buttonText = 'Guess';
  Set<int> scores = {};
  int count = 1;

  void handleReset() {
    randomNumber = generateRandomNumber();
    setState(() {
      inputController.text = '';
      resultText = '';
      buttonText = 'Guess';
      count = 1;
    });
  }

  @override
  initState() {
    super.initState();
    initScores();
  }

  initScores() async {
    List valuesList = await getJson('scores');
    scores = {...valuesList};
  }

  void handleConfirm() {
    inputController.text = '';
    Navigator.of(context).pop();
  }

  Widget _buildPopupDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('You guessed right'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("It was $randomNumber"),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            handleReset();
            Navigator.of(context).pop();
          },
          child: const Text('Try again!'),
        ),
        TextButton(
          onPressed: handleConfirm,
          child: const Text('OK'),
        ),
      ],
    );
  }

  void guessClickHandler() {
    if (buttonText == 'Reset') {
      handleReset();
      return;
    }
    String inputNumber = inputController.text;
    int? parsedNumber = int.tryParse(inputNumber);

    setState(() {
      if (parsedNumber != null) {
        String clueText = '';
        if (parsedNumber < randomNumber) {
          clueText = 'Try higher';
          count++;
        } else if (parsedNumber > randomNumber) {
          clueText = 'Try lower';
          count++;
        } else {
          inputController.text = '';
          clueText = 'You guessed right.';
          buttonText = 'Reset';
          FocusScope.of(context).unfocus();
          showDialog(
            context: context,
            builder: (BuildContext context) => _buildPopupDialog(context),
          );
          scores.add(count);
          putJson('scores', scores.toList());
        }
        resultText = 'You tried $inputNumber\n$clueText';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(220, 220, 220, 1),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.title),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LeaderBoard(
                      title: 'Leaderboard',
                      data: scores.toList(),
                    ),
                  ),
                );
              },
              icon: const Icon(
                MyFlutterApp.award,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Text(
                  "I'm thinking of a number between\n1 and 100.",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 20.0,
                  ),
                  child: const Text(
                    "It's your turn to guess my number!",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 20.0,
                  ),
                  child: Text(
                    resultText,
                    style: const TextStyle(
                      fontSize: 44,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 20.0,
                  ),
                  child: Card(
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                            top: 20.0,
                          ),
                          child: const Text(
                            'Try a number!',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(
                            20.0,
                          ),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: inputController,
                            inputFormatters: <TextInputFormatter>[
                              CustomMinMaxValueInputFormatter(),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            enabled: buttonText == 'Guess',
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                            bottom: 20.0,
                          ),
                          child: ElevatedButton(
                            onPressed: guessClickHandler,
                            child: Text(
                              buttonText,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class LeaderBoard extends StatelessWidget {
  const LeaderBoard({Key? key, required this.title, required this.data})
      : super(key: key);
  final String title;
  final List<int> data;

  List<Widget> generateCards() {
    data.sort((int a, int b) => a.compareTo(b));
    return data.asMap().entries.map(
      (dataEntry) {
        int index = dataEntry.key;
        int value = dataEntry.value;
        return FractionallySizedBox(
          widthFactor: 1,
          child: SizedBox(
            height: 50,
            child: Card(
              color: index < 3 ? Colors.green : Colors.white,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      left: 20.0,
                    ),
                    child: Text(
                      '${index + 1}. You guessed in $value tries',
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      right: 15.0,
                    ),
                    child: index == 0 ? const Icon(MyFlutterApp.award_1) : null,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(220, 220, 220, 1),
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: generateCards(),
          ),
        ),
      ),
    );
  }
}
