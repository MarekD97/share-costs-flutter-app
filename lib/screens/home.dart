import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Stream<QuerySnapshot> _costsStream =
      FirebaseFirestore.instance.collection('costs').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder(
          stream: _costsStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: Dismissible(
                        key: Key(snapshot.data!.docs[index].id),
                        onDismissed: (direction) {
                          if (direction == DismissDirection.startToEnd) {
                            print('delete');
                          }
                        },
                        direction: DismissDirection.startToEnd,
                        child: ListTile(
                          title: Text(snapshot.data!.docs[index].get("name")),
                          subtitle: Text(
                              snapshot.data!.docs[index].get("description")),
                          trailing: IconButton(
                              icon: const Icon(Icons.more_vert),
                              onPressed: () {}),
                          onTap: () {
                            Navigator.pushNamed(context, '/expense-list',
                                arguments: snapshot.data!.docs[index].id);
                          },
                        ),
                      ),
                    );
                  });
            }
            return const Center(child: CircularProgressIndicator());
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/create-expense-list');
        },
        tooltip: 'Add Expenses',
        child: const Icon(Icons.add),
      ),
    );
  }
}
