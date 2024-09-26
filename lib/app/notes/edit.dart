import 'package:flutter/material.dart';
import 'package:mynoteapp/components/crud.dart';
import 'package:mynoteapp/components/customformfield.dart';
import 'package:mynoteapp/constant/links.dart';

class EditNotes extends StatefulWidget {
  final notes;
  const EditNotes({super.key, this.notes});

  @override
  State<EditNotes> createState() => _EditNotesState();
}

GlobalKey<FormState> formstate = GlobalKey();

class _EditNotesState extends State<EditNotes> {
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();

  final Crud _crud = Crud();

  Future<void> editNote() async {
    if (formstate.currentState!.validate()) {
      var response = await _crud.postRequest(linkedit, {
        "title": title.text,
        "content": content.text,
        "id": widget.notes['note_id'].toString(),
      });

      if (response['status'] == "success") {
        Navigator.of(context).pushReplacementNamed("Home");
      }
    }
  }

  @override
  void initState() {
    title.text = widget.notes['note_title'];
    content.text = widget.notes['note_content'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 235, 216, 47),
        title: const Text(
          "Edit Notes",
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
                  hint: "eefw",
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
                    onPressed: editNote,
                    height: 40,
                    child: const Text("Save Changes"),
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
