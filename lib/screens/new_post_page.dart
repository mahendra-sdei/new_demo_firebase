import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class NewPostPage extends StatefulWidget {
  const NewPostPage({Key key}) : super(key: key);

  @override
  _NewPostPageState createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {

  XFile img;
  Future<File> imageFile;
  ImagePicker imagePicker;

  pickImageFromGallery() async {
    final XFile pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    img = XFile(pickedFile.path);
    setState(() {
      img;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          pickImageFromGallery();
        },
        child: IconButton(icon: Icon(Icons.add),color: Colors.white,),
      ),
      body: Column(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            child: img!=null? Image.file(File(img.path),fit: BoxFit.fill,):SizedBox(),
          ),
        TextFormField()
         // Image.file(image);
        ],
      )
    );
  }
}
