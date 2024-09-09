import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DiscountedProductsPage extends StatefulWidget {
  @override
  _DiscountedProductsPageState createState() => _DiscountedProductsPageState();
}

class _DiscountedProductsPageState extends State<DiscountedProductsPage> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _addDiscountedProduct() {
    final String name = _productNameController.text;
    final String discount = _discountController.text;
    final String image = _imageController.text;

    if (name.isNotEmpty && discount.isNotEmpty && image.isNotEmpty) {
      _firestore.collection('discountedProducts').add({
        'name': name,
        'discount': discount,
        'image': image,
      });

      _productNameController.clear();
      _discountController.clear();
      _imageController.clear();
    }
  }

  void _deleteProduct(String productId) {
    _firestore.collection('discountedProducts').doc(productId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Discounted Products'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _productNameController,
              decoration: InputDecoration(labelText: 'Product Name'),
            ),
            TextField(
              controller: _discountController,
              decoration: InputDecoration(labelText: 'Discount %'),
            ),
            TextField(
              controller: _imageController,
              decoration: InputDecoration(labelText: 'Image URL'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addDiscountedProduct,
              child: Text('Add Discounted Product'),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('discountedProducts').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final products = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      final productId = product.id;
                      final productName = product['name'];
                      final discount = product['discount'];
                      final image = product['image'];

                      return Card(
                        child: ListTile(
                          leading: Image.network(image),
                          title: Text(productName),
                          subtitle: Text('Discount: $discount%'),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _deleteProduct(productId),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
