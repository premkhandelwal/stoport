import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stoport/data/notes.dart';
import 'package:stoport/logic/bloc/cubit/internet_cubit.dart';
import 'package:stoport/logic/bloc/notes_bloc.dart';
import 'package:stoport/screens/addUpdate_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = new TextEditingController();
  List<Notes?>? notes = [];
  @override
  void initState() {
    context.read<NotesBloc>().add(FetchAllNotes());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 15),
        child: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, istrue) {
            return [
              SliverAppBar(
                stretch: true,
                floating: true,
                snap: true,
                title: _topActions(
                  context,
                ),
                automaticallyImplyLeading: false,
                centerTitle: true,
                titleSpacing: 0,
                backgroundColor: Colors.transparent,
                elevation: 10,
                expandedHeight: 10,
              )
            ];
          },
          body: RefreshIndicator(
            onRefresh: () async {
              // if the internet connection is available or not etc..
              await Future.delayed(
                Duration(seconds: 2),
              );
              context.read<InternetCubit>();
              context.read<NotesBloc>().add(FetchAllNotes());
            },
            child: BlocBuilder<NotesBloc, NotesState>(
              builder: (context, state) {
                final internetState = context.watch<InternetCubit>().state;

                if (internetState is InternetConnected) {
                  if (state is NotesInitial) {
                    context.read<NotesBloc>().add(FetchAllNotes());
                    return Center(child: CircularProgressIndicator());
                  } else if (state is NotesLoadSuccess) {
                    notes = state.notes;
                    return state.notes!.length != 0
                        ? buildGridView(notes)
                        : Center(
                            child: Text(
                              "No Items Present",
                              style: TextStyle(fontSize: 15),
                            ),
                          );
                  } else if (state is NotesSearch) {
                    notes = state.notes;
                    return state.notes!.length != 0
                        ? buildGridView(notes)
                        : Center(
                            child: Text(
                              "No Items Present",
                              style: TextStyle(fontSize: 15),
                            ),
                          );
                  } else {
                    return Center(
                      child: Text(
                        "No Items Present",
                        style: TextStyle(fontSize: 30),
                      ),
                    );
                  }
                } else {
                  return Center(
                      child: Text(
                    "No Internet",
                    style: TextStyle(fontSize: 30),
                  ));
                }
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddUpdateScreen()));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _topActions(BuildContext context) => Container(
        width: double.infinity,
        height: 60,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: <Widget>[
                const SizedBox(width: 20),
                const Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: searchController,
                    onChanged: (val) {
                      context.read<NotesBloc>().add(SearchNotes(val, notes));
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintText: 'Search your notes',
                        hintStyle: TextStyle(fontSize: 20)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget buildGridView(List<Notes?>? notes) {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.all(10),
      scrollDirection: Axis.vertical,
      itemCount: notes?.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 1.2,
        mainAxisSpacing: 20,
      ),
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddUpdateScreen(
                  isUpdate: true,
                  notes: notes?[index],
                ),
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 5.0,
                  spreadRadius: 3.0,
                )
              ],
            ),
            child: buildContent(notes, index),
          ),
        );
      },
    );
  }

  Widget buildContent(List<Notes?>? notes, int index) {
    num diffAmount = 0.00;
    if (notes != null && notes[index] != null) {
      if (notes[index]!.actualAmount != null &&
          notes[index]!.calculatedAmount != null)
        diffAmount = notes[index]!.actualAmount! -
            notes[index]!.calculatedAmount!.toDouble();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildRichText("Date: ", "${notes?[index]?.date}"),
        SizedBox(height: 20),
        buildRichText("Company Name: ", "${notes?[index]?.companyName}"),
        SizedBox(height: 20),
        buildRichText("Sales/Purchase: ", "${notes?[index]?.salePurchase}"),
        SizedBox(height: 20),
        buildRichText("Quantity: ", "${notes?[index]?.quantity}"),
        SizedBox(height: 20),
        buildRichText("Rate: ", "${notes?[index]?.rate}"),
        SizedBox(height: 20),
        buildRichText(
            "Calculated Amount: ", "${notes?[index]?.calculatedAmount}"),
        SizedBox(height: 20),
        buildRichText("Actual Amount: ", notes?[index]?.actualAmount != 0.00 ? "${notes?[index]?.actualAmount}" : '-'),
        SizedBox(height: 20),
        buildRichText("Difference in Amount: ", "$diffAmount"),
      ],
    );
  }

  RichText buildRichText(String? key, String? value) {
    return RichText(
      textAlign: TextAlign.left,
      text: TextSpan(
        text: "$key",
        style: TextStyle(
          color: Colors.black,
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: "$value",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.normal),
          )
        ],
      ),
    );
  }
}
