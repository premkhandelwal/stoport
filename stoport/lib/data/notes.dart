import 'dart:convert';

class Notes {
  String? id;
  String? companyName;
  String? date;
  String? salePurchase;
  double? quantity;
  double? rate;
  double? amount;
  Notes({
    this.id,
    this.companyName,
    this.date,
    this.salePurchase,
    this.quantity,
    this.rate,
    this.amount,
  });

  Notes copyWith({
    String? companyName,
    String? date,
    String? salePurchase,
    double? quantity,
    double? rate,
    double? amount,
  }) {
    return Notes(
      companyName: companyName ?? this.companyName,
      date: date ?? this.date,
      salePurchase: salePurchase ?? this.salePurchase,
      quantity: quantity ?? this.quantity,
      rate: rate ?? this.rate,
      amount: amount ?? this.amount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'companyName': companyName,
      'date': date,
      'salePurchase': salePurchase,
      'quantity': quantity,
      'rate': rate,
      'amount': amount,
    };
  }

  factory Notes.fromMap(Map<String, dynamic> map) {
    return Notes(
      companyName: map['companyName'],
      date: map['date'],
      salePurchase: map['salePurchase'],
      quantity: double.parse(map['quantity'].toString()),
      rate: double.parse(map['rate'].toString()),
      amount: double.parse(map['amount'].toString()),
    );
  }

  String toJson() => json.encode(toMap());

  factory Notes.fromJson(String source) => Notes.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Notes(companyName: $companyName, date: $date, salePurchase: $salePurchase, quantity: $quantity, rate: $rate, amount: $amount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Notes &&
        other.companyName == companyName &&
        other.date == date &&
        other.salePurchase == salePurchase &&
        other.quantity == quantity &&
        other.rate == rate &&
        other.amount == amount;
  }

  @override
  int get hashCode {
    return companyName.hashCode ^
        date.hashCode ^
        salePurchase.hashCode ^
        quantity.hashCode ^
        rate.hashCode ^
        amount.hashCode;
  }
}
