import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sowandgrow/service/purchase_service.dart';

import '../models/cart_item.dart';
import '../models/loan.dart';
import '../models/purchase.dart';
import '../provider/cart_provider.dart';
import '../provider/user_provider.dart';
import '../service/loan_service.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  void _handlePayment(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('සාර්ථකව භාණ්ඩය මිලට ගන්නා ලදී !!'),
        ),
      );
      Navigator.of(context).pop();
    });
  }

  void _showPaymentDialog(BuildContext context) {
    final cardNumberController = TextEditingController();
    final expiryDateController = TextEditingController();
    final cvvController = TextEditingController();

    void _handlePayment(BuildContext context) {
      final cardNumber = cardNumberController.text.trim();
      final expiryDate = expiryDateController.text.trim();
      final cvv = cvvController.text.trim();

      // Basic validations
      if (cardNumber.isEmpty || cardNumber.length < 16 || int.tryParse(cardNumber) == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('කරුණාකර නිවැරදි කාඩ්පත් අංකයක් ඇතුළත් කරන්න.')),
        );
        return;
      }

      if (expiryDate.isEmpty || !RegExp(r'^\d{2}/\d{2}$').hasMatch(expiryDate)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('කරුණාකර නිවැරදි කල්පිරෙන දිනය ඇතුළත් කරන්න (MM/YY).')),
        );
        return;
      }

      // Extract month and year from expiryDate
      final parts = expiryDate.split('/');
      final month = int.tryParse(parts[0]);
      final year = int.tryParse(parts[1]);

      if (month == null || month < 1 || month > 12) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('කරුණාකර 1 සහ 12 අතර මාසයක් ඇතුළත් කරන්න.')),
        );
        return;
      }

      if (year == null || year < 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('කරුණාකර වලංගු වසරක් ඇතුළත් කරන්න.')),
        );
        return;
      }

      if (cvv.isEmpty || cvv.length != 3 || int.tryParse(cvv) == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('කරුණාකර නිවැරදි CVV අංකයක් ඇතුළත් කරන්න.')),
        );
        return;
      }

      // Proceed with payment
      Navigator.of(context).pop(); // Close the dialog
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ගෙවීම් සාර්ථකයි!')),
      );
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ගෙවීම් විස්තර'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: cardNumberController,
                decoration: const InputDecoration(
                  labelText: 'කාඩ්පත් අංකය',
                  hintText: 'කාඩ්පත් අංකය ඇතුළත් කරන්න',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: expiryDateController,
                decoration: const InputDecoration(
                  labelText: 'කල්පිරෙන දිනය',
                  hintText: 'මාසය/වසර',
                ),
                keyboardType: TextInputType.datetime,
              ),
              TextField(
                controller: cvvController,
                decoration: const InputDecoration(
                  labelText: 'CVV',
                  hintText: 'CVV ඇතුළත් කරන්න ',
                ),
                keyboardType: TextInputType.number,
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('අවලංගු කරන්න'),
            ),
            TextButton(
              onPressed: () {
                _handlePayment(context);
              },
              child: const Text('ගෙවන්න'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ඔබේ කරත්තය'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/backgroundimage.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: cartProvider.cartItems.isEmpty
                ? const Center(
              child: Text(
                'ඔබේ කරත්තය හිස්ය!',
                style: TextStyle(fontSize: 0.0),
              ),
            )
                : ListView.builder(
              itemCount: cartProvider.cartItems.length,
              itemBuilder: (context, index) {
                final cartItem = cartProvider.cartItems[index];
                return CartItemWidget(cartItem: cartItem);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: cartProvider.cartItems.isEmpty
          ? null
          : Container(
        color: Colors.grey[200],
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Total Price Column
            Text(
              'එකතුව: රු. ${cartProvider.totalCartPrice.toStringAsFixed(2)}',
              style: const TextStyle(
                  fontSize: 18.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10.0), // Space between total and buttons
            // Buttons Column
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await _handleDirectPurchase(cartProvider, userProvider);
                    _showPaymentDialog(context);
                    cartProvider.clearCart();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[400],
                  ),
                  child: const Text('සෘජුවම මිලට ගන්න'),
                ),
                const SizedBox(width: 10.0),
                ElevatedButton(
                  onPressed: () async {
                    final selectedLoanPeriod = await showModalBottomSheet<int>(
                      context: context,
                      builder: (context) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ListTile(
                              title: const Text('මාස 3'),
                              onTap: () => Navigator.pop(context, 3),
                            ),
                            ListTile(
                              title: const Text('මාස 6'),
                              onTap: () => Navigator.pop(context, 6),
                            ),
                            ListTile(
                              title: const Text('වසරක්'),
                              onTap: () => Navigator.pop(context, 12),
                            ),
                          ],
                        );
                      },
                    );
                    if (selectedLoanPeriod == null || selectedLoanPeriod < 1) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'කරුණාකර ඉදිරියට යාමට ණය කාල සීමාවක් තෝරන්න.'),
                        ),
                      );
                    } else if (selectedLoanPeriod > 0) {
                      await _handleLoanCheckout(
                          cartProvider, userProvider, selectedLoanPeriod);
                      await _handleDirectPurchase(cartProvider, userProvider);
                      _showPaymentDialog(context);
                      cartProvider.clearCart();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('ණයට ගන්න'),
                ),
              ],
            ),
          ],
        ),
      ),

    );
  }
}

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;

  const CartItemWidget({required this.cartItem});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Image.network(
                  cartItem.image,
                  height: 50.0,
                  width: 50.0,
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cartItem.name,
                        style: const TextStyle(fontSize: 16.0),
                      ),
                      const SizedBox(height: 4.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'ප්‍රමාණය:',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () => cartProvider.updateQuantity(
                                    cartItem.id, cartItem.quantity - 1),
                                constraints: const BoxConstraints.tightFor(
                                  width: 32.0,
                                ),
                              ),
                              Text('${cartItem.quantity}'),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () => cartProvider.updateQuantity(
                                    cartItem.id, cartItem.quantity + 1),
                                constraints:
                                const BoxConstraints.tightFor(width: 32.0),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'රු. ${(cartItem.price * cartItem.quantity).toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => cartProvider.removeItem(cartItem),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Future<void> _handleDirectPurchase(
    CartProvider cartProvider, UserProvider userProvider) async {
  for (var item in cartProvider.cartItems) {
    final purchase = Purchase(
      seedname: item.name,
      farmername: userProvider.user!.username,
      seedId: item.id,
      qty: item.quantity,
      status: 'Pending',
      total: item.totalPrice,
      date: Timestamp.now(),
      id: DateTime.now().millisecondsSinceEpoch.toString() +
          Random().nextInt(1000).toString(),
      suppliername: item.supplier,
    );
    await PurchaseService().savePurchase(purchase);
  }
}

Future<void> _handleLoanCheckout(CartProvider cartProvider,
    UserProvider userProvider, int selectedLoanPeriod) async {
  for (var item in cartProvider.cartItems) {
    final loanAmount = (item.totalPrice / selectedLoanPeriod).round();
    final loan = Loan(
      purchaseId: item.id,
      amount: loanAmount,
      periodInMonths: selectedLoanPeriod,
      lastPaidMonth: 0,
      status: 'Pending',
      startDate: Timestamp.now(),
      id: DateTime.now().millisecondsSinceEpoch.toString() +
          Random().nextInt(1000).toString(),
      farmerName: userProvider.user!.username,
      supplierName: item.supplier,
    );
    await LoanService().saveLoan(loan);
  }
}
