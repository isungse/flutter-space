import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MenuData extends StatefulWidget {
  @override
  _MenuDataState createState() => _MenuDataState();
}

class _MenuDataState extends State<MenuData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Lunch Menu'),
      ),
      body: _buildBody(context),
    );
  }
}

Widget _buildBody(BuildContext context) {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('baby').snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();

      return _buildList(context, snapshot.data.docs);
    },
  );
}

Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
  return ListView(
    padding: const EdgeInsets.only(top: 20.0),
    children: snapshot.map((data) => _buildListItem(context, data)).toList(),
  );
}

Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
  final record = Record.fromSnapshot(data);

  return Container(
    child: ExpansionTile(
      title: Text(
        'MON',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      key: ValueKey(
        record.name,
      ),
      children: [
        ListTile(
          title: Text(
            record.name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
        ),
        Divider(
          color: Colors.grey,
          thickness: 0.5,
          indent: 15,
          endIndent: 15,
        ),
        ListTile(
          title: Text(
            record.test,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 17, color: Colors.teal),
          ),
        ),
      ],
    ),
  );
}

class Record {
  final String name;
  final String test;

  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
//        assert(map['votes'] != null),
        assert(map['test'] != null),
        test = map['test'],
        name = map['name'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  @override
  String toString() => "Record<$name>";
}
