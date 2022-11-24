import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:week_16/services/noteRepository.dart';

import '../model/note.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final _notesRepo = NotesRepository();
  late var _notes = _notesRepo.notes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Note_week_sql")),
      body: ListView.builder(
        itemCount: _notes.length,
        itemBuilder: ((_, index) => ListTile(
              title: Text(_notes[index].name),
              subtitle: Text(_notes[index].description),
            )),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => _showDialog(), child: const Icon(Icons.add)),
    );
  }

  Future _showDialog() => showGeneralDialog(
      context: context,
      pageBuilder: ((
        _,
        __,
        ___,
      ) {
        final nameController = TextEditingController();
        final descriptionController = TextEditingController();

        return AlertDialog(
          backgroundColor: Colors.amberAccent,
          title: Text("Note"),
          content: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  icon: Icon(Icons.ice_skating_outlined),
                  hintText: "Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(9.0)),
                    gapPadding: 4.0,
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.directions_bike),
                    hintText: "Description",
                    border: OutlineInputBorder(),
                  )),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () {
                  _notesRepo.addNotes(
                      Note(nameController.text, descriptionController.text));
                  setState(() {
                    _notes = _notesRepo.notes;
                    Navigator.pop(context);
                  });
                },
                child: Text("Add")),
          ],
        );
      }));
}
