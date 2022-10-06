import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_trackerr/user_model.dart';
import 'package:expense_trackerr/widgets/AppBar.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'editExpense.dart';
import 'newExpense.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({Key? key}) : super(key: key);

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {


  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var amountController = TextEditingController();
  var dateController = TextEditingController();
  int totalSum = 0;

  DataRow buildUserTable(User user) {
    return DataRow(cells: [
      DataCell(
        Container(
            child: Text(user.Amount)),),
      DataCell(Text(user.Date)),
      DataCell(Column(
        children: [
          Expanded(child: IconButton(
              onPressed: () {
                Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: EditAndAddExpense(id: user.id, amount: user.Amount, date: user.Date,isEdit: true,)));

                // Navigator.push(
                //     context,
                //     MaterialPageRoute(builder: (context) => EditAndAddExpense(id: user.id, amount: user.Amount, date: user.Date,isEdit: true,)));
              },
              icon: const Icon(Icons.edit))),
          Expanded(child: IconButton(
              onPressed: () async {
                final docUser = FirebaseFirestore.instance.collection(
                    "expenses").doc(user.id);
                docUser.delete();
              }, icon: const Icon(Icons.delete))),

        ],
      ),)
    ]);
  }


  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: EditAndAddExpense()));


          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (context) => EditAndAddExpense(),
          //   ),
          // );
        },
        child: const Icon(Icons.add),
      ),
      appBar: PreferredSize(preferredSize: const Size.fromHeight(55),
          child: CustomAppBar(name: "Expenses",leadingIcon: false,)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<List<User>>(
              stream: getDataFromFirebase(),
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  final users = snapshot.data!;
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    width: width,
                    child: DataTable(
                      dataRowHeight: 70,
                      columnSpacing: 0,
                      horizontalMargin: 0,

                      columns: <DataColumn>[
                        DataColumn(label: SizedBox(
                            width: width * .4,
                            child: const Text('Amount'))),
                        DataColumn(label: SizedBox(
                            width: width * .4,
                            child: const Text('Date'))),
                        DataColumn(label: SizedBox(
                            width: width * .2,
                            child: const Text(''))),
                      ],
                      rows: users.map(buildUserTable).toList(),
                    ),
                  );
                  // return ListView(
                  //   shrinkWrap: true,
                  //   physics: const NeverScrollableScrollPhysics(),
                  //   children: users.map(buildUserTable).toList(),
                  // );
                } else {
                  return const Center(child: Text("Loading"),);
                }
              }
              ),
            ),
            StreamBuilder<List<User>>(
              stream: getDataFromFirebase(),
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  final users = snapshot.data!;
                  totalSum = 0;
                  for (int i = 0; i < users.length; i++) {
                    totalSum = int.parse(users[i].Amount) + totalSum;
                  }
                  return Card(
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          color: Colors.amberAccent,
                        ),
                        borderRadius: BorderRadius.circular(20.0), //<-- SEE HERE
                      ),
                      elevation: 4,
                      child: Padding(
                          padding: const EdgeInsets.all(30),
                          child: Text("Total Sum is $totalSum", style: const TextStyle(fontSize: 26))));
                } else {
                  return const Center(child: Text("Loading"),);
                }
              }
              ),
            ),

          ],
        ),
      ),

    );
  }

  void createRecordInFirebase() async {
    final docUser = firestore.collection('expenses').doc();
    final user = User(
        id: docUser.id,
        Amount: amountController.text,
        Date: dateController.text
    );
    final jsonUser = user.toJson();
    await docUser.set(jsonUser);


  }



  Stream<List<User>> getDataFromFirebase() =>
      FirebaseFirestore.instance.collection('expenses').snapshots().map((
          event) =>
          event.docs.map((doc) => User.fromJson(doc.data())).toList());

  // _createRows(List<User> users) {
  //   DataRow(cells: [
  //     DataCell(Text(),
  //     DataCell(Text(documentSnapshot.data()['Votes'].toString())),
  //     DataCell(Text(documentSnapshot.data()['Rapper name'].toString())),
  //   ]);
  // }



}

