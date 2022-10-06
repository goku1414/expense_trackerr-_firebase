import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_trackerr/user_model.dart';
import 'package:expense_trackerr/widgets/AppBar.dart';
import 'package:flutter/material.dart';

class NetAccount extends StatefulWidget {
  const NetAccount({Key? key}) : super(key: key);

  @override
  State<NetAccount> createState() => _NetAccountState();
}

class _NetAccountState extends State<NetAccount> {

  CollectionReference expenses = FirebaseFirestore.instance.collection('expenses');
  CollectionReference collection = FirebaseFirestore.instance.collection('collection');


  DataRow buildUserTable(User user) {
    return DataRow(cells: [
      DataCell(
        Container(
            child: Text(user.Amount)),),
      DataCell(Text(user.Date))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: PreferredSize(preferredSize: const Size.fromHeight(55),
          child: CustomAppBar(name: "Net Account",leadingIcon: false,)),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            children: [
              DataTable(
                columns: const <DataColumn>[
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'S.No',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Date',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Expense',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Collection',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Net',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                ],
                rows: row_list,
              ),
              Container(
                height: 10,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.black12,width: 3.0),
                  ),
                ),
              ),
              SizedBox(height: 20,),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Text("Total"),
                  SizedBox(width: 90,),
                  Text("Total"),
                  SizedBox(width: 90,),

                ],
              ),
              SizedBox(height: 100,)
            ],
          ),
        ),
      ),
    );

  }

  List<DataRow> row_list = [
    const DataRow(
      cells: <DataCell>[
        DataCell(Text('1')),
        DataCell(Text('1/11/11')),
        DataCell(Text('200')),
        DataCell(Text('400')),
        DataCell(Text('200')),
      ],
    ),
    const DataRow(
      cells: <DataCell>[
        DataCell(Text('1')),
        DataCell(Text('1/11/11')),
        DataCell(Text('200')),
        DataCell(Text('400')),
        DataCell(Text('200')),
      ],
    ),
    const DataRow(
      cells: <DataCell>[
        DataCell(Text('1')),
        DataCell(Text('1/11/11')),
        DataCell(Text('200')),
        DataCell(Text('400')),
        DataCell(Text('200')),
      ],
    ),
    const DataRow(
      cells: <DataCell>[
        DataCell(Text('1')),
        DataCell(Text('1/11/11')),
        DataCell(Text('200')),
        DataCell(Text('400')),
        DataCell(Text('200')),
      ],
    ),
    const DataRow(
      cells: <DataCell>[
        DataCell(Text('1')),
        DataCell(Text('1/11/11')),
        DataCell(Text('200')),
        DataCell(Text('400')),
        DataCell(Text('200')),
      ],
    ),
    const DataRow(
      cells: <DataCell>[
        DataCell(Text('1')),
        DataCell(Text('1/11/11')),
        DataCell(Text('200')),
        DataCell(Text('400')),
        DataCell(Text('200')),
      ],
    ),
    const DataRow(
      cells: <DataCell>[
        DataCell(Text('1')),
        DataCell(Text('1/11/11')),
        DataCell(Text('200')),
        DataCell(Text('400')),
        DataCell(Text('200')),
      ],
    ),
    const DataRow(
      cells: <DataCell>[
        DataCell(Text('1')),
        DataCell(Text('1/11/11')),
        DataCell(Text('200')),
        DataCell(Text('400')),
        DataCell(Text('200')),
      ],
    ),
    const DataRow(
      cells: <DataCell>[
        DataCell(Text('1')),
        DataCell(Text('1/11/11')),
        DataCell(Text('200')),
        DataCell(Text('400')),
        DataCell(Text('200')),
      ],
    ),
    const DataRow(
      cells: <DataCell>[
        DataCell(Text('1')),
        DataCell(Text('1/11/11')),
        DataCell(Text('200')),
        DataCell(Text('400')),
        DataCell(Text('200')),
      ],
    ),
    const DataRow(
      cells: <DataCell>[
        DataCell(Text('1')),
        DataCell(Text('1/11/11')),
        DataCell(Text('200')),
        DataCell(Text('400')),
        DataCell(Text('200')),
      ],
    ),
    const DataRow(
      cells: <DataCell>[
        DataCell(Text('1')),
        DataCell(Text('1/11/11')),
        DataCell(Text('200')),
        DataCell(Text('400')),
        DataCell(Text('200')),
      ],
    ),
    const DataRow(
      cells: <DataCell>[
        DataCell(Text('1')),
        DataCell(Text('1/11/11')),
        DataCell(Text('200')),
        DataCell(Text('400')),
        DataCell(Text('200')),
      ],
    ),
    const DataRow(
      cells: <DataCell>[
        DataCell(Text('1')),
        DataCell(Text('1/11/11')),
        DataCell(Text('200')),
        DataCell(Text('400')),
        DataCell(Text('200')),
      ],
    ),



  ];

  Stream<List<User>> getExpenseFromFirebase() =>
      FirebaseFirestore.instance.collection('expenses').snapshots().map((
          event) =>
          event.docs.map((doc) => User.fromJson(doc.data())).toList());

  Stream<List<User>> getCollectionFromFirebase() =>
      FirebaseFirestore.instance.collection('collection').snapshots().map((
          event) =>
          event.docs.map((doc) => User.fromJson(doc.data())).toList());

}
