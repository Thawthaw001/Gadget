import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thaw/Pages/payment.dart';
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
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
          title: const Text('Basket'), backgroundColor: Colors.lightBlueAccent),
      body: Consumer<ModelProvider>(
        builder: (context, modelProvider, child) {
          final basket = modelProvider.basket;
          return ListView.builder(
            itemCount: basket.length,
            itemBuilder: (context, index) {
              final item = basket[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Card(
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(item['imageUrl'],
                          width: 50, height: 50, fit: BoxFit.cover),
                    ),
                    title: Text(
                      item['name'],
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          fontFamily: "English"),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Price: ${item['price']} Ks',
                            style: const TextStyle(color: Colors.white)),
                        Text('Color: ${item['color']}',
                            style: const TextStyle(color: Colors.white)),
                        Text('Storage: ${item['storage']}',
                            style: const TextStyle(color: Colors.white)),
                        Text('Quantity: ${item['quantity']}',
                            style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        modelProvider.removeFromCart(
                            item['modelId'], item['color'], item['storage']);
                        setState(() {});
                      },
                    ),
                  ),
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
              color: Colors.white38,
              boxShadow: [
                BoxShadow(
                  color: Colors.lightBlueAccent,
                  blurRadius: 4.0,
                ),
              ],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.0),
                topRight: Radius.circular(24.0),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'SUBTOTAL: $total Ks',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: "English"),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PaymentPage(), // Navigate to PaymentPage
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50.0, vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                  ),
                  child: const Text(
                    'Buy Now!',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: "English",
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
