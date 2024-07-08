// ignore_for_file: avoid_print, camel_case_types

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:thaw/Admin/Model/category_model.dart';

class CatService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static final CollectionReference categoryCollection =
      FirebaseFirestore.instance.collection('categories');

  static Future<void> addCategory(FourCategory category) async {
    await categoryCollection.add({
      'name': category.name,
      'imageUrl': category.imageUrl,
    });
  }

  static Future<String> uploadImageToStorage(
      File imageFile, String fileName) async {
    try {
      final Reference storageRef =
          _storage.ref().child('images').child(fileName);

      // Upload the file to Firebase Storage
      await storageRef.putFile(imageFile);

      // Get the download URL of the uploaded file
      String imageUrl = await storageRef.getDownloadURL();

      // Return the download URL
      return imageUrl;
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
      rethrow; // Throw the error again to handle it where the method is called
    }
  }
}
