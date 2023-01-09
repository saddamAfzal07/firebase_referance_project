import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_referance_project/pages/realtime_database.dart/posts.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  TextEditingController searchController = TextEditingController();
  TextEditingController editController = TextEditingController();

  final ref = FirebaseDatabase.instance.ref("Category");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Homepage"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Posts(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onChanged: (String value) {
                searchController.text = value;
                setState(() {});
              },
              controller: searchController,
              decoration: const InputDecoration(
                  hintText: "Search", border: OutlineInputBorder()),
            ),
          ),
          // Expanded(
          //   child: StreamBuilder(
          //       stream: ref.onValue,
          //       builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          //         if (snapshot.hasData) {
          //           Map<dynamic, dynamic> map =
          //               snapshot.data!.snapshot.value as dynamic;
          //           List<dynamic> list = [];
          //           list.clear();
          //           list = map.values.toList();
          //           return ListView.builder(
          //             itemCount: snapshot.data!.snapshot.children.length,
          //             itemBuilder: (context, index) {
          //               return ListTile(
          //                 title: Text(list[index]["title"].toString()),
          //               );
          //             },
          //           );
          //         } else {
          //           return const Center(
          //             child: CircularProgressIndicator(),
          //           );
          //         }
          //       }),
          // ),
          Expanded(
            child: FirebaseAnimatedList(
              defaultChild: const Center(child: CircularProgressIndicator()),
              query: ref,
              itemBuilder: (context, snapshot, animation, index) {
                final title = snapshot.child("title").value.toString();
                if (searchController.text.isEmpty) {
                  return ListTile(
                    title: Text(
                      snapshot.child("title").value.toString(),
                    ),
                    subtitle: Text(
                      snapshot.child("id").value.toString(),
                    ),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: ListTile(
                            onTap: () {
                              print("enter");
                              Navigator.pop(context);
                              dialogueShow(
                                title,
                                snapshot.child("id").value.toString(),
                              );
                            },
                            title: Icon(Icons.edit),
                            trailing: Text("Edit"),
                          ),
                        ),
                        PopupMenuItem(
                          child: ListTile(
                            onTap: () {
                              print("enter");
                              ref
                                  .child(snapshot.child("id").value.toString())
                                  .remove();
                              Navigator.pop(context);
                            },
                            title: const Icon(Icons.delete),
                            trailing: const Text("Delete"),
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (title
                    .toLowerCase()
                    .contains(searchController.text.toLowerCase().toString())) {
                  return ListTile(
                    title: Text(
                      snapshot.child("title").value.toString(),
                    ),
                    subtitle: Text(
                      snapshot.child("id").value.toString(),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> dialogueShow(String title, String id) {
    editController.text = title;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: TextField(
            controller: editController,
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  print(id);
                  ref.child(id).update(
                    {"title": editController.text},
                  ).then((value) {
                    Fluttertoast.showToast(
                        msg: "Successfully Added",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }).onError((error, stackTrace) {
                    Fluttertoast.showToast(
                        msg: "Something went wrong try again",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  });
                },
                child: const Text("EDIT")),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("DELETE")),
          ],
        );
      },
    );
  }
}
