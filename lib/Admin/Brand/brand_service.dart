import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thaw/Admin/Brand/model/brand_class.dart';
import 'package:thaw/Admin/Brand/model/brand_model.dart';
 
class BrandService{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void>addBrand(String categoryId,Brand brand)async{
    final brandRef = _firestore.collection('categories').doc(categoryId).collection('brands').doc();
    await brandRef.set(brand.toMap());
  }
  Future<void>addModel(String categoryId,String brandId,Model model)async{
    final modelRef = _firestore.collection('categories').doc(categoryId).collection('brands').doc(brandId).collection('models').doc();
    await modelRef.set(model.toMap());
  }
}