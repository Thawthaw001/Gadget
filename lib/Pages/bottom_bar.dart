import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thaw/Widget/model_provider.dart';

class BottomNavBar extends StatefulWidget {
  final Function() onAddToCartPressed;

  const BottomNavBar({super.key, required this.onAddToCartPressed});

  @override
  BottomNavBarState createState() => BottomNavBarState();
}

class BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    final modelProvider = Provider.of<ModelProvider>(context);

    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.red,
                child: IconButton(
                  icon: const Icon(Icons.remove, color: Colors.white),
                  onPressed: modelProvider.decrementQuantity,
                ),
              ),
              const SizedBox(width: 10),
              Text('${modelProvider.quantity}'),
              const SizedBox(width: 10),
              CircleAvatar(
                backgroundColor: Colors.green,
                child: IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: () {
                    if (modelProvider.quantity < 10) {
                      modelProvider.incrementQuantity();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Quantity cannot exceed 10'),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
          ElevatedButton.icon(
            onPressed: widget.onAddToCartPressed,
            icon: const Icon(Icons.shopping_cart, size: 20,color:Colors.black),
            label: const Text(
              'Add to Cart',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                  fontFamily: "English",
                  fontWeight: FontWeight.normal),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
            ),
          ),
        ],
      ),
    );
  }
}
