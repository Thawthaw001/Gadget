// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thaw/Widget/model_provider.dart';

class BasketPage extends StatefulWidget {
  const BasketPage({super.key});

  @override
  _BasketPageState createState() => _BasketPageState();
}

class _BasketPageState extends State<BasketPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basket'),
      ),
      body: Consumer<ModelProvider>(
        builder: (context, modelProvider, child) {
          final basket = modelProvider.basket;
          return ListView.builder(
            itemCount: basket.length,
            itemBuilder: (context, index) {
              final item = basket[index];
              return ListTile(
                leading: Image.network(item['imageUrl']),
                title: Text(item['name']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Price: ${item['price']} Ks'),
                    Text('Color: ${item['color']}'),
                    Text('Storage: ${item['storage']}'),
                    Text('Quantity: ${item['quantity']}'),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    modelProvider.removeFromCart(
                        item['modelId'],item['color'],item['storage']);
                    setState(() {});
                  },
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Consumer<ModelProvider>(
        builder: (context, modelProvider, child) {
          final total = modelProvider.basket.fold<double>(
            0.0,
            (sum, item) => sum + item['price'] * item['quantity'],
          );
          return Container(
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 4.0,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: $total Ks',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle order logic here
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Order placed successfully!'),
                      ),
                    );
                  },
                  child: const Text('Order Now'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
