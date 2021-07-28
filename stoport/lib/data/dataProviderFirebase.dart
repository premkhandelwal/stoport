import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stoport/data/notes.dart';

class DataProviderFirebase {
  final notesCollection = FirebaseFirestore.instance.collection('notes');

  Future<void> addNewNotes(Notes notes) async {
    notesCollection.add({
      'companyName': "${notes.companyName}",
      'quantity': notes.quantity,
      'rate': notes.rate,
      'amount': notes.amount,
      'date': "${notes.date}",
      'salePurchase': notes.salePurchase,
    });
    print("added");
  }

  Future<void> updateExistingNotes(Notes notes) async {
    // FirebaseFirestore.instance.collection('collection_Name').doc('doc_Name').collection('collection_Name').doc(code.documentId).update({'redeem': true});

    notesCollection.doc("${notes.id}").update({
      'companyName': "${notes.companyName}",
      'quantity': notes.quantity,
      'rate': notes.rate,
      'date': "${notes.date}",
      'salePurchase': notes.salePurchase,
    });
      print("updated");
  }

  Future<List<Notes?>> fetchAllNotes() async {
    print("Hello");
    List<Notes?> listNotes = [];

    var x = notesCollection.get(GetOptions(source: Source.server));

    // x.catchError((e) => throw SocketException("No Internet Connection"));
    x.then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        listNotes.add(
          Notes(
            companyName: result.data()["companyName"],
            id: result.id,
            amount: double.parse(result.data()["amount"].toString()),
            date: result.data()["date"],
            quantity: double.parse(result.data()["quantity"].toString()),
            rate: double.parse(result.data()["rate"].toString()),
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
