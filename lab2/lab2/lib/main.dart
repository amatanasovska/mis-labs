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
  List<String> listClothes = [
  ];
  final TextEditingController _textEditingController = TextEditingController();

  void _addClothing(String piece) {
    setState(() {
      listClothes.add(piece);
    });
    _textEditingController.clear();
  }

  void _editClothing(String newVal, int indexFound) {
    setState(() {
      if (indexFound != -1) {
        listClothes[indexFound] = newVal;
      }
    });
    _textEditingController.clear();
  }
  Widget _buildSubject(int index, String piece) {
    return ListTile(
      title: Text(piece),
      trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            removeClothing(index);
          }),
    );
  }

  Future<dynamic> _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add clothing'),
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
                  _addClothing(_textEditingController.text);
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

  Future<dynamic> _displayDialogEdit(BuildContext context, int index) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Edit clothing'),
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
                  _editClothing(_textEditingController.text, index);
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
    final List<Widget> clothesWidgets = <Widget>[];
    int i = 0;
    for (String title in listClothes) {
      clothesWidgets.add(_buildSubject(i, title));
      i += 1;
    }
    return clothesWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Clothes List'),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: listClothes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(listClothes[index]),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.red),
                          onPressed: () {
                            _displayDialogEdit(context,index);
                            },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            removeClothing(index);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              color: Colors.blue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _displayDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      onPrimary: Colors.red,
                    ),
                    child: Text('Add'),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void removeClothing(int index) {
    setState(() {
      listClothes.removeAt(index);
    });
  }
}
