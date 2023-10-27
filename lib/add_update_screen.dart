import 'package:flutter/material.dart';
import 'package:myapp/database/db_handler.dart';
import 'package:myapp/home_screen.dart';
import 'package:myapp/models/todo_model.dart';

// ignore: must_be_immutable
class AddUpdateTask extends StatefulWidget {
  int? id;
  String? title;
  String? description;
  bool? update;

  AddUpdateTask({
    super.key,
    this.id,
    this.title,
    this.description,
    this.update
  });

  @override
  State<AddUpdateTask> createState() => _AddUpdateTaskState();
}

class _AddUpdateTaskState extends State<AddUpdateTask> {

  DBHelper? dbHelper;
  late Future<List<TodoModel>> dataList;
  final _fromKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    loadData();
  }

  loadData() async {
    dataList = dbHelper!.getAll();
  }
  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController(text: widget.title);
    final descriptionController = TextEditingController(text: widget.description);

    String appTitle = "Create new Task";
    if(widget.update == true) {
      appTitle = "Update task";
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
            appTitle,
            style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                letterSpacing: 1
            )
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {
                if(_fromKey.currentState!.validate()) {
                  if( widget.update == true ) {
                    dbHelper!.update(TodoModel(
                        id: widget.id,
                        title: titleController.text,
                        description: descriptionController.text
                    ));
                  } else {
                    dbHelper!.insert(TodoModel(
                        title: titleController.text,
                        description: descriptionController.text
                    ));
                  }

                  Navigator.push(context, MaterialPageRoute(builder: (context) => const MyHomePage()));
                  titleController.clear();
                  descriptionController.clear();
                }
              },
              child: const Icon(Icons.save),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: SingleChildScrollView(
          child: Column(children: [
            Form(
              key: _fromKey,
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    controller: titleController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Note title",
                    ),
                    validator: (value) {
                      if(value!.isEmpty) {
                        return "Digite o titulo";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    minLines: 5,
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Note Description",
                    ),
                    validator: (value) {
                      if(value!.isEmpty) {
                        return "Digite algum texto";
                      }
                      return null;
                    },
                  ),
                ),
              ],),
            )
          ],),
        ),
      ),
    );
  }
}