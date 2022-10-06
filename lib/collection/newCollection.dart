import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_trackerr/user_model.dart';
import 'package:flutter/material.dart';

class NewCollection extends StatefulWidget {
  const NewCollection({super.key});




  @override
  State<NewCollection> createState() => _NewCollectionState();

}

class _NewCollectionState extends State<NewCollection> {

  var amountController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var dateController = TextEditingController();

  void createRecordInFirebase() async {
    final docUser = firestore.collection('collection').doc();

    final user = User(
        id: docUser.id,
        Amount: amountController.text,
        Date: selectedDate.toLocal().toString().split(' ')[0]
    );
    final jsonUser = user.toJson();
    await docUser.set(jsonUser);

  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add New Collection"),),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  labelText: "Enter Amount "
              ),
            ),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                width: double.infinity,
                decoration:
                BoxDecoration(border: Border.all(color: Colors.blueAccent)),
                child: Row(
                  children: [
                    Expanded(
                      child:  Text(
                          "${selectedDate.toLocal()}".split(' ')[0]),),
                    const Icon(Icons.calendar_month),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30,),
            ElevatedButton(onPressed: (){
              createRecordInFirebase();
              Navigator.pop(context, 'scs');
            }, child: const Text("Submit"))

          ],
        ),
      ),
    );
  }
}
