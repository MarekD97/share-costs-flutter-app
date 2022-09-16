import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_costs/models/expense_list.dart';

class ShowExpenseListPage extends StatefulWidget {
  const ShowExpenseListPage({Key? key, required this.expenseId})
      : super(key: key);

  final String expenseId;

  @override
  State<ShowExpenseListPage> createState() => _ShowExpenseListPageState();
}

class _ShowExpenseListPageState extends State<ShowExpenseListPage> {
  ExpenseList? expenseList;

  String appBarTitle = "";

  Future _getExpenseTitle(String expenseId) async {
    final document =
        FirebaseFirestore.instance.collection('costs').doc(expenseId);
    String title = await document.get().then((value) => value['name']);
    if (mounted) {
      setState(() {
        appBarTitle = title;
      });
    }
  }

  void _createNewExpense(String expenseId) {
    Navigator.pushNamed(context, '/create-expense', arguments: expenseId);
  }

  @override
  Widget build(BuildContext context) {
    _getExpenseTitle(widget.expenseId);
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
          bottom: const TabBar(tabs: [
            Tab(
              child: Text("Expenses"),
            ),
            Tab(
              child: Text("Balance"),
            ),
          ]),
        ),
        body: TabBarView(
          children: [
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('costs')
                    .doc(widget.expenseId)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data!['expenses'].length,
                        itemBuilder: (context, index) {
                          final expense = snapshot.data!['expenses'][index];
                          String name = expense['name'];
                          String value = expense['value'].toString();
                          String paidBy = expense['paidBy'].toString();
                          String createdAt = (expense['created'] as Timestamp).toDate().toString();

                          return Card(
                            child: ListTile(
                                key: Key(index.toString()),
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(name),
                                    Text('${value},00 zł'),
                                  ],
                                ),
                                subtitle: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Paid by ${paidBy}'),
                                    Text(createdAt),
                                  ],
                                )),
                          );
                        });
                  }
                  return const Center(child: CircularProgressIndicator());
                }),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('costs')
                  .doc(widget.expenseId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List owners = snapshot.data!['owners'];
                  List expenses = snapshot.data!['expenses'];
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: owners.length,
                          itemBuilder: (context, index) => ListTile(
                              title: Row(
                            children: [
                              Text(owners[index]),
                              Spacer(),
                              Text(expenses
                                  .where(
                                    (element) => element['paidBy'] == index,
                                  )
                                  .map((element) {
                                    return element['value'];
                                  })
                                  .fold(
                                      0,
                                      (previousValue, element) =>
                                          previousValue + element as int)
                                  .toString())
                            ],
                          )),
                        ),
                      )
                    ],
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _createNewExpense(widget.expenseId);
          },
          tooltip: "Add new expense",
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
