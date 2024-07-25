import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderDisplayScreen extends StatelessWidget {
  const OrderDisplayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Orders'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('orders').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              var order = orders[index];
              var orderData = order.data() as Map<String, dynamic>;

              var items = orderData['items'] as List<dynamic>? ?? [];

              return Card(
                margin: const EdgeInsets.all(10.0),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order ID: ${order.id}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text('User: ${orderData['userName'] ?? 'N/A'}'),
                      Text('Email: ${orderData['userEmail'] ?? 'N/A'}'),
                      Text('Total Amount: ${orderData['totalAmount'] ?? 'N/A'}'),
                      Text('Order Date: ${orderData['orderDate'].toDate().toString()}'),
                      Text('State: ${orderData['state'] ?? 'N/A'}'),
                      Text('Township: ${orderData['township'] ?? 'N/A'}'),
                      Text('Street Address: ${orderData['streetAddress'] ?? 'N/A'}'),
                      Text('Phone: ${orderData['phone'] ?? 'N/A'}'),
                      Text('Email: ${orderData['email'] ?? 'N/A'}'),
                      Text('Additional Info: ${orderData['additionalInfo'] ?? 'N/A'}'),
                      const SizedBox(height: 8),
                      const Text('Items:', style: TextStyle(fontWeight: FontWeight.bold)),
                      ...items.map((item) {
                        var itemData = item as Map<String, dynamic>;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (itemData['imageUrl'] != null)
                                Image.network(itemData['imageUrl'], height: 50, width: 50),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Name: ${itemData['itemName'] ?? 'N/A'}'),
                                    Text('Quantity: ${itemData['quantity'] ?? 'N/A'}'),
                                    Text('Price: \$${itemData['price'] ?? 'N/A'}'),
                                    Text('Subtotal: \$${itemData['subtotal'] ?? 'N/A'}'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () async {
                            try {
                              await FirebaseFirestore.instance
                                  .collection('orders')
                                  .doc(order.id)
                                  .delete();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Order deleted successfully!'),
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Failed to delete order: $e'),
                                ),
                              );
                            }
                          },
                          child:  Text('Delete Order'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
