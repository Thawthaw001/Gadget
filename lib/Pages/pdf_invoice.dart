import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
 
Future<void> generateInvoice(Map<String, dynamic> order) async {
  final pdf = pw.Document();
  
  pdf.addPage(
    pw.Page(
      build: (pw.Context context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Invoice', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 20),
          pw.Text('Order ID: ${order['orderId']}'),
          pw.Text('Date: ${order['orderDate']}'),
          pw.SizedBox(height: 20),
          pw.Text('Items:', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          ...order['items'].map<pw.Widget>((item) {
            return pw.Padding(
              padding: const pw.EdgeInsets.symmetric(vertical: 4),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(item['itemName']),
                  pw.Text('${item['quantity']} x ${item['price']} Ks'),
                ],
              ),
            );
          }).toList(),
          pw.SizedBox(height: 20),
          pw.Text('Total: ${order['totalAmount']} Ks', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
        ],
      ),
    ),
  );

  final output = await getTemporaryDirectory();
  final file = File('${output.path}/invoice_${order['orderId']}.pdf');
  await file.writeAsBytes(await pdf.save());

   await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
}
