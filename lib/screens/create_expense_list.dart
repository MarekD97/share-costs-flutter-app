import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:share_costs/models/expense_list.dart';
import 'package:share_costs/models/user.dart';

class CreateExpenseListPage extends StatefulWidget {
  const CreateExpenseListPage({Key? key}) : super(key: key);

  @override
  State<CreateExpenseListPage> createState() => _CreateExpenseListPageState();
}

class _CreateExpenseListPageState extends State<CreateExpenseListPage> {
  List<User> expenseOwners = [];
  final _ownerController = TextEditingController();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  void _addOwnerToList() {
    int newId = expenseOwners.length;
    if(_ownerController.text.isNotEmpty) {
      setState(() {
        expenseOwners.add(User(newId, _ownerController.text));
        _ownerController.clear();
      });
    }
  }

  void _createExpenseList() {
    ExpenseList expenseList = ExpenseList(Random().nextInt(10), _nameController.text, [], expenseOwners);
    final costs = FirebaseFirestore.instance.collection('costs');
    costs.add(expenseList.toMap()).whenComplete(() => print('${_nameController.text} created'));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Expense List'),
      ),
      body: Column(
        children: [
          Container(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Enter Expenses List Name:',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              )),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(16)),
            child: TextField(
              style: const TextStyle(fontSize: 20.0),
              decoration: const InputDecoration.collapsed(hintText: 'Name'),
              controller: _nameController,
            ),
          ),
          Container(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Description:',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              )),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(16)),
            child: TextField(
              style: const TextStyle(fontSize: 20.0),
              decoration: const InputDecoration.collapsed(hintText: 'Description'),
              minLines: 3,
              maxLines: 5,
              controller: _descriptionController,
            ),
          ),
          Container(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Add Owners:',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              )),
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 8.0),
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(16)),
                  child: TextField(
                    style: const TextStyle(fontSize: 20.0),
                    decoration:
                        const InputDecoration.collapsed(hintText: 'Owner'),
                    controller: _ownerController,
                    onSubmitted: (value) {
                       _addOwnerToList();
                    },
                  ),
                ),
              ),
              Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 8.0),
                  child: ElevatedButton(
                      onPressed: _addOwnerToList, child: const Icon(Icons.add)))
            ],
          ),
          Expanded(
            child: ListView.builder(
                itemExtent: 40.0,
                itemCount: expenseOwners.length,
                itemBuilder: (context, index) => Dismissible(
                  key: Key(expenseOwners[index].id.toString()),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction) {
                    setState(() {
                      expenseOwners.removeAt(index);
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                          key: Key(expenseOwners[index].id.toString()),
                          title: Text(expenseOwners[index].name),
                        ),
                  ),
                )),
          ),
          Row(
            children: [
              Expanded(child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(onPressed: _createExpenseList, child: const Text('Create')),
              )),
            ],
          )
        ],
      ),
    );
  }
}
