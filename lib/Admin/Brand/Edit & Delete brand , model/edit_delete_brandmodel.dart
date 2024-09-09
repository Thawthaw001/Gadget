// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:thaw/Admin/Brand/Edit%20&%20Delete%20brand%20,%20model/edit_modelscreen.dart';

// class EditDeleteBrandModel extends StatefulWidget {
//   const EditDeleteBrandModel({super.key});

//   @override
//   State<EditDeleteBrandModel> createState() => _EditDeleteBrandModelState();
// }

// class _EditDeleteBrandModelState extends State<EditDeleteBrandModel> {
//   String selectedCategoryId = '';
//   String selectedBrandId = '';
//   String selectedModelId = '';

//   List<DocumentSnapshot> categories = [];
//   List<DocumentSnapshot> brands = [];
//   List<DocumentSnapshot> models = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchCategories();
//   }

//   Future<void> fetchCategories() async {
//     try {
//       final QuerySnapshot result =
//           await FirebaseFirestore.instance.collection('categories').get();
//       setState(() {
//         categories = result.docs;
//         if (categories.isNotEmpty) {
//           selectedCategoryId = categories.first.id;
//           fetchBrands(selectedCategoryId);
//         } else {
//           print('No categories found');
//         }
//       });
//     } catch (e) {
//       print('Error fetching categories: $e');
//     }
//   }

//   Future<void> fetchBrands(String categoryId) async {
//     try {
//       final QuerySnapshot result = await FirebaseFirestore.instance
//           .collection('categories')
//           .doc(categoryId)
//           .collection('brands')
//           .get();
//       setState(() {
//         brands = result.docs;
//         if (brands.isNotEmpty) {
//           selectedBrandId = brands.first.id;
//           fetchModels(selectedCategoryId, selectedBrandId);
//         } else {
//           print('No brands found for category $categoryId');
//         }
//       });
//     } catch (e) {
//       print('Error fetching brands: $e');
//     }
//   }

//   Future<void> fetchModels(String categoryId, String brandId) async {
//     try {
//       final QuerySnapshot result = await FirebaseFirestore.instance
//           .collection('categories')
//           .doc(categoryId)
//           .collection('brands')
//           .doc(brandId)
//           .collection('models')
//           .get();
//       setState(() {
//         models = result.docs;
//         if (models.isNotEmpty) {
//           selectedModelId = models.first.id;
//         } else {
//           print('No models found for brand $brandId');
//         }
//       });
//     } catch (e) {
//       print('Error fetching models: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Edit & Delete Brand and Model'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             DropdownButton<String>(
//               hint: const Text('Select Category'),
//               value: selectedCategoryId.isEmpty ? null : selectedCategoryId,
//               items: categories.map((category) {
//                 return DropdownMenuItem<String>(
//                   value: category.id,
//                   child: Text(category['name']),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   selectedCategoryId = value!;
//                   selectedBrandId = '';
//                   selectedModelId = '';
//                   brands.clear();
//                   models.clear();
//                   fetchBrands(selectedCategoryId);
//                 });
//               },
//             ),
//             DropdownButton<String>(
//               hint: const Text('Select Brand'),
//               value: selectedBrandId.isEmpty ? null : selectedBrandId,
//               items: brands.map((brand) {
//                 return DropdownMenuItem<String>(
//                   value: brand.id,
//                   child: Text(brand['name']),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   selectedBrandId = value!;
//                   selectedModelId = '';
//                   models.clear();
//                   fetchModels(selectedCategoryId, selectedBrandId);
//                 });
//               },
//             ),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: models.length,
//                 itemBuilder: (context, index) {
//                   var model = models[index];
//                   return Card(
//                     margin: const EdgeInsets.symmetric(vertical: 10),
//                     child: ListTile(
//                       leading: model['imageUrl'] != null &&
//                               model['imageUrl'].isNotEmpty
//                           ? Image.network(
//                               model['imageUrl'],
//                               width: 50,
//                               height: 50,
//                             )
//                           : const Icon(Icons.image_not_supported),
//                       title: Text(model['name']),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('${model['price']} Kyats'),
//                           Text('Specs: ${model['specs']}'),
//                         ],
//                       ),
//                       trailing: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           IconButton(
//                             icon: const Icon(Icons.edit, color: Colors.blue),
//                             onPressed: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => EditModelScreen(
//                                     categoryId: selectedCategoryId,
//                                     brandId: selectedBrandId,
//                                     modelId: model.id,
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                           IconButton(
//                             icon: const Icon(Icons.delete, color: Colors.red),
//                             onPressed: () {
//                               deleteModel(selectedCategoryId, selectedBrandId,
//                                   model.id);
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> deleteModel(
//       String categoryId, String brandId, String modelId) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('categories')
//           .doc(categoryId)
//           .collection('brands')
//           .doc(brandId)
//           .collection('models')
//           .doc(modelId)
//           .delete();
//       fetchModels(categoryId, brandId);
//     } catch (e) {
//       print('Error deleting model: $e');
//     }
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:thaw/Admin/Brand/Edit%20&%20Delete%20brand%20,%20model/edit_modelscreen.dart';

class EditDeleteBrandModel extends StatefulWidget {
  const EditDeleteBrandModel({super.key});

  @override
  State<EditDeleteBrandModel> createState() => _EditDeleteBrandModelState();
}

class _EditDeleteBrandModelState extends State<EditDeleteBrandModel> {
  String selectedCategoryId = '';
  String selectedBrandId = '';
  String selectedModelId = '';

  List<DocumentSnapshot> categories = [];
  List<DocumentSnapshot> brands = [];
  List<DocumentSnapshot> models = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final QuerySnapshot result =
          await FirebaseFirestore.instance.collection('categories').get();
      setState(() {
        categories = result.docs;
        if (categories.isNotEmpty) {
          selectedCategoryId = categories.first.id;
          fetchBrands(selectedCategoryId);
        } else {
          print('No categories found');
        }
      });
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  Future<void> fetchBrands(String categoryId) async {
    try {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('categories')
          .doc(categoryId)
          .collection('brands')
          .get();
      setState(() {
        brands = result.docs;
        if (brands.isNotEmpty) {
          selectedBrandId = brands.first.id;
          fetchModels(selectedCategoryId, selectedBrandId);
        } else {
          print('No brands found for category $categoryId');
        }
      });
    } catch (e) {
      print('Error fetching brands: $e');
    }
  }

  Future<void> fetchModels(String categoryId, String brandId) async {
    try {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('categories')
          .doc(categoryId)
          .collection('brands')
          .doc(brandId)
          .collection('models')
          .get();
      setState(() {
        models = result.docs;
        if (models.isNotEmpty) {
          selectedModelId = models.first.id;
        } else {
          print('No models found for brand $brandId');
        }
      });
    } catch (e) {
      print('Error fetching models: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit & Delete Brand and Model'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<String>(
              hint: const Text('Select Category'),
              value: selectedCategoryId.isEmpty ? null : selectedCategoryId,
              items: categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category.id,
                  child: Text(category['name']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategoryId = value!;
                  selectedBrandId = '';
                  selectedModelId = '';
                  brands.clear();
                  models.clear();
                  fetchBrands(selectedCategoryId);
                });
              },
            ),
            DropdownButton<String>(
              hint: const Text('Select Brand'),
              value: selectedBrandId.isEmpty ? null : selectedBrandId,
              items: brands.map((brand) {
                return DropdownMenuItem<String>(
                  value: brand.id,
                  child: Text(brand['name']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedBrandId = value!;
                  selectedModelId = '';
                  models.clear();
                  fetchModels(selectedCategoryId, selectedBrandId);
                });
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: models.length,
                itemBuilder: (context, index) {
                  var model = models[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            model['name'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${model['price']} Kyats',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Specs:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              model['specs'] ?? 'No specs available',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Carousel Slider for images
                          CarouselSlider(
                            options: CarouselOptions(
                              height: 150,
                              autoPlay: true,
                              aspectRatio: 16 / 9,
                              viewportFraction: 1.0,
                              enableInfiniteScroll: true,
                            ),
                            items: (model['imageUrls'] as List<dynamic>?)
                                    ?.map<Widget>((imageUrl) {
                                  return Builder(
                                    builder: (BuildContext context) {
                                      return Image.network(
                                        imageUrl,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  );
                                }).toList() ??
                                [
                                  const Center(
                                    child: Text('No images available'),
                                  ),
                                ],
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditModelScreen(
                                    categoryId: selectedCategoryId,
                                    brandId: selectedBrandId,
                                    modelId: model.id,
                                  ),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              deleteModel(selectedCategoryId, selectedBrandId,
                                  model.id);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> deleteModel(
      String categoryId, String brandId, String modelId) async {
    try {
      await FirebaseFirestore.instance
          .collection('categories')
          .doc(categoryId)
          .collection('brands')
          .doc(brandId)
          .collection('models')
          .doc(modelId)
          .delete();
      fetchModels(categoryId, brandId);
    } catch (e) {
      print('Error deleting model: $e');
    }
  }
}
