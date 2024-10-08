import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:thaw/Widget/bottom_navbar.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  OrderHistoryPageState createState() => OrderHistoryPageState();
}

class OrderHistoryPageState extends State<OrderHistoryPage> {
  int _selectedIndex = 2;

  Future<void> deleteOrder(String orderId) async {
    await FirebaseFirestore.instance.collection('orders').doc(orderId).delete();
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index)
      return; // Do nothing if the selected index is the same
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/basket');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/orderhistory');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(
          child: Text('Please log in to see your order history'));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('userId', isEqualTo: user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No orders found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var order =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;
                String orderId = snapshot.data!.docs[index].id;

                String township = order['township'] ?? 'No township available';
                String streetAddress =
                    order['streetAddress'] ?? 'No address available';
                String phone = order['phone'] ?? 'No phone available';
                List<dynamic> items = order['items'] ?? [];
                double totalAmount = (order['totalAmount'] != null)
                    ? (order['totalAmount'] as num).toDouble()
                    : 0.0;
                DateTime orderDate = (order['orderDate'] != null)
                    ? (order['orderDate'] as Timestamp).toDate()
                    : DateTime.now();

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ExpansionTile(
                    title: Text('Order ID: $orderId'),
                    subtitle: Text(
                        'Total Amount: ${totalAmount.toStringAsFixed(0)} Ks'),
                    children: [
                      ListTile(
                        title: Text('Order Date: ${orderDate.toLocal()}'),
                        subtitle: Text(
                            'Address:   $township, $streetAddress\nPhone: $phone'),
                      ),
                      ...items.map((item) {
                        var itemName = item['name'] ?? 'No name available';
                        return ListTile(
                          title: Text(itemName),
                          subtitle: Text(
                              'Quantity: ${item['quantity'] ?? 'N/A'}\nPrice: ${(item['price'] != null) ? (item['price'] as num).toStringAsFixed(0) : 'N/A'} Ks'),
                        );
                      }).toList(),
                      TextButton.icon(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        label: const Text('Delete Order',
                            style: TextStyle(color: Colors.red)),
                        onPressed: () async {
                          await deleteOrder(orderId);
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Order deleted successfully!'),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: AnimatedBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
