import 'package:flutter/material.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:provider/provider.dart';
import 'package:provider_learning/model/todo_model.dart';
import 'package:provider_learning/provider/todo_provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => TodoProvider())
  ], child: const MyApp(),));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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

  final _textController = TextEditingController();

  Future<void> _showDialogue() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add TODO List"),
          content: TextField(
            controller: _textController,
            decoration: const InputDecoration(hintText: "write to do item"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _textController.clear();
                Navigator.pop(context);
              },
              child: const Text("Cancel")
            ),
            TextButton(
              onPressed: () {
                if(_textController.text.isEmpty){
                  return;
                }
                context.read<TodoProvider>().addTODOList(TODOModel(title: _textController.text, isCompleted: false));
                _textController.clear();
                Navigator.pop(context);
              },
              child: const Text("Add")
            )
          ],
        );
      }
    );
  }



  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<TodoProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFF622CA7),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(40),
                    bottomLeft: Radius.circular(40))),
                child: const Center(
                  child: Text(
                    "TODO List",
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                  ),
                ),
              )
            ),
            Expanded(
              flex: 3,
              child: ListView.builder(
                itemBuilder: (context, itemIndex) {
                return ListTile(
                  onTap: () {
                    provider.todoStatusChange(provider.allTODOList[itemIndex]);
                  },
                  leading: MSHCheckbox(
                    size: 30,
                    value: provider.allTODOList[itemIndex].isCompleted,
                    colorConfig: MSHColorConfig.fromCheckedUncheckedDisabled(checkedColor: Colors.blue),
                    style: MSHCheckboxStyle.stroke,
                    onChanged: (selected) {
                      provider.todoStatusChange(provider.allTODOList[itemIndex]);
                    },
                  ),
                  title: Text(
                    provider.allTODOList[itemIndex].title,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      decoration: provider.allTODOList[itemIndex].isCompleted == true ? TextDecoration.lineThrough : null
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      provider.deleteTODOList(provider.allTODOList[itemIndex]);
                    },
                    icon: const Icon(Icons.delete),
                  ),
                );
              }, itemCount: provider.allTODOList.length,)
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showDialogue();
        },
        backgroundColor: const Color(0xFF622CA7),
        child: const Icon(Icons.add),
      ),
    );
  }
}
