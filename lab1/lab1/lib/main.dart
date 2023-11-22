import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> listSubjects = [
    'Mobilni i informaciski sistemi',
    'Implementacija na sistemi so sloboden i otvoren kod',
    'Timski proekt',
    'Programski paradigmi',
    'Prava na drushtva',
    'Modeliranje i simulacija'
  ];
  final TextEditingController _textEditingController = TextEditingController();

  void _addSubject(String title) {
    setState(() {
      listSubjects.add(title);
    });
    _textEditingController.clear();
  }

  Widget _buildSubject(int index, String title) {
    return ListTile(
      title: Text(title),
      trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            removeSubject(index);
          }),
    );
  }

  Future<dynamic> _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Dodadi predmet'),
            content: TextField(
              controller: _textEditingController,
              decoration: const InputDecoration(),
            ),
            actions: <Widget>[
              // add button
              OutlinedButton(
                child: const Text('ADD'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _addSubject(_textEditingController.text);
                },
              ),
              OutlinedButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  List<Widget> _getItems() {
    final List<Widget> subjectWidgets = <Widget>[];
    int i = 0;
    for (String title in listSubjects) {
      subjectWidgets.add(_buildSubject(i, title));
      i += 1;
    }
    return subjectWidgets;
  }

  @override
  Widget build(BuildContext context) {
    const index = "206004";
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(index),
      ),
      body: ListView(children: _getItems()),
      floatingActionButton: FloatingActionButton(
          onPressed: () => _displayDialog(context),
          tooltip: 'Add Item',
          child: const Icon(Icons.add)),
    );
  }

  void removeSubject(int index) {
    setState(() {
      listSubjects.removeAt(index);
    });
  }
}
