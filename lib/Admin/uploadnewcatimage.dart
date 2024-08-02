import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';

Future<String?> uploadImage(XFile imageFile) async {
  try {
    // 1. Get the file from the XFile
    final file = File(imageFile.path);

    // 2. Create a reference to the storage location
    final storageRef = firebase_storage.FirebaseStorage.instance.ref().child('category_images/${DateTime.now().millisecondsSinceEpoch}');

    // 3. Upload the file to Firebase Storage
    final uploadTask = storageRef.putFile(file);

    // 4. Wait for the upload to complete
    await uploadTask.whenComplete(() => null);

    // 5. Get the download URL
    final downloadUrl = await storageRef.getDownloadURL();

    return downloadUrl;
  } catch (e) {
    print('Error uploading image: $e');
    return null;
  }
}
