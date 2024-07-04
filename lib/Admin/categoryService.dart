// ignore_for_file: avoid_print, camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thaw/Admin/Model/categoryModel.dart';

class CatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> addCategory(FourCategory category) async {
    try {
      await _firestore.collection('categories').add(category.toMap());
      print('Category added succcess');
    } catch (e) {
      print('Errror adding category $e');
    }
  }
}
