part of 'notes_bloc.dart';

@immutable
abstract class NotesEvent {}


class AddNote extends NotesEvent {
  AddNote(this.note);
  final Notes note;
}

class FetchAllNotes extends NotesEvent {}

class FetchDeletedNotes extends NotesEvent {}

class UpdateNote extends NotesEvent {
  final Notes note; 

  UpdateNote(
    
    this.note,
  );
}

class DeleteNotes extends NotesEvent {
  final List<String?> notes;
  DeleteNotes(
    this.notes,
  );
}
