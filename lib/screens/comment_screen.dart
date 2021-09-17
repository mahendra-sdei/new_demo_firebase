import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:new_demo_firebase/utils/colors.dart';

class CommentScreen extends StatefulWidget {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> snapshot;
  const CommentScreen(this.snapshot);

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        backgroundColor: Colors.white,
        title: Text(
          'Comments',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
          itemCount: widget.snapshot.length,
          itemBuilder: (context, index) => Row(
                children: [
                  FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      future: FirebaseFirestore.instance.collection('user').doc(widget.snapshot[index].data()['userId']).get(),
                      builder: (context, snap) {
                        if (!snap.hasData) {
                          return const SizedBox.shrink();
                        } else {
                          if (snap.data.data() == null) {
                            return const SizedBox.shrink();
                          } else {
                            return Expanded(
                              child: ListTile(
                                leading: Container(
                                  height: 35,
                                  width: 35,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(width: 1, color: bgGrey),
                                      image: DecorationImage(
                                          image: NetworkImage('https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg'),
                                          fit: BoxFit.cover)),
                                ),
                                title: Row(
                                  children: [
                                    Text(snap.data.data()['fName'] + snap.data.data()['lName'],style: TextStyle(fontWeight: FontWeight.bold),),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(widget.snapshot[index].data()['userComment']),
                                  ],
                                ),
                                subtitle: Row(
                                  children: [
                                    Text('21m',style: TextStyle(fontSize: 12),),
                                    SizedBox(width: 10),
                                    Text('12 likes',style: TextStyle(fontSize: 12)),
                                    SizedBox(width: 10,),
                                    Text('Reply',style: TextStyle(fontSize: 12)),
                                  ],
                                ),
                                trailing: IconButton(onPressed: (){}, icon: Icon(FontAwesome.heart_o,size: 13,)),
                              ),
                            );

                          }
                        }
                      }),

                ],
              )),
    );
  }
}
