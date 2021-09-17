import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CommentScreen extends StatefulWidget {
  final QuerySnapshot<Map<String , dynamic>> snapshot;
  const CommentScreen(this.snapshot);

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Expanded(
        child: ListView.builder(
            itemCount: widget.snapshot.docs.length,
            itemBuilder: (context,index)=>Text(widget.snapshot.docs[index].data()['userComment'])),
      ),
    );
  }
}
