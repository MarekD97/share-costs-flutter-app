import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class CreateExpensePage extends StatefulWidget {
  const CreateExpensePage({Key? key, required this.expenseId}) : super(key: key);

  final String expenseId;

  @override
  State<CreateExpensePage> createState() => _CreateExpensePageState();
}

class _CreateExpensePageState extends State<CreateExpensePage> {

  final _nameController = TextEditingController();
  final _valueController = TextEditingController();
  final _dateController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime dateTime = DateTime.now();

  int _paidByIndex = 0;

  // Select for Date
  Future<DateTime> _selectDate(BuildContext context) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
      });
    }
    return selectedDate;
  }

// Select for Time
  Future<TimeOfDay> _selectTime(BuildContext context) async {
    final selected = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (selected != null && selected != selectedTime) {
      setState(() {
        selectedTime = selected;
      });
    }
    return selectedTime;
  }
  // select date time picker

  Future _selectDateTime(BuildContext context) async {
    final date = await _selectDate(context);

    final time = await _selectTime(context);

    setState(() {
      dateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  void _addExpense() {

    final document = FirebaseFirestore.instance.collection('costs').doc(widget.expenseId);
    Map<String, dynamic> newExpense = {
      "name": _nameController.text,
      "value": int.parse(_valueController.text),
      "created": dateTime,
      "paidBy": _paidByIndex
    };

    document.update({
      "expenses": FieldValue.arrayUnion(List.filled(1, newExpense))
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Expense"),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            Container(
              margin:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(16)),
              child: TextField(
                style: const TextStyle(fontSize: 20.0),
                decoration: const InputDecoration.collapsed(hintText: 'Title'),
                controller: _nameController,
              ),
            ),
            Container(
              margin:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(16)),
              child: TextField(
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: const TextStyle(fontSize: 20.0),
                decoration: const InputDecoration.collapsed(hintText: 'Amount'),
                controller: _valueController,
              ),
            ),
            Container(
              margin:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              padding:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(16)),
              child: FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('costs')
                      .doc(widget.expenseId)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<DropdownMenuItem<int>> items = List.generate(
                          snapshot.data!['owners'].length,
                          (index) => DropdownMenuItem(
                                value: index,
                                child: Text(snapshot.data!['owners'][index]),
                              ));
                      if (items.isEmpty) {
                        return const Center(child: LinearProgressIndicator());
                      }
                      return DropdownButton(
                          items: items,
                          onChanged: (value) {
                            if (value == null) return;
                            setState(() {
                              _paidByIndex = value;
                            });
                          },
                          value: _paidByIndex,
                          isExpanded: true);
                    }
                    return const Center(child: CircularProgressIndicator());
                  }),
            ),
            Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(16)),
                child: TextField(
                  controller: _dateController,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.calendar_today),
                      labelText: "Enter Date and Time"),
                  readOnly: true,
                  onTap: () async {
                    _selectDateTime(context);
                    setState(() {
                      _dateController.text = dateTime.toString();
                    });
                  },
                )),
            Container(
              margin:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              child: ElevatedButton(
                child: const Text("Add Expense"),
                onPressed: _addExpense,
              ),
            )
          ])),
    );
  }
}
