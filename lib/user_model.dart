class User{
  String id;
  final String Amount;
  final String Date;

  User({
    this.id = '',
    required this.Amount,
    required this.Date,
  });

  Map<String, dynamic> toJson() =>{
    'id': id,
    'Amount': Amount,
    'Date': Date,

  };

  static User fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    Amount: json['Amount'],
    Date: json['Date'],
  );
}

