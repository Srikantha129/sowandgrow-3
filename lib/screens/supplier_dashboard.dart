import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sowandgrow/models/loan.dart';
import 'package:sowandgrow/screens/supplier_sales_dashboard.dart';
import 'package:sowandgrow/service/loan_service.dart';
import 'package:sowandgrow/service/purchase_service.dart';
import 'package:sowandgrow/service/seed_service.dart';

import '../models/purchase.dart';
import '../provider/user_provider.dart';
import '../service/user_service.dart';
import 'add_seed_screen.dart';
import '../models/seed.dart';
import '../models/user.dart';

class SupplierDashboard extends StatefulWidget {
  final User user;
  const SupplierDashboard({required this.user});

  @override
  State<SupplierDashboard> createState() => _SupplierDashboardState();
}

class _SupplierDashboardState extends State<SupplierDashboard> {
  String errorMessage = "";
  List<Seed> seeds = [];
  List<Purchase> purchases = [];
  List<Loan> loans = [];
  var currentUserId = '';

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    currentUserId = userProvider.user!.username;
    print('Current User ID: $currentUserId');
    fetchData();
  }

  Future<void> fetchData() async {
    seeds = await SeedService().fetchAllSeeds();
    print(seeds);
    purchases = await PurchaseService().fetchAllPurchases();
    loans = await LoanService().getLoansForBySupplierName(currentUserId);
    print(purchases);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Map<String, List<Seed>> groupedSeeds = {};

    // Group seeds by farmingType
    for (var seed in seeds) {
      if (seed.getSupplier == widget.user.username && seed.getStatus == "Available") {
        groupedSeeds.putIfAbsent(seed.farmingarea ?? 'Unknown Type', () => []).add(seed);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("සැපයුම්කරු උපකරණ පුවරුව",
            style: TextStyle(fontSize: 14.0)),
        actions: [
          IconButton(
              onPressed: () => fetchData(), icon: const Icon(Icons.refresh)),
          IconButton(
            icon: const Icon(Icons.description),
            onPressed: () {
              Navigator.push(
                context, // Current context
                MaterialPageRoute(
                    builder: (context) =>
                        SupplierSalesDashboard(user: widget.user)),
              );
            },
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
          // Blur filter for subtle effect
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "ඔබගේ ලැයිස්තුගත බීජ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.white),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AddSeed(user: widget.user),
                              ),
                            ),
                            child: const Text('බීජ එකතු කරන්න'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15.0),
                      const Text(
                        "ඔබ අනුමත කරන්නේ නම් ✔ ලකුණද, ඔබ ප්‍රතික්ෂේප කරන්නේ ✘ ලකුණද තෝරන්න",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                      const Divider(thickness: 1.0),
                      const SizedBox(height: 15.0),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: purchases.length,
                        itemBuilder: (context, index) {
                          final purchase = purchases[index];
                          if (purchase.suppliername == widget.user.username &&
                              purchase.getStatus == "Pending") {
                            return _buildPurchasesCard(purchase);
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                      const SizedBox(height: 15.0),
                      const Text(
                        "ඔබගේ බීජ ලැයිස්තුව",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                      const Divider(thickness: 1.0),
                      const SizedBox(height: 15.0),
                      // ListView.builder(
                      //   shrinkWrap: true,
                      //   physics: const NeverScrollableScrollPhysics(),
                      //   itemCount: seeds.length,
                      //   itemBuilder: (context, index) {
                      //     final seed = seeds[index];
                      //     if (seed.getSupplier == widget.user.username &&
                      //         seed.getStatus == "Available") {
                      //       return _buildSeedCard(seed);
                      //     } else {
                      //       return const SizedBox.shrink();
                      //     }
                      //   },
                      // ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: groupedSeeds.keys.length,
                      itemBuilder: (context, index) {
                        String farmingType = groupedSeeds.keys.elementAt(index);
                        List<Seed> typeSeeds = groupedSeeds[farmingType]!;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                farmingType,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                  color: Colors.white
                                ),
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: typeSeeds.length,
                              itemBuilder: (context, index) {
                                final seed = typeSeeds[index];
                                return _buildSeedCard(seed);
                              },
                            ),
                          ],
                        );
                      },
                    ),
                      const SizedBox(height: 15.0),
                      const Text(
                        "අනුමත කරන ලද බීජ ලැයිස්තුව",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                      const Divider(thickness: 1.0),
                      const SizedBox(height: 15.0),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: purchases.length,
                        itemBuilder: (context, index) {
                          final purchase = purchases[index];
                          if (purchase.suppliername == widget.user.username &&
                              purchase.getStatus != "Pending" &&
                              purchase.getStatus != "Reject") {
                            return _buildPurchasesNotPendingCard(purchase);
                          } else {
                            return const SizedBox.shrink();
                          }
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
                                    ' \nගොවියාගේ නම: ${loan.farmerName}'
                                    ' \nණය මුදල: රු. ${loan.amount} මසකට'
                                    ' \nණය කාලය: ${loan.periodInMonths} මාස'
                                    ' \nඅවසන් ගෙවන කාලය: ${loan.lastPaidMonth} මාස'
                                    ' \nණය ලබාගත් දිනය: ${loan.startDate.toDate().toLocal()}'),
                                trailing: SizedBox(
                                  height: 100.0,
                                  child: SingleChildScrollView(
                                    physics: const NeverScrollableScrollPhysics(),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Text(loan.status.toString()),
                                        const SizedBox(width: 5.0),
                                        if (loan.status != 'Completed')
                                          ElevatedButton(
                                            onPressed: () async {
                                              await LoanService()
                                                  .payInstallment(loan.id);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'වාරිකය සාර්ථකව ගෙවා ඇත'),
                                                ),
                                              );
                                              fetchData();
                                              // setState(() {});
                                            },
                                            style: ElevatedButton.styleFrom(
                                              foregroundColor: Colors.white,
                                              backgroundColor: Colors.green,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),
                                            ),
                                            child: const Text('වාරික ගෙවන්න'),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPurchasesCard(Purchase purchase) {
    return FutureBuilder<User>(
      future: UserService().getUser(purchase.getFarmername),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final farmerDetails = snapshot.data;
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            ),
            elevation: 1.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'ගොවිතැන් ප්රදේශය: ${farmerDetails?.farmingarea}'
                      '\nඅංකය: ${purchase.getId}'
                      '\nනම: ${purchase.getSeedname}'
                      '\nගොවියාගේ නම: ${purchase.getFarmername}'
                      '\nසම්පූර්ණ එකතුව: ${purchase.getTotal}'
                      '\nතොග: ${purchase.getQty}',
                      style: const TextStyle(fontSize: 12.0),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 18.0),
                    color: Colors.red,
                    onPressed: () async {
                      print('${purchase.getSeedname} ප්‍රතික්ෂේප කරන ලදී');
                      await PurchaseService()
                          .updatePurchaseStatus(purchase.getId, "Reject");
                      fetchData();
                      // setState(() {});
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.done, size: 18.0),
                    color: Colors.green,
                    onPressed: () async {
                      print('${purchase.getId} approved');
                      await PurchaseService()
                          .updatePurchaseStatus(purchase.getId, "Approved");
                      await SeedService().updateRemoveSeedQuantity(
                          purchase.getSeedId, purchase.getQty);
                      fetchData();
                      // setState(() {});
                    },
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildPurchasesNotPendingCard(Purchase purchase) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
      elevation: 1.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                purchase.getSeedname,
                style: const TextStyle(fontSize: 12.0),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 5.0),
            Expanded(
              child: Text(
                'මිල: ${purchase.getTotal}',
                style: const TextStyle(fontSize: 12.0),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 5.0),
            Expanded(
              child: Text(
                purchase.getDate.toDate().toLocal().toString(),
                style: const TextStyle(fontSize: 12.0),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 5.0),
            Expanded(
              child: Text(
                'තොග: ${purchase.getQty}',
                style: const TextStyle(fontSize: 12.0),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildPurchasesNotPendingCard(Purchase purchase) {
  //   return Card(
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(4.0),
  //     ),
  //     elevation: 1.0,
  //     child: Padding(
  //       padding: const EdgeInsets.all(8.0),
  //       child: SizedBox(
  //         width: 300.0,
  //         child: Row(
  //           mainAxisSize: MainAxisSize.min,
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Flexible (
  //               flex: 3,
  //               child: Text(
  //                 purchase.id,
  //                 style: const TextStyle(
  //                   fontWeight: FontWeight.bold,
  //                   fontSize: 14.0,
  //                 ),
  //               ),
  //             ),
  //             Row(
  //               mainAxisSize: MainAxisSize.min,
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Flexible (
  //                   child: Text(
  //                     'Date: ${DateFormat('yyyy-MM-dd HH:mm').format(purchase.getDate.toDate())}',
  //                     style: const TextStyle(fontSize: 12.0),
  //                   ),
  //                 ),
  //                 const SizedBox(width: 10),
  //                 Flexible (
  //                     child: Text(
  //                       'Farmer Name: ${purchase.getFarmername}',
  //                       style: const TextStyle(fontSize: 12.0),
  //                     ),
  //                 ),
  //                 const SizedBox(width: 10),
  //                 Text(
  //                   'Price: ${purchase.getTotal}',
  //                   style: const TextStyle(fontSize: 12.0),
  //                 ),
  //                 const SizedBox(width: 10),
  //                 Text(
  //                   'Stock: ${purchase.getQty}',
  //                   style: const TextStyle(fontSize: 12.0),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildSeedCard(Seed seed) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
      elevation: 1.0,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Expanded(
            //   flex: 1,
            //   child: Image.network(
            //     seed.image,
            //     height: 50.0,
            //   ),
            // ),
            Expanded(
              flex: 3,
              child: Text(
                seed.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0,
                ),
              ),
            ),
            Row(
              children: [
                Text(
                  'මිල: ${seed.price}',
                  style: const TextStyle(fontSize: 12.0),
                ),
                const SizedBox(width: 5.0),
                Text(
                  'තොග: ${seed.stock}',
                  style: const TextStyle(fontSize: 12.0),
                ),
              ],
            ),
            const SizedBox(
              width: 10.0,
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 18.0),
              color: Colors.red,
              onPressed: () async {
                print('${seed.name} Removed ');
                await SeedService().updateSeedStatus(seed.getId, "UnAvailable");
                fetchData();
                // setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}
