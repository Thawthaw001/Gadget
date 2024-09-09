// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:thaw/utils/formfield.dart';

// class OrderDisplayScreen extends StatefulWidget {
//   const OrderDisplayScreen({super.key});

//   @override
//   OrderDisplayScreenState createState() => OrderDisplayScreenState();
// }

// class OrderDisplayScreenState extends State<OrderDisplayScreen> {
//   String? selectedYear;
//   String? selectedMonth;

//   final List<String> years = ['2020', '2021', '2022', '2023', '2024'];
//   final List<String> months = [
//     'January',
//     'February',
//     'March',
//     'April',
//     'May',
//     'June',
//     'July',
//     'August',
//     'September',
//     'October',
//     'November',
//     'December'
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false, // Remove the back arrow
//         title: Text(
//           'View Orders',
//           style: formfieldStyle,
//         ),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 // Year Filter Dropdown
//                 Expanded(
//                   child: DropdownButton<String>(
//                     value: selectedYear,
//                     hint: const Text('Year'),
//                     isExpanded: true,
//                     onChanged: (value) {
//                       setState(() {
//                         selectedYear = value;
//                       });
//                     },
//                     items: years.map((year) {
//                       return DropdownMenuItem<String>(
//                         value: year,
//                         child: Text(year),
//                       );
//                     }).toList(),
//                   ),
//                 ),
//                 // Month Filter Dropdown
//                 Expanded(
//                   child: DropdownButton<String>(
//                     value: selectedMonth,
//                     hint: const Text('Month'),
//                     isExpanded: true,
//                     onChanged: (value) {
//                       setState(() {
//                         selectedMonth = value;
//                       });
//                     },
//                     items: months.map((month) {
//                       return DropdownMenuItem<String>(
//                         value: month,
//                         child: Text(month),
//                       );
//                     }).toList(),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('orders')
//                   .where('year', isEqualTo: selectedYear)
//                   .where('month', isEqualTo: selectedMonth)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return const Center(child: CircularProgressIndicator());
//                 }

//                 var orders = snapshot.data!.docs;

//                 return ListView.builder(
//                   itemCount: orders.length,
//                   itemBuilder: (context, index) {
//                     var order = orders[index];
//                     var orderData = order.data() as Map<String, dynamic>;

//                     var items = orderData['items'] as List<dynamic>? ?? [];
//                     double subtotal = 0.0;

//                     // Calculate subtotal
//                     for (var item in items) {
//                       subtotal +=
//                           (item['price'] as double) * (item['quantity'] as int);
//                     }

//                     // Function to delete an order
//                     void deleteOrder() async {
//                       await FirebaseFirestore.instance
//                           .collection('orders')
//                           .doc(order.id)
//                           .delete();
//                     }

//                     // Function to show the full image in a dialog
//                     void showFullImage(String imageUrl) {
//                       showDialog(
//                         context: context,
//                         builder: (context) => AlertDialog(
//                           contentPadding: EdgeInsets.zero,
//                           content: SizedBox(
//                             width: double.infinity,
//                             height: MediaQuery.of(context).size.height * 0.6,
//                             child: InteractiveViewer(
//                               child:
//                                   Image.network(imageUrl, fit: BoxFit.contain),
//                             ),
//                           ),
//                           actions: [
//                             TextButton(
//                               onPressed: () => Navigator.of(context).pop(),
//                               child: const Text('Close'),
//                             ),
//                           ],
//                         ),
//                       );
//                     }

//                     return Card(
//                       margin: const EdgeInsets.all(10.0),
//                       child: Padding(
//                         padding: const EdgeInsets.all(10.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text('Order ID: ${orderData['orderId']}'),
//                             const SizedBox(height: 8.0),
//                             Text('Name: ${orderData['userName']}'),
//                             const SizedBox(height: 8.0),
//                             Text('Email: ${orderData['userEmail']}'),
//                             const SizedBox(height: 8.0),
//                             Text(
//                                 'Township: ${order['township'] ?? 'Not Provided'}'),
//                             const SizedBox(height: 8.0),
//                             Text(
//                                 'Street Address: ${order['streetAddress'] ?? 'Not Provided'}'),
//                             const SizedBox(height: 8.0),
//                             Text('Phone: ${orderData['phone']}'),
//                             const SizedBox(height: 8.0),
//                             Text(
//                                 'Additional Info: ${orderData['additionalInfo']}'),
//                             const SizedBox(height: 8.0),
//                             Text(
//                                 'Delivery Method: ${orderData['deliveryMethod']}'),
//                             const SizedBox(height: 8.0),
//                             Text(
//                                 'Payment Method: ${orderData['paymentMethod']}'),
//                             const SizedBox(height: 8.0),
//                             if (orderData['transactionImageUrl'] != null)
//                               GestureDetector(
//                                 onTap: () => showFullImage(
//                                     orderData['transactionImageUrl']),
//                                 child: Container(
//                                   width: double.infinity,
//                                   height: 200,
//                                   decoration: BoxDecoration(
//                                     image: DecorationImage(
//                                       image: NetworkImage(
//                                           orderData['transactionImageUrl']),
//                                       fit: BoxFit.cover,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             const SizedBox(height: 10.0),
//                             const Text(
//                               'Items:',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             for (var item in items)
//                               ListTile(
//                                 title: Text(
//                                     '${item['name']} x ${item['quantity']}'),
//                                 subtitle: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                         'Price: K${item['price'].toStringAsFixed(2)}'),
//                                     if (item['color'] != null)
//                                       Text('Color: ${item['color']}'),
//                                     if (item['storage'] != null)
//                                       Text('Storage: ${item['storage']}'),
//                                   ],
//                                 ),
//                                 trailing: Text(
//                                     'Subtotal: K${(item['price'] * item['quantity']).toStringAsFixed(2)}'),
//                               ),
//                             const SizedBox(height: 8.0),
//                             Text('Total: K${subtotal.toStringAsFixed(2)}'),
//                             const SizedBox(height: 8.0),
//                             ElevatedButton(
//                               onPressed: deleteOrder,
//                               child: const Text('Delete Order'),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting

class OrderDisplayScreen extends StatefulWidget {
  const OrderDisplayScreen({super.key});

  @override
  OrderDisplayScreenState createState() => OrderDisplayScreenState();
}

class OrderDisplayScreenState extends State<OrderDisplayScreen> {
  String? selectedDay;

  // Days from 1 to 31
  final List<String> days =
      List.generate(31, (index) => (index + 1).toString());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove the back arrow
        title: Text(
          'View Orders',
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Day Filter Dropdown
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedDay,
                    hint: const Text('Select Day'),
                    isExpanded: true,
                    onChanged: (value) {
                      setState(() {
                        selectedDay = value;
                      });
                    },
                    items: days.map((day) {
                      return DropdownMenuItem<String>(
                        value: day,
                        child: Text(day),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('orders').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                var orders = snapshot.data!.docs;

                // Filter orders by selected day
                if (selectedDay != null) {
                  orders = orders.where((order) {
                    var orderData = order.data() as Map<String, dynamic>;
                    var orderDate =
                        (orderData['orderDate'] as Timestamp).toDate();
                    return DateFormat('d').format(orderDate) == selectedDay;
                  }).toList();
                }

                return ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    var order = orders[index];
                    var orderData = order.data() as Map<String, dynamic>;

                    var items = orderData['items'] as List<dynamic>? ?? [];
                    double subtotal = 0.0;

                    // Calculate subtotal
                    for (var item in items) {
                      subtotal +=
                          (item['price'] as double) * (item['quantity'] as int);
                    }

                    // Function to delete an order
                    void deleteOrder() async {
                      await FirebaseFirestore.instance
                          .collection('orders')
                          .doc(order.id)
                          .delete();
                    }

                    // Function to show the full image in a dialog
                    void showFullImage(String imageUrl) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          contentPadding: EdgeInsets.zero,
                          content: SizedBox(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: InteractiveViewer(
                              child:
                                  Image.network(imageUrl, fit: BoxFit.contain),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      );
                    }

                    return Card(
                      margin: const EdgeInsets.all(12.0),
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Order ID: ${orderData['orderId']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            Row(
                              children: [
                                const Text(
                                  'Name: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    orderData['userName'] ?? 'N/A',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              children: [
                                const Text(
                                  'Email: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    orderData['userEmail'] ?? 'N/A',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              children: [
                                const Text(
                                  'Township: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    orderData['township'] ?? 'Not Provided',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              children: [
                                const Text(
                                  'Street Address: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    orderData['streetAddress'] ??
                                        'Not Provided',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              'Phone: ${orderData['phone'] ?? 'N/A'}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              'Additional Info: ${orderData['additionalInfo'] ?? 'N/A'}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              'Delivery Method: ${orderData['deliveryMethod'] ?? 'N/A'}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              'Payment Method: ${orderData['paymentMethod'] ?? 'N/A'}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 8.0),
                            if (orderData['transactionImageUrl'] != null)
                              GestureDetector(
                                onTap: () => showFullImage(
                                    orderData['transactionImageUrl']),
                                child: Container(
                                  width: double.infinity,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          orderData['transactionImageUrl']),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            const SizedBox(height: 16.0),
                            const Text(
                              'Items:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Column(
                              children: items.map((item) {
                                double itemSubtotal =
                                    (item['price'] as double) *
                                        (item['quantity'] as int);
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${item['name']} x ${item['quantity']}',
                                              style:
                                                  const TextStyle(fontSize: 14),
                                            ),
                                            if (item['color'] != null)
                                              Text(
                                                'Color: ${item['color']}',
                                                style: const TextStyle(
                                                    fontSize: 12),
                                              ),
                                            if (item['storage'] != null)
                                              Text(
                                                'Storage: ${item['storage']}',
                                                style: const TextStyle(
                                                    fontSize: 12),
                                              ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        'K${itemSubtotal.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 10.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total: K${subtotal.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: deleteOrder,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                  ),
                                  child: const Text('Delete Order'),
                                ),
                              ],
                            ),
                          ],
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
    );
  }
}
