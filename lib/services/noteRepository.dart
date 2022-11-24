import '../model/note.dart';

class NotesRepository {
  final _notes = <Note>[];
  List<Note> get notes => _notes;

  void addNotes(Note note) {
    _notes.add(note);
  }
}
