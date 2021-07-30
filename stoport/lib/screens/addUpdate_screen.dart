import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stoport/data/notes.dart';
import 'package:stoport/logic/bloc/notes_bloc.dart';
import 'package:stoport/screens/home_screen.dart';

class AddUpdateScreen extends StatefulWidget {
  final bool isUpdate;
  final Notes? notes;
  const AddUpdateScreen({Key? key, this.isUpdate = false, this.notes})
      : super(key: key);

  @override
  _AddUpdateScreenState createState() => _AddUpdateScreenState();
}

class _AddUpdateScreenState extends State<AddUpdateScreen> {
  TextEditingController companyName = new TextEditingController();
  TextEditingController quantity = new TextEditingController();
  TextEditingController rate = new TextEditingController();
  TextEditingController calculatedAmount = new TextEditingController();
  TextEditingController actualAmount = new TextEditingController();
  TextEditingController date = new TextEditingController();
  String? salePurchaseVal = "Sale/Purchase";

  @override
  void initState() {
    if (widget.isUpdate) {
      if (widget.notes != null) {
        if (widget.notes!.companyName != null) {
          companyName.text = widget.notes!.companyName!;
        }
        if (widget.notes!.date != null) {
          date.text = widget.notes!.date!;
        }
        if (widget.notes!.salePurchase != null) {
          salePurchaseVal = widget.notes!.salePurchase!;
        }
        if (widget.notes!.quantity != null) {
          quantity.text = widget.notes!.quantity!.toString();
        }
        if (widget.notes!.rate != null) {
          rate.text = widget.notes!.rate!.toString();
        }
        if (widget.notes!.calculatedAmount != null) {
          calculatedAmount.text = widget.notes!.calculatedAmount!.toString();
        }
        if (widget.notes!.actualAmount != null &&
            widget.notes!.actualAmount != 0.00) {
          actualAmount.text = widget.notes!.actualAmount!.toString();
        }
      }
    }
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
        title: Text(
          widget.isUpdate ? "Update Note" : "Add New Note",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Form(
        key: _formKey,
        child: BlocBuilder<NotesBloc, NotesState>(
          builder: (context, state) {
            if (state is NotesOperationSuccess) {
              SchedulerBinding.instance!.addPostFrameCallback((_) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Message"),
                    content: widget.isUpdate
                        ? Text(
                            "Updated Successfully",
                          )
                        : Text(
                            "Added Successfully",
                          ),
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(),
                              ),
                              (route) => false,
                            );
                          },
                          child: Text("Ok"))
                    ],
                  ),
                );
              });
            } else if (state is NotesOperationInProgress) {
              return Center(child: CircularProgressIndicator());
            }
            return Container(
              padding: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    DateTimeField(
                      validator: (val) {
                        if (val == null) {
                          return "This is a required field";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Select Date",
                        labelStyle: TextStyle(
                          color: Colors.black54,
                          fontSize: 20,
                        ),
                      ),
                      controller: date,
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      format: DateFormat(),
                      onChanged: (selectedDate) {
                        date.text =
                            DateFormat("dd/MM/yyyy").format(selectedDate!);
                      },
                      onShowPicker: (context, currentValue) async {
                        final time = showDatePicker(
                          firstDate: DateTime(1500),
                          lastDate: DateTime(3000),
                          initialDate: DateTime.now(),
                          helpText: "Select Date",
                          fieldLabelText: "Select Date",
                          context: context,
                        );

                        return time;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      validator: (val) {
                        print(val);
                        if (val == "") {
                          return "This is a required field";
                        }
                        return null;
                      },
                      style: TextStyle(fontSize: 20, color: Colors.black),
                      controller: companyName,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Company Name",
                          labelStyle:
                              TextStyle(fontSize: 20, color: Colors.black54)),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    DropdownButtonFormField(
                      validator: (val) {
                        if (val == null) {
                          return "This is a required field";
                        }
                        return null;
                      },
                      decoration: InputDecoration(border: OutlineInputBorder()),
                      hint: salePurchaseVal == null
                          ? Text('Dropdown')
                          : Text(
                              salePurchaseVal!,
                              style:
                                  TextStyle(fontSize: 20),
                            ),
                      isExpanded: true,
                      iconSize: 30.0,
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      items: ['Sale', 'Purchase'].map(
                        (val) {
                          return DropdownMenuItem<String>(
                            value: val,
                            child: Text(
                              val,
                              style: TextStyle(color: Colors.black),
                            ),
                          );
                        },
                      ).toList(),
                      onChanged: (String? val) {
                        setState(
                          () {
                            salePurchaseVal = val;
                          },
                        );
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      validator: (val) {
                        if (val == "") {
                          return "This is a required field";
                        }
                        return null;
                      },
                      style: TextStyle(fontSize: 20, color: Colors.black),
                      onChanged: (val) {
                        calculatedAmount.text =
                            (num.parse(val) * num.parse(rate.text)).toString();
                      },
                      controller: quantity,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Quantity",
                          labelStyle:
                              TextStyle(fontSize: 20, color: Colors.black54)),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      validator: (val) {
                         if (val == "") {
                          return "This is a required field";
                        }
                        return null;
                      },
                      style: TextStyle(fontSize: 20, color: Colors.black),
                      controller: rate,
                      onChanged: (val) {
                        calculatedAmount.text =
                            (num.parse(val) * num.parse(quantity.text))
                                .toString();
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Rate",
                          labelStyle:
                              TextStyle(fontSize: 20, color: Colors.black54)),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      readOnly: true,
                      style: TextStyle(fontSize: 20, color: Colors.black),
                      controller: calculatedAmount,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Calculated Amount",
                          labelStyle:
                              TextStyle(fontSize: 20, color: Colors.black54)),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      style: TextStyle(fontSize: 20, color: Colors.black),
                      controller: actualAmount,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Actual Amount",
                          labelStyle:
                              TextStyle(fontSize: 20, color: Colors.black54)),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) callOperation();
                      },
                      child: Text("Submit"),
                    )
                    /* DropdownButton<String>(
                        style: TextStyle(color: Colors.black),
                        
                        items: [
                          DropdownMenuItem(
                            child: Text("Sale"),
                            value: value,
                          ),
                          DropdownMenuItem(
                            child: Text("Purchase"),
                            value: value,
                          ),
                        ],
                        onChanged: (value) {
                          value = value;
                        },
                      ) */
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> callOperation() async {
    context.read<NotesBloc>().add(
          widget.isUpdate
              ? UpdateNote(
                  Notes(
                      id: widget.notes!.id,
                      companyName: companyName.text,
                      calculatedAmount: num.parse(calculatedAmount.text),
                      actualAmount: actualAmount.text != ""
                          ? num.parse(actualAmount.text)
                          : 0.00,
                      date: date.text,
                      quantity: num.parse(quantity.text),
                      rate: num.parse(rate.text),
                      salePurchase: salePurchaseVal),
                )
              : AddNote(
                  Notes(
                      companyName: companyName.text,
                      calculatedAmount: num.parse(calculatedAmount.text),
                      actualAmount: actualAmount.text != ""
                          ? num.parse(actualAmount.text)
                          : 0.00,
                      date: date.text,
                      quantity: num.parse(quantity.text),
                      rate: num.parse(rate.text),
                      salePurchase: salePurchaseVal),
                ),
        );
  }
}
