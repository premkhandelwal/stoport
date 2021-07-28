import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stoport/data/notes.dart';
import 'package:stoport/logic/bloc/notes_bloc.dart';

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
  TextEditingController amount = new TextEditingController();
  TextEditingController date = new TextEditingController();
  String? salePurchaseVal = "Select Value";

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
          quantity.text = widget.notes!.quantity!.toStringAsFixed(2);
        }
        if (widget.notes!.rate != null) {
          rate.text = widget.notes!.rate!.toStringAsFixed(2);
        }
        if (widget.notes!.amount != null) {
          amount.text = widget.notes!.amount!.toStringAsFixed(2);
        }
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
        title: Text(
          "Add New Note",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              DateTimeField(
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
                  date.text = DateFormat("dd/MM/yyyy").format(selectedDate!);
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
                style: TextStyle(fontSize: 20, color: Colors.black),
                controller: companyName,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Company Name",
                    labelStyle: TextStyle(fontSize: 20, color: Colors.black54)),
              ),
              SizedBox(
                height: 20,
              ),
              DropdownButtonFormField(
                decoration: InputDecoration(border: OutlineInputBorder()),
                hint: salePurchaseVal == null
                    ? Text('Dropdown')
                    : Text(
                        salePurchaseVal!,
                        style: TextStyle(color: Colors.black, fontSize: 20),
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
                style: TextStyle(fontSize: 20, color: Colors.black),
                onChanged: (val) {
                  quantity.text = val;
                  amount.text = (double.parse(val) * double.parse(rate.text))
                      .toStringAsFixed(2);
                },
                controller: quantity,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Quantity",
                    labelStyle: TextStyle(fontSize: 20, color: Colors.black54)),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                style: TextStyle(fontSize: 20, color: Colors.black),
                controller: rate,
                onChanged: (val) {
                  rate.text = val;
                  amount.text =
                      (double.parse(val) * double.parse(quantity.text))
                          .toStringAsFixed(2);
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Rate",
                    labelStyle: TextStyle(fontSize: 20, color: Colors.black54)),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                style: TextStyle(fontSize: 20, color: Colors.black),
                controller: amount,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Amount",
                    labelStyle: TextStyle(fontSize: 20, color: Colors.black54)),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<NotesBloc>().add(
                        widget.isUpdate
                            ? UpdateNote(
                                Notes(
                                    id: widget.notes!.id,
                                    companyName: companyName.text,
                                    amount: double.parse(amount.text),
                                    date: date.text,
                                    quantity: double.parse(quantity.text),
                                    rate: double.parse(rate.text),
                                    salePurchase: salePurchaseVal),
                              )
                            : AddNote(
                                Notes(
                                    companyName: companyName.text,
                                    amount: double.parse(amount.text),
                                    date: date.text,
                                    quantity: double.parse(quantity.text),
                                    rate: double.parse(rate.text),
                                    salePurchase: salePurchaseVal),
                              ),
                      );
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
      ),
    );
  }
}
