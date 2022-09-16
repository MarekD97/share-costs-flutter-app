import 'expense.dart';
import 'user.dart';

class ExpenseList {
  int id;
  String name;
  String? description;
  List<Expense> items;
  List<User> owners;

  ExpenseList(this.id, this.name, this.items, this.owners);

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "owners": owners.map((owner) => owner.name).toList(),
      'expenses': items.map((expense) => <String, dynamic>{
        "name": expense.name,
        "value": expense.value,
        "created": expense.created,
        "owners": expense.owners.map((owner) => owner.name).toList(),
      }).toList(),
    };
  }
}
