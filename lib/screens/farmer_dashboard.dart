import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sowandgrow/models/cart_item.dart';
import 'package:sowandgrow/models/loan.dart';
import 'package:sowandgrow/models/seed.dart';
import 'package:sowandgrow/provider/cart_provider.dart';
import 'package:sowandgrow/provider/user_provider.dart';
import 'package:sowandgrow/service/loan_service.dart';
import 'package:sowandgrow/service/purchase_service.dart';
import 'package:sowandgrow/service/seed_service.dart';
import 'package:sowandgrow/service/user_service.dart';

import '../models/purchase.dart';
import '../models/user.dart';
import 'cart_screen.dart';

class FarmerDashboard extends StatefulWidget {
  final User user;
  const FarmerDashboard({required this.user});

  @override
  State<FarmerDashboard> createState() => _FarmerDashboardState();
}

class _FarmerDashboardState extends State<FarmerDashboard> {
  List<Seed> filteredSeeds = [];
  String selectedFilter = 'All';
  List<Seed> seeds = [];
  List<Purchase> purchases = [];
  List<Loan> loans = [];
  List<String> thisMonthPurchasesSeedIdsList = [];
  var currentUserId = '';
  bool didFarmNow = false;
  List<String> notifications = [];

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    currentUserId = userProvider.user!.username;
    fetchData();
    fetchFarmingStatus();
    fetchUsersFarming();
  }

  Future<void> fetchFarmingStatus() async {
    try {
      User user = await UserService().getUser(currentUserId);
      setState(() {
        didFarmNow = user.isfarming == 'true';
      });
    } catch (e) {
      print('Error fetching farming status: $e');
    }
  }

  void applyFilter(String filter) {
    setState(() {
      selectedFilter = filter;
      if (filter == 'All') {
        filteredSeeds = seeds;
      } else if (filter == 'Paddy') {
        filteredSeeds =
            seeds.where((seed) => seed.farmingtype == 'Paddy').toList();
      } else {
        filteredSeeds =
            seeds.where((seed) => seed.farmingtype != 'Paddy').toList();
      }
    });
  }

  void addNotification(String message) {
    setState(() {
      notifications.add(message);
    });
  }


  void showNotificationsPanel(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          color: Colors.white,
          child: ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const Icon(Icons.notifications, color: Colors.blue),
                title: Text(notifications[index]),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      notifications.removeAt(index);
                    });
                    Navigator.pop(context);
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> fetchUsersFarming() async {
    List<User> farmingUsers = await UserService().fetchAllUsersWithFarming();
    print(farmingUsers.length);
    String userNames = farmingUsers.map((user) => user.username).join(', ');
    String notification =
        'දැනට, ගොවියන් ${farmingUsers.length} ගොවිතැන් කරති. \n'
        'ගොවියන් :  $userNames ';
    addNotification(notification);
  }

  Future<void> fetchData() async {
    seeds = await SeedService().fetchAllSeeds();
    filteredSeeds = seeds;
    purchases = await PurchaseService().getPurchasesForCurrentMonth();
    loans = await LoanService().getLoansForByFarmerName(currentUserId);
    setState(() {});
    thisMonthPurchasesSeedIdsList =
        purchases.map((purchase) => purchase.seedname).toList();

    if (purchases.isNotEmpty) {
      if (purchases.isNotEmpty) {
        String notification =
            'ඔබ ගිය වසරේ මෙම කාල වකවානුව තුලදී ${thisMonthPurchasesSeedIdsList.join(', ')} මිලදී ගන්නා ලදී';
        addNotification(notification);
      }
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(
      //         'ඔබ ගිය වසරේ මෙම කාල වකවානුව තුලදී ${thisMonthPurchasesSeedIdsList.join(', ')} මිලදී ගන්නා ලදී'),
      //   ),
      // );
    }
  }

  Future<void> refreshData() async {
    seeds = await SeedService().fetchAllSeeds();
    purchases = await PurchaseService().getPurchasesForCurrentMonth();
    loans = await LoanService().getLoansForByFarmerName(currentUserId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ගොවි උපකරණ පුවරුව",
          style: TextStyle(fontSize: 16.0),
        ),
        actions: [
          IconButton(
              onPressed: () => refreshData(), icon: const Icon(Icons.refresh)),
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.shopping_cart),
                Positioned(
                  top: 0.0,
                  right: 0.0,
                  child: cartProvider.cartItems.isEmpty
                      ? Container()
                      : Container(
                          padding: const EdgeInsets.all(2.0),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Text(
                            cartProvider.cartItems.length.toString(),
                            style: const TextStyle(
                              fontSize: 10.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                ),
              ],
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              applyFilter(value);
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'All',
                child: Text('සියලු බීජ'),
              ),
              const PopupMenuItem<String>(
                value: 'Paddy',
                child: Text('වී බීජ'),
              ),
              const PopupMenuItem<String>(
                value: 'Other',
                child: Text('අනෙකුත් බීජ'),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => showNotificationsPanel(context),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background01.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceBetween,
                    children: [
                      Text(
                        "$currentUserId සාදරයෙන් පිළිගනිමු!!",
                        style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text(
                        'ඔබ මෙම කාලය තුළදී ගොවිතැන් කරනවාද?',
                        style: TextStyle(color: Colors.white),
                      ),
                      Switch(
                        value: didFarmNow,
                        onChanged: (value) async {
                          setState(() {
                            didFarmNow = value;
                          });
                          try {
                            await UserService().updateUIsFarmingStatus(
                                currentUserId, value.toString());
                          } catch (e) {
                            print("Error updating farming status: $e");
                          }
                        },
                        activeColor: Colors.green,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    "වී වර්ග ලැයිස්තුව",
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 16.0),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16.0,
                      crossAxisSpacing: 16.0,
                    ),
                    itemCount: filteredSeeds.length,
                    itemBuilder: (context, index) {
                      final seed = filteredSeeds[index];
                      double discountedPrice =
                          seed.price - (seed.price * (seed.percentage / 100));
                      return _buildSeedCard(seed, discountedPrice);
                    },
                  ),
                  if (loans.isNotEmpty)
                    const Text(
                      "ණය:",
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  if (loans.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: loans.length,
                      itemBuilder: (context, index) {
                        final loan = loans[index];
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: ListTile(
                            title: Text('ණය අංකය: ${loan.id}'),
                            subtitle: Text(
                                'ණය මුදල: රු. ${loan.amount} මසකට'
                                ' \nණය කාලය: ${loan.periodInMonths} මාස'
                                ' \nණය දිනය: ${loan.startDate.toDate().toLocal()}'),
                            trailing: Text(loan.status),
                            onTap: () {
                              // Handle loan tile tap (e.g., show loan details)
                            },
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeedCard(Seed seed, double discountedPrice) {
    final cartProvider = Provider.of<CartProvider>(context);
    int selectedQuantity = 1;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(
                seed.image,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Image.asset('assets/placeholder.png'),
              ),
              const SizedBox(height: 8.0),
              Text(
                seed.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'රු. ${seed.price}',
                      style: const TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                      ),
                    ),
                    TextSpan(
                      text: '  (රු. $discountedPrice)',
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${seed.percentage}% වට්ටම්'),
                  Text('තොග: ${seed.stock}'),
                ],
              ),
              const SizedBox(height: 8.0),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     const Text(
              //       'Quantity:',
              //       style: TextStyle(fontWeight: FontWeight.bold),
              //     ),
              //     Row(
              //       mainAxisSize: MainAxisSize.min,
              //       children: [
              //         IconButton(
              //           icon: const Icon(Icons.remove),
              //           onPressed: () {
              //             if (selectedQuantity > 1) {
              //               setState(() {
              //                 selectedQuantity--;
              //               });
              //             }
              //           },
              //           constraints: const BoxConstraints.tightFor(width: 32.0), // Fixed width
              //         ),
              //         Text('$selectedQuantity'),
              //         IconButton(
              //           icon: const Icon(Icons.add),
              //           onPressed: () {
              //             if (selectedQuantity < seed.stock) {
              //               setState(() {
              //                 selectedQuantity++;
              //               });
              //             } else {
              //               ScaffoldMessenger.of(context).showSnackBar(
              //                 const SnackBar(
              //                   content: Text('Insufficient Stock Available!'),
              //                 ),
              //               );
              //             }
              //           },
              //           constraints: const BoxConstraints.tightFor(width: 32.0), // Fixed width
              //         ),
              //       ],
              //     ),
              //   ],
              // ),
              const SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: () {
                  // if (selectedQuantity > 0 && selectedQuantity <= seed.stock) {
                  cartProvider.addToCart(CartItem(
                      id: seed.id,
                      name: seed.name,
                      price: discountedPrice,
                      image: seed.image,
                      quantity: selectedQuantity,
                      supplier: seed.supplier));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          '$selectedQuantity x ${seed.name} කරත්තයට එකතු කරන ලදී!'),
                    ),
                  );
                  // } else {
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     const SnackBar(
                  //       content: Text('Please select a valid quantity!'),
                  //     ),
                  //   );
                  // }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: const Text('එකතු කරන්න'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
