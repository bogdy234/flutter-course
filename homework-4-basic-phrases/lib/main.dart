import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Basic Phrases',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Basic Phrases'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

Widget getCard(String cardText) {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(colors: <Color>[
        Colors.blue.shade700,
        Colors.blue.shade300,
      ]),
      borderRadius: const BorderRadius.all(Radius.circular(12.0)),
    ),
    child: Align(
      child: Text(
        cardText,
        style: const TextStyle(color: Colors.white),
      ),
    ),
  );
}

List<Widget> getCards(List<String> cardsText) {
  final List<Widget> cards = <Widget>[];
  for (int i = 0; i < cardsText.length; i++) {
    cards.add(getCard(cardsText[i]));
  }
  return cards;
}

List<String> textForCards = <String>['Salut', 'Ce faci?', 'Cum esti?'];

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: GridView.count(
        mainAxisSpacing: 20.0,
        crossAxisSpacing: 20.0,
        padding: const EdgeInsets.all(10.0),
        crossAxisCount: 2,
        children: getCards(textForCards),
      ),
    );
  }
}
