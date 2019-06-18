import 'package:flutter/material.dart';

import 'package:localstorage/localstorage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Localstorage Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class TodoItem {
  String title;
  bool done;

  TodoItem({this.title, this.done});

  toJSONEncodable() {
    Map<String, dynamic> m = Map();

    m['title'] = title;
    m['done'] = done;

    return m;
  }
}

class TodoList {
  List<TodoItem> items;

  TodoList() {
    items = List();
  }

  toJSONEncodable() {
    return items.map((item) {
      return item.toJSONEncodable();
    }).toList();
  }
}

class _MyHomePageState extends State<HomePage> {
  final TodoList list = TodoList();
  final LocalStorage storage = LocalStorage('todo_app');
  bool initialized = false;
  TextEditingController controller = TextEditingController();

  _toggleItem(TodoItem item) {
    setState(() {
      item.done = !item.done;
      _saveToStorage();
    });
  }

  _addItem(String title) {
    setState(() {
      final item = TodoItem(title: title, done: false);
      list.items.add(item);
      _saveToStorage();
    });
  }

  _saveToStorage() {
    storage.setItem('todos', list.toJSONEncodable());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Localstorage demo'),
      ),
      body: Container(
          padding: EdgeInsets.all(10.0),
          constraints: BoxConstraints.expand(),
          child: FutureBuilder(
            future: storage.ready,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (!initialized) {
                var items = storage.getItem('todos');

                if (items != null) {
                  (items as List).forEach((item) {
                    final todoItem =
                        TodoItem(title: item['title'], done: item['done']);
                    list.items.add(todoItem);
                  });
                }

                initialized = true;
              }

              List<Widget> widgets = list.items.map((item) {
                return CheckboxListTile(
                  value: item.done,
                  title: Text(item.title),
                  selected: item.done,
                  onChanged: (bool selected) {
                    _toggleItem(item);
                  },
                );
              }).toList();

              return Column(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: ListView(
                      children: widgets,
                      itemExtent: 50.0,
                    ),
                  ),
                  TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      labelText: 'What to do?',
                    ),
                    onEditingComplete: () {
                      _addItem(controller.value.text);
                      controller.clear();
                    },
                  ),
                ],
              );
            },
          )),
    );
  }
}
