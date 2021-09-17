import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_demo_firebase/utils/firebase_provider.dart';

class FirebaseRepository {
  FirebaseProvider firebaseProvider = FirebaseProvider();

  Future<void> addUserData({String firstName, String lastName,  String userName,  String email,  String password,  String bio}) =>
      firebaseProvider.addUserData(firstName, lastName, userName, email, password, bio);

  Future<QuerySnapshot<Map<String, dynamic>>> login({ String email,  String password}) => firebaseProvider.login(email, password);

  Future<QuerySnapshot<Map<String, dynamic>>> checkEmail({ String email}) =>
      firebaseProvider.checkEmail(email);

  Future<String> uploadImageToStorage({ File file}) => firebaseProvider.uploadImageToStorage(file);
}
