import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_referance_project/pages/firestore/add_post.dart';
import 'package:firebase_referance_project/pages/realtime_database.dart/posts.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirestoreHomePaage extends StatefulWidget {
  const FirestoreHomePaage({super.key});

  @override
  State<FirestoreHomePaage> createState() => _FirestoreHomePaageState();
}

class _FirestoreHomePaageState extends State<FirestoreHomePaage> {
  TextEditingController editController = TextEditingController();
  final ref = FirebaseFirestore.instance.collection("users").snapshots();
  final collection = FirebaseFirestore.instance.collection("users");

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
              builder: (context) => const AddPosts(),
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
          StreamBuilder<QuerySnapshot>(
            stream: ref,
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.data == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return Text("Erro");
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        // collection
                        //     .doc(snapshot.data!.docs[index]["id"])
                        //     .update({
                        //   "title": "Saddam Afal",
                        // });
                        collection
                            .doc(snapshot.data!.docs[index]["id"])
                            .delete();
                      },
                      title: Text(snapshot.data!.docs[index]["title"]),
                      subtitle: Text(snapshot.data!.docs[index]["id"]),
                    );
                  },
                ),
              );
            },
          )
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
              },
              child: const Text("EDIT"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("DELETE"),
            ),
          ],
        );
      },
    );
  }
}
