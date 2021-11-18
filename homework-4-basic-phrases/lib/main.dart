import 'package:audioplayers/audioplayers.dart';
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

class Phrase {
  Phrase({required this.phraseText, required this.audioPath});

  final String phraseText;
  final String audioPath;

}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

List<Phrase> firstLanguageTextForCards = <Phrase>[
  Phrase(phraseText: 'Salut', audioPath: 'sound/ro0.mp3'),
  Phrase(phraseText: 'Ce faci?', audioPath: 'sound/ro1.mp3'),
  Phrase(phraseText: 'Cum esti?', audioPath: 'sound/ro2.mp3'),
  Phrase(phraseText: 'Dimineata', audioPath: 'sound/ro3.mp3'),
  Phrase(phraseText: 'Seara', audioPath: 'sound/ro4.mp3'),
];
List<Phrase> secondLanguageTextForCards = <Phrase>[
  Phrase(phraseText: 'Hallo', audioPath: 'sound/ger0.mp3'),
  Phrase(phraseText: 'Was machst du?', audioPath: 'sound/ger1.mp3'),
  Phrase(phraseText: 'Wie gehts?', audioPath: 'sound/ger2.mp3'),
  Phrase(phraseText: 'Morgen', audioPath: 'sound/ger3.mp3'),
  Phrase(phraseText: 'Abends', audioPath: 'sound/ger4.mp3'),
];

class _MyHomePageState extends State<MyHomePage> {
  AudioCache audioCache = AudioCache();
  AudioPlayer advancedPlayer = AudioPlayer();

  void playLocal(String path) {
    audioCache.play(path);
  }

  Widget getCard(Phrase cardPhrase) {
    return GestureDetector(
      onTap: () {
        playLocal(cardPhrase.audioPath);
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: <Color>[
            Colors.blue.shade700,
            Colors.blue.shade300,
          ]),
          borderRadius: const BorderRadius.all(Radius.circular(30.0)),
        ),
        child: Align(
          child: Text(
            cardPhrase.phraseText,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  List<Widget> getCards(List<Phrase> firstCardsText,
      List<Phrase> secondCardsText) {
    final List<Widget> cards = <Widget>[];
    for (int i = 0; i < firstCardsText.length; i++) {
      cards.add(getCard(firstCardsText[i]));
      cards.add(getCard(secondCardsText[i]));
    }
    return cards;
  }

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
        children: getCards(
            firstLanguageTextForCards, secondLanguageTextForCards),
      ),
    );
  }
}