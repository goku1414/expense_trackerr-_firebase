import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_trackerr/collection/editCollection.dart';
import 'package:expense_trackerr/user_model.dart';
import 'package:expense_trackerr/widgets/AppBar.dart';
import 'package:flutter/material.dart';

import '../expense/editExpense.dart';
import 'newCollection.dart';

class CollectionPage extends StatefulWidget {
  const CollectionPage({Key? key}) : super(key: key);

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {


  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var amountController = TextEditingController();
  var dateController = TextEditingController();

  DateTime selectedDate = DateTime.now();

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
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => editCollection(id: user.id, amount: user.Amount, date: user.Date,)));
              },
              icon: const Icon(Icons.edit))),
          Expanded(child: IconButton(
              onPressed: () async {
                final docUser = FirebaseFirestore.instance.collection(
                    "collection").doc(user.id);
                docUser.delete();
              }, icon: const Icon(Icons.delete))),

        ],
      ),)
    ]);
  }

  Widget buildUser(User user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Card(
        elevation: 10,
        child: ListTile(
          title: Text(user.Amount, style: const TextStyle(fontSize: 20),),
          subtitle: Text(user.Date),
          trailing: Column(
            children: [
              Expanded(child: IconButton(
                  onPressed: () {

                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => editCollection(id: user.id, amount: user.Amount,date: user.Date,)));

                  },
                  icon: const Icon(Icons.edit))),
              Expanded(child: IconButton(
                  onPressed: () async {
                    final docUser = FirebaseFirestore.instance.collection(
                        "collection").doc(user.id);
                    docUser.delete();
                  }, icon: const Icon(Icons.delete))),

            ],
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const NewCollection(),
            ),
          );

        },
        child: const Icon(Icons.add),
      ),
      appBar: PreferredSize(preferredSize: const Size.fromHeight(55),
          child: CustomAppBar(name: "collection",leadingIcon: false,)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<List<User>>(
              stream: getDataFromFirebase(),
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  final users = snapshot.data!;
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    width: width,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 13),
                      child: DataTable(
                        dataRowHeight: 70,
                        columnSpacing: 0,
                        horizontalMargin: 0,

                        columns: <DataColumn>[
                          DataColumn(label: Container(
                              width: width * .4,
                              child: Text('Amount'))),
                          DataColumn(label: Container(
                              width: width * .4,
                              child: Text('Date'))),
                          DataColumn(label: Container(
                              width: width * .2,
                              child: Text(''))),
                        ],
                        rows: users.map(buildUserTable).toList(),
                      ),
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
                        side: BorderSide(
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
    final docUser = firestore.collection('collection').doc();
    final user = User(
        id: docUser.id,
        Amount: amountController.text,
        Date: dateController.text
    );
    final jsonUser = user.toJson();
    await docUser.set(jsonUser);


  }



  Stream<List<User>> getDataFromFirebase() =>
      FirebaseFirestore.instance.collection('collection').snapshots().map((
          event) =>
          event.docs.map((doc) => User.fromJson(doc.data())).toList());
}

