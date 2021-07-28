import 'package:stoport/data/dataProviderFirebase.dart';
import 'package:stoport/data/notes.dart';

class NotesRepository {
  final DataProviderFirebase? dataProviderFirebase;

  NotesRepository({required this.dataProviderFirebase});

  Future<void> addNewNotes(Notes notes) async {
    dataProviderFirebase?.addNewNotes(notes);
  }

  Future<void> updateExistingNotes(Notes notes) async {
    dataProviderFirebase?.updateExistingNotes(notes);
  }

  Future<void> deleteNotes(List<String?> notes) async {
    dataProviderFirebase?.deleteNotes(notes);
  }

  Future<List<Notes?>?>? fetchAllNotes() async {
    List<Notes?>? x = <Notes>[];
    x = await dataProviderFirebase?.fetchAllNotes();
    return x;
  }
  
}
