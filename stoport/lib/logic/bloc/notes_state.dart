part of 'notes_bloc.dart';

@immutable
abstract class NotesState {}

class NotesInitial extends NotesState {
  NotesInitial();
}

class NotesLoadInProgress extends NotesState {}

class NotesLoadSuccess extends NotesState {
  NotesLoadSuccess(this.notes);

  final List<Notes?>? notes;
}

class NotesOperationInProgress extends NotesState{}

class NotesOperationSuccess extends NotesState {
  final bool success;

  NotesOperationSuccess(this.success);
}

class NotesSearch extends NotesState {
  final List<Notes?>? notes;
  final bool isLoading;
  final bool hasError;

  NotesSearch({
    required this.notes,
    required this.isLoading,
    required this.hasError,
  });

  factory NotesSearch.initial() {
    return NotesSearch(
      notes: [],
      isLoading: false,
      hasError: false,
    );
  }

  factory NotesSearch.loading() {
    return NotesSearch(
      notes: [],
      isLoading: true,
      hasError: false,
    );
  }

  factory NotesSearch.success(List<Notes?>? notes) {
    return NotesSearch(
      notes: notes,
      isLoading: false,
      hasError: false,
    );
  }

  factory NotesSearch.failure() {
    return NotesSearch(
      notes: [],
      isLoading: false,
      hasError: true,
    );
  }
}
