import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'X and 0',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'X and 0'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

Color getColor(int value) {
  if (value == 2) {
    return Colors.blue;
  } else if (value == 1) {
    return Colors.red;
  }
  return Colors.white;
}

class _MyHomePageState extends State<MyHomePage> {
  List<List<int>> tableValues = List<List<int>>.generate(3, (int index) => <int>[0, 0, 0]);

  int playerTurn = 1;

  bool checkWin(int value) {
    final List<List<int>> newTableValues = List<List<int>>.generate(3, (int index) => <int>[0, 0, 0]);

    // Check for line winning
    for (int i = 0; i < tableValues.length; i++) {
      final List<int> filteredList = tableValues[i].where((int element) => element == value).toList();

      if (filteredList.length == tableValues.length) {
        for (int j = 0; j < tableValues[i].length; j++) {
          newTableValues[i][j] = value;
        }

        tableValues = newTableValues;

        return true;
      }
    }

    // Check for column winning
    for (int j = 0; j < tableValues.length; j++) {
      final List<int> column = tableValues.map<int>((List<int> row) => row[j]).toList(growable: false);
      final List<int> filteredList = column.where((int element) => element == value).toList();
      if (filteredList.length == tableValues.length) {
        for (int i = 0; i < tableValues.length; i++) {
          newTableValues[i][j] = value;
        }

        tableValues = newTableValues;
        return true;
      }
    }

    // Check for diagonalWinning
    final List<int> principalDiagonal = <int>[];
    final List<int> secondaryDiagonal = <int>[];

    for (int i = 0; i < tableValues.length; i++) {
      for (int j = 0; j < tableValues.length; j++) {
        if (i == j) {
          principalDiagonal.add(tableValues[i][j]);
        }
        if (i + j == tableValues.length - 1) {
          secondaryDiagonal.add(tableValues[i][j]);
        }
      }
    }

    final List<int> filteredListPrincipal = principalDiagonal.where((int diagValue) => diagValue == value).toList();
    final List<int> filteredListSecondary = secondaryDiagonal.where((int diagValue) => diagValue == value).toList();

    if (filteredListPrincipal.length == tableValues.length) {
      for (int i = 0; i < tableValues.length; i++) {
        for (int j = 0; j < tableValues.length; j++) {
          if (i == j) {
            newTableValues[i][j] = value;
          }
        }
      }
      tableValues = newTableValues;
      return true;
    }

    if (filteredListSecondary.length == tableValues.length) {
      for (int i = 0; i < tableValues.length; i++) {
        for (int j = 0; j < tableValues.length; j++) {
          if (i + j == tableValues.length - 1) {
            newTableValues[i][j] = value;
          }
        }
      }
      tableValues = newTableValues;
      return true;
    }

    // Check for tie - need to verify after all checks for winning.
    final List<int> allTableValues = <int>[];

    for (int i = 0; i < tableValues.length; i++) {
      for (int j = 0; j < tableValues.length; j++) {
        allTableValues.add(tableValues[i][j]);
      }
    }
    if (!allTableValues.contains(0)) {
      return true;
    }

    // If none of the above, the game didn't end.
    return false;
  }

  void handleTapBox(int value, int rowNumber, int columnNumber) {
    setState(() {
      // Player turn -1 means game has ended
      if (value == 0 && playerTurn != -1) {
        tableValues[rowNumber][columnNumber] += playerTurn == 1 ? 1 : 2;
        playerTurn = playerTurn == 1 ? 2 : 1;
      }
    });
    // After updating tableValues check if someone won.
    final bool firstPlayerWon = checkWin(1);
    final bool secondPlayerWon = checkWin(2);

    if (firstPlayerWon || secondPlayerWon) {
      playerTurn = -1;
    }
  }

  List<GestureDetector> generateRow(int rowNumber, List<int> row) {
    return row
        .asMap()
        .map(
          (int key, int value) => MapEntry<int, GestureDetector>(
            key,
            GestureDetector(
              onTap: () => handleTapBox(value, rowNumber, key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: MediaQuery.of(context).size.width * 1 / 3,
                height: MediaQuery.of(context).size.width * 1 / 3,
                decoration: BoxDecoration(
                  border: Border.all(),
                  color: getColor(value),
                ),
              ),
            ),
          ),
        )
        .values
        .toList();
  }

  List<Row> generateTable(List<List<int>> matrix) {
    return matrix
        .asMap()
        .map<int, Row>(
          (int key, List<int> tableRow) => MapEntry<int, Row>(
            key,
            Row(
              children: generateRow(key, tableRow),
            ),
          ),
        )
        .values
        .toList();
  }

  void playAgainHandler() {
    setState(() {
      playerTurn = 1;
      tableValues = List<List<int>>.generate(3, (int index) => <int>[0, 0, 0]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              ...generateTable(tableValues),
            ],
          ),
          Container(
            child: playerTurn == -1
                ? ElevatedButton(
                    onPressed: playAgainHandler,
                    child: const Text('Play again'),
                  )
                : null,
          ),
        ],
      ),
    );
  }
}
