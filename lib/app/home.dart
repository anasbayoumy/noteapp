import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:mynoteapp/app/notes/edit.dart';
import 'package:mynoteapp/app/notes/view.dart';
import 'package:mynoteapp/components/crud.dart';
import 'package:mynoteapp/constant/links.dart';
import 'package:mynoteapp/main.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Crud _crud = Crud();
  late Future<List<dynamic>> _notesFuture;

  @override
  void initState() {
    super.initState();
    _notesFuture = getNotes();
  }

  Future<List<dynamic>> getNotes() async {
    var response = await _crud.postRequest(linkview, {
      "id": sharedPreferences.getString("id"),
    });

    if (response != null && response["status"] == "success") {
      return response["data"];
    } else {
      return [];
    }
  }

  Future<void> deleteNote(String noteId) async {
    var response = await _crud.postRequest(linkdelete, {
      "id": noteId,
    });

    if (response != null && response['status'] == 'success') {
      setState(() {
        _notesFuture = getNotes(); // Refresh the note list
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete note'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 235, 216, 47),
        title: const Center(child: Text("Home")),
        shadowColor: const Color.fromARGB(255, 136, 130, 81),
        elevation: BorderSide.strokeAlignCenter,
        actions: [
          IconButton(
            onPressed: () {
              AwesomeDialog(
                context: context,
                animType: AnimType.scale,
                dialogType: DialogType.question,
                body: const Center(
                  child: Text(
                    "Are you sure you want to exit the app?!",
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                title: 'Exit',
                btnCancelOnPress: () {},
                btnCancelColor: Colors.red,
                btnOkColor: const Color.fromARGB(255, 235, 216, 47),
                btnOkOnPress: () {
                  sharedPreferences.clear();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil("Login", (route) => false);
                },
                btnOkText: "YES",
              ).show();
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255, 235, 216, 47),
        onPressed: () {
          Navigator.of(context).pushNamed("AddNotes");
        },
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        child: FutureBuilder<List<dynamic>>(
          future: _notesFuture,
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No notes found"));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  var note = snapshot.data![index];
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ViewNotes(
                                notes: snapshot.data![index],
                              )));
                    },
                    child: Card(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Image.asset(
                              "images/logo_n.png",
                              width: 100,
                              height: 100,
                              fit: BoxFit.contain,
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: ListTile(
                              title: Text(note['note_title']),
                              subtitle: Text(note['note_content']),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.blue),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) => EditNotes(
                                                    notes:
                                                        snapshot.data![index],
                                                  )));
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () {
                                      AwesomeDialog(
                                        context: context,
                                        animType: AnimType.scale,
                                        dialogType: DialogType.question,
                                        body: const Center(
                                          child: Text(
                                            "Are you sure you want to delete this note?",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic),
                                          ),
                                        ),
                                        title: 'Question',
                                        btnCancelOnPress: () {},
                                        btnCancelColor: const Color.fromARGB(
                                            255, 235, 216, 47),
                                        btnOkColor: Colors.red,
                                        btnOkOnPress: () async {
                                          await deleteNote(
                                              note['note_id'].toString());
                                        },
                                        btnOkText: "Delete",
                                      ).show();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
