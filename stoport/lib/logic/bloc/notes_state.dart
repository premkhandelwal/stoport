part of 'notes_bloc.dart';

@immutable
abstract class NotesState {}

class NotesInitial extends NotesState {}


class NotesLoadInProgress extends NotesState {}

class NotesLoadSuccess extends NotesState {
   NotesLoadSuccess(this.notes);

  final List<Notes?>? notes;
}

class NotesOperationSuccess extends NotesState{}