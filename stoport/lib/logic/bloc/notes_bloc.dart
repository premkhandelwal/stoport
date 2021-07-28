import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:stoport/data/notes.dart';
import 'package:stoport/repositories/notes_repo.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final NotesRepository? notesRepository;
  NotesBloc({this.notesRepository}) : super(NotesInitial());

  @override
  Stream<NotesState> mapEventToState(
    NotesEvent event,
  ) async* {
    if (state is NotesInitial) {
      yield* _mapFetchAllNotesToState();
    } else if (event is AddNote) {
      yield* _mapAddNotesToState(event);
    } else if (event is UpdateNote) {
      yield* _mapUpdateNotesToState(event);
    } else if (event is FetchAllNotes || state is NotesInitial) {
      yield* _mapFetchAllNotesToState();
    } else if (event is DeleteNotes) {
      yield* _mapDeleteNotesToState(event);
    }
  }

  Stream<NotesState> _mapAddNotesToState(AddNote event) async* {
    notesRepository?.addNewNotes(event.note);
  }

  Stream<NotesState> _mapUpdateNotesToState(UpdateNote event) async* {
    notesRepository?.updateExistingNotes(event.note);
  }

  Stream<NotesState> _mapDeleteNotesToState(DeleteNotes event) async* {
    notesRepository?.deleteNotes(event.notes);
  }

  Stream<NotesState> _mapFetchAllNotesToState() async* {
    print("Hey");
    var notes = await notesRepository?.fetchAllNotes();
    yield NotesLoadSuccess(notes);
  }

  @override
  void add(NotesEvent event) {
    super.add(event);
  }
}
