import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<void> generateInvoice(Map<String, dynamic> orderData) async {
  try {
    print('Generating Invoice with Order Data: $orderData'); // Debug line

    // Load fonts
    final fontData = await rootBundle
        .load("assets/fonts/Noto_Sans/static/NotoSans_Condensed-Bold.ttf");
    final ttf = pw.Font.ttf(fontData);
    final fontBoldData = await rootBundle
        .load("assets/fonts/Noto_Sans/static/NotoSans_Condensed-Bold.ttf");
    final ttfBold = pw.Font.ttf(fontBoldData);

    print('Fonts loaded successfully');

    final pdf = pw.Document();

    // Add invoice page
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.DefaultTextStyle(
          style: pw.TextStyle(font: ttf),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Invoice',
                  style: pw.TextStyle(fontSize: 24, font: ttfBold)),
              pw.SizedBox(height: 20),
              pw.Text('Order ID: ${orderData['orderId']}'),
              pw.Text('Date: ${orderData['orderDate']}'),
              pw.SizedBox(height: 20),
              pw.Text('Customer Details:',
                  style: pw.TextStyle(fontSize: 18, font: ttf)),
              pw.Text('Name: ${orderData['userName']}'),
              pw.Text('Email: ${orderData['userEmail']}'),
              pw.Text('Phone: ${orderData['phone']}'),
              pw.Text('State: ${orderData['state']}'),
              pw.Text('Township: ${orderData['township']}'),
              pw.Text('Street Address: ${orderData['streetAddress']}'),
              pw.Text('Additional Info: ${orderData['additionalInfo']}'),
              pw.SizedBox(height: 20),
              pw.Text('Items:', style: pw.TextStyle(fontSize: 18, font: ttf)),
              if ((orderData['items'] as List).isEmpty)
                pw.Text('No items available')
              else
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: (orderData['items'] as List).map((item) {
                    final itemName = item['name'] ?? 'Unknown';
                    final quantity = item['quantity'] ?? 0;
                    final price = item['price'] ?? 0.0;
                    final subtotal = price * quantity;
                    final color = item['color'] ?? 0.0;
                    final storage = item['storage'] ?? 0.0;
                    final imageUrl = item['imageUrl'] ?? 0.0;
                    return pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Item: $itemName'),
                        pw.Text('Quantity: $quantity'),
                        pw.Text('Price: ${price.toStringAsFixed(2)} Ks'),
                        pw.Text('Subtotal: ${subtotal.toStringAsFixed(2)} Ks'),
                        pw.Text('Color: $color'),
                        pw.Text('Storage: $storage'),
                        pw.Text('ImageUrl: $imageUrl'),
                        pw.SizedBox(height: 10),
                      ],
                    );
                  }).toList(),
                ),
              pw.SizedBox(height: 20),
              pw.Text('Total: ${orderData['totalAmount']} Ks',
                  style: pw.TextStyle(fontSize: 18, font: ttf)),
            ],
          ),
        ),
      ),
    );

    final output = await getTemporaryDirectory();
    final filePath = "${output.path}/invoice.pdf";
    final file = File(filePath);

    // Ensure directory exists
    if (!(await file.parent.exists())) {
      await file.parent.create(recursive: true);
    }

    await file.writeAsBytes(await pdf.save());

    await Printing.sharePdf(bytes: await pdf.save(), filename: 'invoice.pdf');
  } catch (e) {
    print('Error generating invoice: $e');
  }
}
 