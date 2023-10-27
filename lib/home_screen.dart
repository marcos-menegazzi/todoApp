import 'package:flutter/material.dart';
import 'package:myapp/add_update_screen.dart';
import 'package:myapp/database/db_handler.dart';
import 'package:myapp/models/todo_model.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  DBHelper? dbHelper;
  late Future<List<TodoModel>> dataList;

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
    return Scaffold(
      drawer: const Drawer(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text(
          'Todo App',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            letterSpacing: 1
          )
        ),
        centerTitle: true,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(Icons.help_outline_rounded),
          ),
        ],
      ),
      body: Column(children: [
        Expanded(
            child: FutureBuilder(
                future: dataList,
                builder: (context, AsyncSnapshot<List<TodoModel>> snapshot) {
                  if(!snapshot.hasData || snapshot.data == null) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if(snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        "Não localizado nenhuma task",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                        ),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        int todoId = snapshot.data![index].id!.toInt();
                        String title = snapshot.data![index].title!.toString();
                        String description = snapshot.data![index].description!.toString();
                        return Dismissible(
                            key: ValueKey<int>(todoId),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: Colors.deepOrange,
                              child: const Icon(Icons.delete_forever, color: Colors.white,),
                            ),
                            onDismissed: (DismissDirection direction) {
                              setState(() {
                                dbHelper!.delete(todoId);
                                loadData();
                                snapshot.data!.remove(snapshot.data![index]);
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                color: Colors.yellow,
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black38,
                                    blurRadius: 12,
                                    spreadRadius: 1
                                  )
                                ]
                              ),
                              child: Column(
                                children: [
                                  ListTile(
                                    contentPadding: const EdgeInsets.all(10),
                                    title: Padding(
                                      padding: const EdgeInsets.only(bottom: 10),
                                      child: Text(
                                        title,
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    subtitle: Text(
                                      description,
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ),
                                  const Divider(
                                    color: Colors.black54,
                                    thickness: 0.8,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 3,
                                        horizontal: 10
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(context, MaterialPageRoute(
                                                builder: (context) => AddUpdateTask(
                                                  id: todoId,
                                                  title: title,
                                                  description: description,
                                                  update: true
                                                )
                                            ));
                                          },
                                          child: const Icon(Icons.edit_note),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                        );
                      },
                    );
                  }
                }
            )
        )
      ]),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddUpdateTask(),
              )
          );
        },
      ),
    );
  }
}