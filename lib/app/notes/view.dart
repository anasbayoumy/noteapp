import 'package:flutter/material.dart';
import 'package:mynoteapp/components/crud.dart';
import 'package:mynoteapp/components/customformfield.dart';
import 'package:mynoteapp/constant/links.dart';
import 'package:mynoteapp/main.dart';

class ViewNotes extends StatefulWidget {
  final notes;
  const ViewNotes({super.key, this.notes});

  @override
  State<ViewNotes> createState() => _ViewNotesState();
}

GlobalKey<FormState> formstate = GlobalKey();

class _ViewNotesState extends State<ViewNotes> {
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();

  final Crud _crud = Crud();

  Future<void> ViewNotes() async {
    if (formstate.currentState!.validate()) {
      var response = await _crud.postRequest(linkview, {
        "id": sharedPreferences.getString('id'),
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
          "View Notes",
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
