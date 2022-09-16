import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:share_costs/screens/create_expense.dart';
import 'package:share_costs/screens/create_expense_list.dart';
import 'package:share_costs/screens/show_expense_list.dart';
import 'firebase_options.dart';

import 'screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ShareCostsApp());
}

class ShareCostsApp extends StatelessWidget {
  const ShareCostsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Share Costs App',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(title: 'Share Costs App'),
        '/create-expense-list': (context) => const CreateExpenseListPage(),
        '/expense-list': (context) => ShowExpenseListPage(expenseId: ModalRoute.of(context)!.settings.arguments as String),
        '/create-expense': (context) => CreateExpensePage(expenseId: ModalRoute.of(context)!.settings.arguments as String)
    },
    );
  }
}
