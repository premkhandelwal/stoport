import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stoport/data/notes.dart';

class DataProviderFirebase {
  final notesCollection = FirebaseFirestore.instance.collection('notes');

  Future<bool> addNewNotes(Notes notes) async {
    bool responseVal = false;
    await notesCollection.add({
      'companyName': "${notes.companyName}",
      'quantity': notes.quantity,
      'rate': notes.rate,
      'calculatedAmount': notes.calculatedAmount,
      'actualAmount': notes.actualAmount,
      'date': "${notes.date}",
      'salePurchase': notes.salePurchase,
    });
    responseVal = true;
    return responseVal;
  }

  Future<bool> updateExistingNotes(Notes notes) async {
    // FirebaseFirestore.instance.collection('collection_Name').doc('doc_Name').collection('collection_Name').doc(code.documentId).update({'redeem': true});
    bool responseVal = false;
    notesCollection.doc("${notes.id}").update({
      'companyName': "${notes.companyName}",
      'quantity': notes.quantity,
      'rate': notes.rate,
      'date': "${notes.date}",
      'salePurchase': notes.salePurchase,
      'calculatedAmount': notes.calculatedAmount,
      'actualAmount': notes.actualAmount,
    });
    responseVal = true;
    return responseVal;
  }

  Future<List<Notes?>> fetchAllNotes() async {
    print("Hello");
    List<Notes?> listNotes = [];

    await notesCollection
        .get(GetOptions(source: Source.server))
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        listNotes.add(
          Notes(
            companyName: result.data()["companyName"],
            id: result.id,
            calculatedAmount:
                num.parse(result.data()["calculatedAmount"].toString()),
            actualAmount: num.parse(result.data()["actualAmount"].toString()),
            date: result.data()["date"],
            quantity: num.parse(result.data()["quantity"].toString()),
            rate: num.parse(result.data()["rate"].toString()),
            salePurchase: result.data()["salePurchase"],
          ),
        );
      });
    });
    return listNotes;
  }

 

  Future<void> deleteNotes(List<String?> notes) async {
    for (var i = 0; i < notes.length; i++) {
      return notesCollection
          .doc("${notes[i]}")
          .update({
            'isDeleted': true,
          })
          .then((value) => print("User Deleted"))
          .catchError((error) => print("Failed to delete user: $error"));
    }
  }
}
