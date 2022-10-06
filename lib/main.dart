

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_trackerr/collection/collections.dart';
import 'package:expense_trackerr/user_model.dart';
import 'package:expense_trackerr/widgets/AppBar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'NetAccount.dart';
import 'expense/expenses.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pie_chart/pie_chart.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const ProviderScope(child:  MaterialApp(home: MyApp())));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: "https://img.freepik.com/free-vector/hand-painted-watercolor-pastel-sky-background_23-2148902771.jpg?w=2000",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: PreferredSize(preferredSize: const Size.fromHeight(55),
            child: CustomAppBar(name: "Balance Sheet")),
            body: const MyBody(),
          ),
        ],
      ),
    );
  }
}

class MyBody extends StatefulWidget {
  const MyBody({Key? key}) : super(key: key);


  @override
  State<MyBody> createState() => _MyBodyState();
}

class _MyBodyState extends State<MyBody> {
  int expense = 0;
  int collection = 0;
  var net = 0;

  late int showingTooltip;

  @override
  void initState() {
    showingTooltip = -1;
    super.initState();
  }
  Map<String, double> dataMap = {
    "Flutter": 5,
    "React": 3,
    "Xamarin": 2,
    "Ionic": 2,
  };

  BarChartGroupData generateGroupData(int x, int y) {
    return BarChartGroupData(
      x: x,
      showingTooltipIndicators: showingTooltip == x ? [0] : [],
      barRods: [
        BarChartRodData(toY: y.toDouble()),
      ],
    );
  }


  FirebaseFirestore firestore = FirebaseFirestore.instance;



  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [

        const SizedBox(height: 25,),
            StreamBuilder<List<User>>(
              stream: getExpenseFromFirebase(),
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  final users = snapshot.data!;
                  expense = 0;
                  for (int i = 0; i < users.length; i++) {
                    expense = int.parse(users[i].Amount) + expense;
                  }
                  return StreamBuilder<List<User>>(
                    stream: getCollectionFromFirebase(),
                    builder: ((context, snapshot) {
                      if (snapshot.hasData) {
                        final users = snapshot.data!;
                        collection = 0;
                        for (int i = 0; i < users.length; i++) {
                          collection = int.parse(users[i].Amount) + collection;
                        }
                        net = collection - expense;
                        return Column(
                          children: [
                            const SizedBox(height: 30,),
                            AspectRatio(
                              aspectRatio: 2,
                              child: BarChart(
                                BarChartData(
                                  barGroups: [
                                    generateGroupData(1, collection),
                                    generateGroupData(2, expense),
                                  ],
                                  barTouchData: BarTouchData(
                                      enabled: true,
                                      handleBuiltInTouches: false,
                                      touchCallback: (event, response) {
                                        if (response != null && response.spot != null && event is FlTapUpEvent) {
                                          setState(() {
                                            final x = response.spot!.touchedBarGroup.x;
                                            final isShowing = showingTooltip == x;
                                            if (isShowing) {
                                              showingTooltip = -1;
                                            } else {
                                              showingTooltip = x;
                                            }
                                          });
                                        }
                                      },
                                      mouseCursorResolver: (event, response) {
                                        return response == null || response.spot == null
                                            ? MouseCursor.defer
                                            : SystemMouseCursors.click;
                                      }
                                  ),
                                ),
                              ),
                            ),
                            PieChart(
                              colorList: [Colors.lightBlueAccent,Colors.black12],
                              dataMap: {
                                "Collection": collection.toDouble(),
                                "Expenses": expense.toDouble(),
                              },
                              animationDuration: const Duration(milliseconds: 800),
                              chartRadius: MediaQuery.of(context).size.width / 3.2,
                              initialAngleInDegree: 0,
                              chartType: ChartType.ring,
                              ringStrokeWidth: 32,
                              centerText: "Net Collection",
                              legendOptions: const LegendOptions(
                                showLegendsInRow: false,
                                legendPosition: LegendPosition.right,
                                showLegends: true,
                                legendTextStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              chartValuesOptions: const ChartValuesOptions(
                                showChartValueBackground: true,
                                showChartValues: true,
                                showChartValuesInPercentage: false,
                                showChartValuesOutside: false,
                                decimalPlaces: 1,
                              ),
                              // gradientList: ---To add gradient colors---
                              // emptyColorGradient: ---Empty Color gradient---
                            )

                          ],
                        );
                      } else {
                        return const Center(child: Text("Loading"),);
                      }
                    }
                    ),
                  );
                } else {
                  return const Center(child: Text("Loading"),);
                }
              }
              ),
            ),
            SizedBox(height: 30,),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: CollectionPage()));
                    },
                    child: Card(
                      color: Color(0xff7DCEAE),
                      elevation: 10,
                      child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: StreamBuilder<List<User>>(
                            stream: getCollectionFromFirebase(),
                            builder: ((context, snapshot) {
                              if (snapshot.hasData) {
                                final users = snapshot.data!;
                                collection = 0;
                                for (int i = 0; i < users.length; i++) {
                                  collection = int.parse(users[i].Amount) + collection;
                                }
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Text("Total Collection: ", style: GoogleFonts.oswald(fontSize: 22),),
                                    const SizedBox(height: 7,),
                                    Text("$collection", style: GoogleFonts.oswald(fontSize: 20,color: Colors.amber[400])),
                                    CachedNetworkImage(imageUrl: "https://img.freepik.com/premium-vector/money-bag_16734-108.jpg?w=360"),
                                  ],
                                );
                              } else {
                                return const Center(child: Text("Loading",),);
                              }
                            }
                            ),
                          )),
                    ),
                  ),
                ),
                SizedBox(width: 10,),
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: ExpensePage()));

                    },
                    child: Card(
                      color: Colors.white,
                      elevation: 10,
                      child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: StreamBuilder<List<User>>(
                            stream: getExpenseFromFirebase(),
                            builder: ((context, snapshot) {
                              if (snapshot.hasData) {
                                final users = snapshot.data!;
                                expense = 0;
                                for (int i = 0; i < users.length; i++) {
                                  expense = int.parse(users[i].Amount) + expense;
                                }
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Text("Total Expense: ", style: GoogleFonts.oswald(fontSize: 22)),
                                    const SizedBox(height: 7,),
                                    Text("$expense", style: GoogleFonts.oswald(fontSize: 20, color: Colors.amber[400])),
                                    SizedBox(height: 8,),
                                    CachedNetworkImage(imageUrl: "https://img.freepik.com/premium-vector/crypto-currency-bitcoin-technology-concept_108855-3711.jpg?w=200"),


                                  ],
                                );
                              } else {
                                return const Center(child: Text("Loading"),);
                              }
                            }
                            ),
                          ),),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30,),
               Card(
                 color: Colors.amber,
              elevation: 10,
              child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: StreamBuilder<List<User>>(
                    stream: getExpenseFromFirebase(),
                    builder: ((context, snapshot) {
                      if (snapshot.hasData) {
                        final users = snapshot.data!;
                        expense = 0;
                        for (int i = 0; i < users.length; i++) {
                          expense = int.parse(users[i].Amount) + expense;
                        }
                        return StreamBuilder<List<User>>(
                          stream: getCollectionFromFirebase(),
                          builder: ((context, snapshot) {
                            if (snapshot.hasData) {
                              final users = snapshot.data!;
                              collection = 0;
                              for (int i = 0; i < users.length; i++) {
                                collection = int.parse(users[i].Amount) + collection;
                              }
                              net = collection - expense;
                              return GestureDetector(
                                onTap: (){
                                  Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: NetAccount()));

                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(builder: (context) => const NetAccount()),
                                  // );
                                },
                                child: Row(
                                  children: [

                                    Expanded(child: CachedNetworkImage(imageUrl:"https://cdn-icons-png.flaticon.com/512/3846/3846601.png")),
                                    SizedBox(width: 20,),
                                    Row(
                                      children: [
                                        net>0? Text("Total Profit:  $net", style: GoogleFonts.oswald(fontSize: 22,color: Colors.green),):Text("Total Loss:  $net", style: GoogleFonts.oswald(fontSize: 22,color: Colors.red),),
                                      ],
                                    ),

                                  ],
                                ),
                              );
                            } else {
                              return const Center(child: Text("Loading"),);
                            }
                          }
                          ),
                        );
                      } else {
                        return const Center(child: Text("Loading"),);
                      }
                    }
                    ),
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }


  Stream<List<User>> getExpenseFromFirebase() =>
      FirebaseFirestore.instance.collection('expenses').snapshots().map((
          event) =>
          event.docs.map((doc) => User.fromJson(doc.data())).toList());

  Stream<List<User>> getCollectionFromFirebase() =>
      FirebaseFirestore.instance.collection('collection').snapshots().map((
          event) =>
          event.docs.map((doc) => User.fromJson(doc.data())).toList());

}
class _PieData {
  _PieData(this.xData, this.yData, [this.text]);
  final String xData;
  final num yData;
  final String? text;
}