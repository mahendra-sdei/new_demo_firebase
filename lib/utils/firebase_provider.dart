import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseProvider {
  FirebaseProvider._internal() {
    print("Instance created FirebaseProvider");
  }

  factory FirebaseProvider() => _singleton;
  static final FirebaseProvider _singleton = FirebaseProvider._internal();

  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<void> addUserData(String firstName, String lastName, String userName, String email, String password, String mobileNo) async {
    await _fireStore.collection('user').doc().set({
      'fName': firstName,
      'lName': lastName,
      'uName': userName,
      'email': email,
      'password': password,
      'mobile': mobileNo,
    });
  }

  Future<QuerySnapshot<Map<String, dynamic>>> checkEmail(String email) {
    return _fireStore.collection('user').where('email', isEqualTo: email).limit(1).get();
  }

  Future<QuerySnapshot> login(String email, String password) {
    return _fireStore.collection('user').where('email', isEqualTo: email).where('password', isEqualTo: password).limit(1).get();
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> searchVenue(String name) async {
    final data = await _fireStore
        .collection('venueList')
        .where('name', isGreaterThanOrEqualTo: name.toUpperCase())
        .where('name', isLessThanOrEqualTo: name.toLowerCase())
        .get();
    return data.docs;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getVenue() {
    return _fireStore.collection('venueList').get();
  }
}
