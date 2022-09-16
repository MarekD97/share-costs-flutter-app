import 'user.dart';

class Expense {
  int id;
  String name;
  int value;
  DateTime created;
  User paidBy;
  List<User> owners;

  Expense(this.id, this.name, this.value, this.created, this.paidBy, this.owners);
}