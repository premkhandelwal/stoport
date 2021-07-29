import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:stoport/data/notes.dart';
import 'package:stoport/repositories/notes_repo.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final NotesRepository notesRepository;
  NotesBloc({required this.notesRepository}) : super(NotesInitial());

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
    } else if (event is SearchNotes) {
      yield* _mapSearchNotesToState(event);
    }
  }

  Stream<NotesState> _mapAddNotesToState(AddNote event) async* {
    yield NotesOperationInProgress();
    bool response = await notesRepository.addNewNotes(event.note);
    yield NotesOperationSuccess(response);
  }

  Stream<NotesState> _mapUpdateNotesToState(UpdateNote event) async* {
    yield NotesOperationInProgress();

    bool response = await notesRepository.updateExistingNotes(event.note);
    yield NotesOperationSuccess(response);
  }

  Stream<NotesState> _mapDeleteNotesToState(DeleteNotes event) async* {
    notesRepository.deleteNotes(event.notes);
  }

  Stream<NotesState> _mapFetchAllNotesToState() async* {
    print("Hey");
    var notes = await notesRepository.fetchAllNotes();
    yield NotesLoadSuccess(notes);
  }

  Stream<NotesState> _mapSearchNotesToState(SearchNotes event) async* {
    yield NotesSearch.loading();
    try {
      List<Notes?>? notes = await _getSearchResults(event.notes, event.query);
      yield NotesSearch.success(notes);
    } catch (_) {
      yield NotesSearch.failure();
    }
  }

  @override
  void add(NotesEvent event) {
    super.add(event);
  }

  Future<List<Notes?>?>? _getSearchResults(
      List<Notes?>? notes, String query) async {
    var searchedNotes = query != ""
        ? notes?.where((element) {
            return element!.companyName!
                .toLowerCase()
                .startsWith(query.toLowerCase());
          }).toList()
        : notes;
    return searchedNotes;
  }
}
