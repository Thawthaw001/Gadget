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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.pink[50],
      appBar: AppBar(
        title: const Text('Basket'),
        backgroundColor: isDarkMode ? Colors.grey[850] : Colors.lightBlueAccent,
      ),
      body: Consumer<ModelProvider>(
        builder: (context, modelProvider, child) {
          final basket = modelProvider.basket;

          if (basket.isEmpty) {
            return const Center(
              child: Text(
                'Your basket is empty!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }

          return ListView.builder(
            itemCount: basket.length,
            itemBuilder: (context, index) {
              final item = basket[index];

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Card(
                  color: isDarkMode ? Colors.grey[800] : Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['name'] ?? 'No name available',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    fontFamily: "English"),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Price: ${item['price']} Ks',
                                style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.grey[300]
                                        : Colors.black),
                              ),
                              Text(
                                'Color: ${item['color']}',
                                style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.grey[300]
                                        : Colors.black),
                              ),
                              Text(
                                'Storage: ${item['storage']}',
                                style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.grey[300]
                                        : Colors.black),
                              ),
                              Text(
                                'Quantity: ${item['quantity']}',
                                style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.grey[300]
                                        : Colors.black),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete,
                              color: isDarkMode ? Colors.red[300] : Colors.red),
                          onPressed: () {
                            modelProvider.removeFromCart(item['modelId'],
                                item['color'], item['storage']);
                            setState(() {});
                          },
                        ),
                      ],
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
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[900] : Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 4.0,
                    ),
                  ],
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'SUBTOTAL: ${total.toStringAsFixed(0)} Ks',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: "English",
                          color: isDarkMode ? Colors.white : Colors.black),
                    ),
                    ElevatedButton(
                      onPressed: modelProvider.basket.isEmpty
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PaymentPage(basket: modelProvider.basket),
                                ),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isDarkMode ? Colors.teal[300] : Colors.blue,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 15.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                      ),
                      child: const Text(
                        'Buy Now!',
                        style: TextStyle(
                            fontSize: 16.0,
                            fontFamily: "English",
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
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
