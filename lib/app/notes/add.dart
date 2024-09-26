import 'package:flutter/material.dart';
import 'package:mynoteapp/components/crud.dart';
import 'package:mynoteapp/components/customformfield.dart';
import 'package:mynoteapp/constant/links.dart';
import 'package:mynoteapp/main.dart';

class AddNotes extends StatefulWidget {
  const AddNotes({super.key});

  @override
  State<AddNotes> createState() => _AddNotesState();
}

GlobalKey<FormState> formstate = GlobalKey();

class _AddNotesState extends State<AddNotes> {
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();

  final Crud _crud = Crud();

  Future<void> addNote() async {
    if (formstate.currentState!.validate()) {
      var response = await _crud.postRequest(linkadd, {
        "title": title.text,
        "content": content.text,
        "id": sharedPreferences.getString("id"),
      });

      if (response['status'] == "success") {
        Navigator.of(context).pushReplacementNamed("Home");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 235, 216, 47),
        title: const Text(
          "Add Notes",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
        ),
        shadowColor: const Color.fromARGB(255, 136, 130, 81),
        elevation: BorderSide.strokeAlignCenter,
      ),
      body: Form(
        key: formstate,
        child: ListView(
          padding: const EdgeInsets.all(15),
          children: [
            const SizedBox(height: 50),
            Column(
              children: [
                CustomTextField(
                  valid: (val) {
                    return validfn(val!, 3, 100);
                  },
                  hint: 'Enter Title',
                  mycont: title,
                ),
                const SizedBox(height: 30),
                CustomTextField(
                  valid: (val) {
                    return validfn(val!, 1, 100000000000000);
                  },
                  hint: 'Enter Content',
                  mycont: content,
                ),
                const SizedBox(height: 50),
                Container(
                  width: 200,
                  color: const Color.fromARGB(255, 235, 216, 47),
                  child: MaterialButton(
                    onPressed: addNote,
                    height: 40,
                    child: const Text("Add Note"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
