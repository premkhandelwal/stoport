import 'package:connectivity/connectivity.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stoport/data/dataProviderFirebase.dart';
import 'package:stoport/logic/bloc/cubit/internet_cubit.dart';
import 'package:stoport/logic/bloc/notes_bloc.dart';
import 'package:stoport/repositories/notes_repo.dart';
import 'package:stoport/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp(
    notesRepository:
        NotesRepository(dataProviderFirebase: DataProviderFirebase()),
    connectivity: Connectivity(),
  ));
}

class MyApp extends StatelessWidget {
  final NotesRepository notesRepository;
  final Connectivity connectivity;
  const MyApp(
      {Key? key, required this.notesRepository, required this.connectivity})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NotesBloc>(
            create: (context) => NotesBloc(notesRepository: notesRepository)),
        BlocProvider<InternetCubit>(
            create: (context) => InternetCubit(connectivity: connectivity)),
       
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          accentColor: Colors.black,
          textTheme: TextTheme(
            bodyText1: TextStyle(),
            bodyText2: TextStyle(),
          ).apply(
            bodyColor: Colors.black,
          ),
        ),
        home: HomeScreen(),
      ),
    );
  }
}
