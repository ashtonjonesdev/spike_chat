import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;


class FirebaseRepository {


  FirebaseRepository();
  
  static const String USERS_COLLECTION = 'users';

  static const String NAME_FIELD = 'name';
  static const String EMAIL_FIELD = 'email';

  void createUserInDatabaseWithEmail(auth.User firebaseUser) async {

    CollectionReference usersCollection = FirebaseFirestore.instance.collection(USERS_COLLECTION);

    usersCollection.doc(firebaseUser.uid).set({
      NAME_FIELD : firebaseUser.displayName,
      EMAIL_FIELD: firebaseUser.email,
    }).whenComplete(() => print('Created user in database with email. Name: ${firebaseUser.displayName} | Email: ${firebaseUser.email}'));


  }

  void createUserInDatabaseWithGoogleProvider(auth.User firebaseUser) async {

    CollectionReference usersCollection = FirebaseFirestore.instance.collection(USERS_COLLECTION);

    usersCollection.doc(firebaseUser.uid).set({
      NAME_FIELD : firebaseUser.displayName,
      EMAIL_FIELD: firebaseUser.email,
    }).whenComplete(() => print('Created user in database with Google Provider. Name: ${firebaseUser.displayName} | Email: ${firebaseUser.email}')).catchError((error) {print(error.toString());});


  }

  void createUserInDatabaseWithAppleProvider(auth.User firebaseUser) async {

    CollectionReference usersCollection = FirebaseFirestore.instance.collection(USERS_COLLECTION);

    usersCollection.doc(firebaseUser.uid).set({
      NAME_FIELD : firebaseUser.displayName,
      EMAIL_FIELD: firebaseUser.email,
    }).whenComplete(() => print('Created user in database with Apple Provider. Name: ${firebaseUser.displayName} | Email: ${firebaseUser.email}')).catchError((error) {print(error.toString());});

  }

}