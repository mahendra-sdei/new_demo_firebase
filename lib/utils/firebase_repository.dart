import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_demo_firebase/utils/firebase_provider.dart';

class FirebaseRepository {
  FirebaseProvider firebaseProvider = FirebaseProvider();

  Future<void> addUserData({String firstName, String lastName,  String userName,  String email,  String password,  String mobileNo}) =>
      firebaseProvider.addUserData(firstName, lastName, userName, email, password, mobileNo);

  Future<QuerySnapshot> login({ String email,  String password}) => firebaseProvider.login(email, password);

  Future<QuerySnapshot<Map<String, dynamic>>> getVenue() => firebaseProvider.getVenue();

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> searchVenue({ String name}) => firebaseProvider.searchVenue(name);

  Future<QuerySnapshot<Map<String, dynamic>>> checkEmail({ String email}) => firebaseProvider.checkEmail(email);
}
