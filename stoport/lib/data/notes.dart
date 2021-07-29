
class Notes {
  String? id;
  String? companyName;
  String? date;
  String? salePurchase;
  num? quantity;
  num? rate;
  num? calculatedAmount;
  num? actualAmount;
  Notes({
    this.id,
    this.companyName,
    this.date,
    this.salePurchase,
    this.quantity,
    this.rate,
    this.calculatedAmount=0.00,
    this.actualAmount = 0.00,
  });

  Notes copyWith({
    String? companyName,
    String? date,
    String? salePurchase,
    num? quantity,
    num? rate,
    num? calculatedAmount,
    num? actualAmount,
  }) {
    return Notes(
      companyName: companyName ?? this.companyName,
      date: date ?? this.date,
      salePurchase: salePurchase ?? this.salePurchase,
      quantity: quantity ?? this.quantity,
      rate: rate ?? this.rate,
      calculatedAmount: calculatedAmount ?? this.calculatedAmount,
      actualAmount: actualAmount ?? this.actualAmount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'companyName': companyName,
      'date': date,
      'salePurchase': salePurchase,
      'quantity': quantity,
      'rate': rate,
      'calculatedAmount': calculatedAmount,
      'actualAmount': actualAmount,
    };
  }

  factory Notes.fromMap(Map<String, dynamic> map) {
    return Notes(
      companyName: map['companyName'],
      date: map['date'],
      salePurchase: map['salePurchase'],
      quantity: num.parse(map['quantity'].toString()),
      rate: num.parse(map['rate'].toString()),
      calculatedAmount: num.parse(map['calculatedAmount'].toString()),
      actualAmount: num.parse(map['actualAmount'].toString()),
    );
  }

 
}
