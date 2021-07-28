import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stoport/logic/bloc/cubit/internet_cubit.dart';
import 'package:stoport/logic/bloc/notes_bloc.dart';
import 'package:stoport/screens/addUpdate_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>  {
  TextEditingController searchController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, istrue) {
            return [
              SliverAppBar(
                stretch: true,
                floating: true,
                snap: true,
                title: _topActions(context),
                automaticallyImplyLeading: false,
                centerTitle: true,
                titleSpacing: 0,
                backgroundColor: Colors.transparent,
                elevation: 10,
                expandedHeight: 10,
              )
            ];
          },
          body: BlocBuilder<NotesBloc, NotesState>(builder: (context, state) {
            final internetState = context.watch<InternetCubit>().state;
            if (internetState is InternetConnected) {
              if (state is NotesLoadSuccess) {
                return state.notes != null && state.notes!.length != 0
                    ? buildGridView(state)
                    : Center(
                        child: Text(
                          "No Items Present",
                          style: TextStyle(fontSize: 25),
                        ),
                      );
              } else if (state is NotesInitial) {
                context.read<NotesBloc>().add(FetchAllNotes());
                return Center(child: CircularProgressIndicator());
              } else {
                return Text(
                  "No Items Present",
                  style: TextStyle(fontSize: 100),
                );
              }
            } else {
              return Center(child: Text("No Internet",
                  style: TextStyle(fontSize: 100),
              
              ));
            }
          }),
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
                    onChanged: (val){
                     
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
                /*   InkWell(
              child: Icon(_gridView ? Icons.view_list : Icons.view_module),
              onTap: () => setState(() {
                _gridView = !_gridView; // switch between list and grid style
              }),
            ),
            const SizedBox(width: 18),
            _buildAvatar(context),
            const SizedBox(width: 10), */
              ],
            ),
          ),
        ),
      );

  Widget buildGridView(NotesLoadSuccess state) {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.all(10),
      scrollDirection: Axis.vertical,
      itemCount: state.notes!.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 1.8,
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
                  notes: state.notes?[index],
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
            child: buildContent(state, index),
          ),
        );
      },
    );
  }

  Widget buildContent(NotesLoadSuccess state, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildRichText("Date: ", "${state.notes?[index]?.date}"),
        SizedBox(height: 20),
        buildRichText("Company Name: ", "${state.notes?[index]?.companyName}"),
        SizedBox(height: 20),
        buildRichText(
            "Sales/Purchase: ", "${state.notes?[index]?.salePurchase}"),
        SizedBox(height: 20),
        buildRichText("Quantity: ", "${state.notes?[index]?.quantity}"),
        SizedBox(height: 20),
        buildRichText("Rate: ", "${state.notes?[index]?.rate}"),
        SizedBox(height: 20),
        buildRichText("Amount: ", "${state.notes?[index]?.amount}"),
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
