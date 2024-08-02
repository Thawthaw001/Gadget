import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thaw/Pages/payment.dart';
import 'package:thaw/Widget/bottom_navbar.dart';
import 'package:thaw/Widget/model_provider.dart';

class BasketPage extends StatefulWidget {
  const BasketPage({super.key});

  @override
  BasketPageState createState() => BasketPageState();
}

class BasketPageState extends State<BasketPage> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;

    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/orderhistory');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        title: const Text('Basket'),
        backgroundColor: Colors.lightBlueAccent,
      ),
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
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Consumer<ModelProvider>(
            builder: (context, modelProvider, child) {
              final total = modelProvider.basket.fold<double>(
                0.0,
                (sum, item) => sum + item['price'] * item['quantity'],
              );
              return Container(
                padding: const EdgeInsets.all(10.0),
                decoration: const BoxDecoration(
                  color: Colors.white38,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple,
                      blurRadius: 4.0,
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'SUBTOTAL: ${total.toStringAsFixed(0)} Ks',
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: "English"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PaymentPage(basket: modelProvider.basket),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 15.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                      ),
                      child: const Text(
                        'Buy Now!',
                        style: TextStyle(
                            fontSize: 15.0,
                            fontFamily: "English",
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          AnimatedBottomNavBar(
            selectedIndex: _selectedIndex,
            onItemTapped: _onItemTapped,
          ),
        ],
      ),
    );
  }
}
