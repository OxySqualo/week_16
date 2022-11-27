import 'package:flutter/material.dart';

import 'package:week_16/services/noteRepository.dart';

import '../model/note.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final _notesRepo = NotesRepository();
  late var _notes = [];

  @override
  void initState() {
    super.initState();
    _notesRepo
        .initDB()
        .whenComplete(() => setState(() => _notes = _notesRepo.notes));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Note"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: _notes.length,
        itemBuilder: ((_, index) => ListTile(
            onTap: () {
              _showDialog2((_notes[index]));
            },
            title: Text(_notes[index].name),
            subtitle: Text(_notes[index].description),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    _showDialog2(_notes[index]);
                  },
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                    onPressed: (() {
                      _notesRepo.deleteNote(_notes[index]);
                      setState(() {
                        _notes = _notesRepo.notes;
                      });
                    }),
                    icon: Icon(Icons.delete_sharp))
              ],
            ))),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => _showDialog1(), child: const Icon(Icons.add)),
    );
  }

  Future _showDialog1() => showGeneralDialog(
      context: context,
      pageBuilder: ((
        _,
        __,
        ___,
      ) {
        final nameController = TextEditingController();
        final descriptionController = TextEditingController();

        return AlertDialog(
          title: const Text("Note"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  icon: const Icon(Icons.add_task),
                  hintText: "Name",
                  enabledBorder: enabledBorderStyle(),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    icon: const Icon(Icons.star_border),
                    hintText: "Description",
                    enabledBorder: enabledBorderStyle(),
                  )),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () async {
                  await _notesRepo.addNote(
                    Note(
                        name: nameController.text,
                        description: descriptionController.text),
                  );
                  setState(() {
                    _notes = _notesRepo.notes;
                    Navigator.pop(context);
                  });
                },
                child: const Text("Add",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold))),
          ],
        );
      }));

  Future _showDialog2(Note note) => showGeneralDialog(
        context: context,
        pageBuilder: (_, __, ___) {
          final nameController = TextEditingController();
          final descController = TextEditingController();
          return AlertDialog(
            title: const Text('Edit note'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: note.name,
                    enabledBorder: enabledBorderStyle(),
                    icon: const Icon(Icons.add_task),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextField(
                  controller: descController,
                  decoration: InputDecoration(
                      hintText: note.description,
                      enabledBorder: enabledBorderStyle(),
                      icon: const Icon(Icons.star_border)),
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    final updatedNote = Note(
                        name: nameController.text,
                        description: descController.text);
                    _notesRepo.updateNote(note, updatedNote);
                    setState(() {
                      _notes = _notesRepo.notes;
                      Navigator.pop(context);
                    });
                  },
                  child: const Text('Save',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold))),
            ],
          );
        },
      );
}

OutlineInputBorder enabledBorderStyle() {
  return const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.amberAccent, width: 3.0),
      borderRadius: BorderRadius.all(Radius.circular(9.0)));
}
