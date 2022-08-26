import 'dart:html' as html;
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:contactapp/model/contact_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vcard_maintained/vcard_maintained.dart';

final databaseProvider = StateProvider((ref) => DataBaseHelper());
final activeContact = StateProvider<ContactInfo?>((ref) => null);

class DataBaseHelper {
  DataBaseHelper() {
    // _firebaseFunctions.useFunctionsEmulator('localhost', 5001);
    // _storage.useStorageEmulator('localhost', 9199);
    // _firestore.useFirestoreEmulator('localhost', 8080);
    // _auth.useAuthEmulator('localhost', 9099);
  }
  final FirebaseFunctions _firebaseFunctions = FirebaseFunctions.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  createAuth(String id, String email, String password) async {
    try {
      var user = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await createContact(user.user!.uid, id, email);
      return {'status': 'success'};
    } on FirebaseAuthException catch (error) {
      return {'status': 'failed', 'reason': error.message};
    }
  }

  createContact(String accId, String id, String email) async {
    await _firestore.doc('Contacts/$accId').set({'id': id, 'email': email});
  }

  loadUser(String userID) async {
    var dets = await _firestore.doc('Contacts/$userID').get();
    if (dets.exists) {
      print(dets.data());
      return ContactInfo.fromMap(dets.data()!);
    } else {
      return null;
    }
  }

  Future<ContactInfo> saveContact(
      ContactInfo newContact, String id, String? url, String firebaseID) async {
    newContact.id = id;
    newContact.pictureURL = url;
    await _firestore.doc('Contacts/$firebaseID').update(newContact.toMap());
    return newContact;
  }

  saveProfile(
      String id, Uint8List imageData, String name, String extension) async {
    final picRef = _storage.ref('Profiles/$id').child(name);

    var result = await picRef.putData(
        imageData, SettableMetadata(contentType: 'image/$extension'));
    var url = await result.ref.getDownloadURL();
    return url;
  }

  createVCard(ContactInfo createdContact) {
    var card = VCard();
    card.birthday = createdContact.birthday;
    card.email = createdContact.emails != null
        ? [...createdContact.emails!.map((e) => e.value).toList()]
        : null;
    card.cellPhone = createdContact.phones != null
        ? [...createdContact.phones!.map((e) => e.value).toList()]
        : null;
    card.firstName = createdContact.firstName;
    card.lastName = createdContact.lastName;
    card.organization = createdContact.organizationName;
    card.jobTitle = createdContact.positionTitle;
    card.namePrefix = createdContact.title ?? '';
    card.note = createdContact.notes;
    card.photo.attachFromUrl(createdContact.pictureURL, createdContact.picType);
    return card;
  }

  downloadVCard(VCard card) async {
    // await card.saveToFile('./contact.vcf');
    var cardString = card.getFormattedString().codeUnits;
    var blob = html.Blob(cardString, 'text/plain', 'native');
    // final content = base64Encode(rawData);
    final anchor = html.AnchorElement(
        href: html.Url.createObjectUrlFromBlob(blob).toString())
      ..setAttribute("download", "contact.vcf")
      ..click();
  }

  Future<ContactInfo?> retrieveCardDetails({required String cardId}) async {
    var dets = await _firestore
        .collection('Contacts')
        .where('id', isEqualTo: cardId)
        .limit(1)
        .get();
    if (dets.docs.isNotEmpty) {
      return ContactInfo.fromMap(dets.docs[0].data());
    }
    return null;
  }

  login({required String email, required String password}) async {
    try {
      var credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return {'status': 'success', 'reason': credential};
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case 'invalid-email':
          return {'status': 'error', 'reason': error.message};
        case 'user-disabled':
          return {'status': 'error', 'reason': error.message};
        case 'user-not-found':
          return {'status': 'error', 'reason': error.message};
        case 'wrong-password':
          return {'status': 'error', 'reason': error.message};
        default:
          return 'unknown error';
      }
    }
  }
}
