import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_trackerr/user_model.dart';
import 'package:flutter/material.dart';

class editCollection extends StatefulWidget {
  final amountController = TextEditingController();
  final id;
  DateTime selectedDate = DateTime.now();


  editCollection({super.key, required String this.id, required String amount, required String date}){
    amountController.text = amount;
    selectedDate = DateTime.parse(date);;
  }
  @override
  State<editCollection> createState() => _editCollectionState();

}

class _editCollectionState extends State<editCollection> {

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var dateController = TextEditingController();

  void createRecordInFirebase() async {
    final docUser = firestore.collection('collection').doc();

    final user = User(
        id: docUser.id,
        Amount: widget.amountController.text,
        Date: widget.selectedDate.toLocal().toString().split(' ')[0]
    );
    final jsonUser = user.toJson();
    await docUser.set(jsonUser);

  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: widget.selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != widget.selectedDate) {
      setState(() {
        widget.selectedDate = picked;
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
              controller: widget.amountController,
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
                          "${widget.selectedDate.toLocal()}".split(' ')[0]),),
                    const Icon(Icons.calendar_month),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30,),
            ElevatedButton(onPressed: (){
              final docUser = FirebaseFirestore.instance
                  .collection("collection").doc(widget.id);
              docUser.update({
                'Amount': widget.amountController.text,
                'Date' : "${widget.selectedDate.toLocal()}".split(' ')[0]
              });
              Navigator.pop(context, 'Submit');
            }, child: const Text("Submit"))

          ],
        ),
      ),
    );
  }
}
