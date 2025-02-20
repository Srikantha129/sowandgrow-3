import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:sowandgrow/models/loan.dart';
import 'package:sowandgrow/service/loan_service.dart';
import 'package:sowandgrow/service/purchase_service.dart';
import 'package:sowandgrow/service/seed_service.dart';
import '../models/purchase.dart';
import '../provider/user_provider.dart';
import '../models/seed.dart';
import '../models/user.dart';

class SupplierSalesDashboard extends StatefulWidget {
  final User user;
  const SupplierSalesDashboard({required this.user});

  @override
  State<SupplierSalesDashboard> createState() => _SupplierSalesDashboardState();
}

class _SupplierSalesDashboardState extends State<SupplierSalesDashboard> {
  String errorMessage = "";
  List<Seed> seeds = [];
  List<Purchase> purchases = [];
  List<Loan> loans = [];
  double totalSales = 0.0;
  int totalQuantitySold = 0;
  int approvedLoans = 0;
  int pendingLoans = 0;
  int partiallyPaidLoans = 0;
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
    purchases = await PurchaseService().fetchAllPurchases();
    loans = await LoanService().getLoansForBySupplierName(currentUserId);

    // Calculate total sales and total quantity sold
    totalSales = 0.0;
    totalQuantitySold = 0;

    for (var purchase in purchases) {
      if (purchase.suppliername == widget.user.username && purchase.status == "Approved") {
        totalSales += purchase.total;
        totalQuantitySold += purchase.qty;
      }
    }

    // Calculate loan statuses
    approvedLoans = loans.where((loan) => loan.status == "Completed").length;
    pendingLoans = loans.where((loan) => loan.status == "Pending").length;
    partiallyPaidLoans = loans.where((loan) => loan.status == "Partially Paid").length;
    print(approvedLoans);
    print(pendingLoans);
    print(partiallyPaidLoans);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("විකුණුම් උපකරණ පුවරුව", style: TextStyle(fontSize: 16.0)),
        actions: [
          IconButton(onPressed: () => fetchData(), icon: const Icon(Icons.refresh)),
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
            filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    _buildSalesSummary(),
                    const SizedBox(height: 20),
                    _buildLoanSummaryChart(),
                    // const SizedBox(height: 20),
                    // _buildSalesBarChart(),
                    // const SizedBox(height: 20),
                    // _buildPurchaseList(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Sales Summary Section
  Widget _buildSalesSummary() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "විකුණුම් වාර්තාව",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text("මුළු විකුණුම්: රු. $totalSales", style: const TextStyle(fontSize: 16)),
            Text("විකුණන ලද මුළු ප්‍රමාණය ඒකක: $totalQuantitySold ", style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  // Loan Summary Pie Chart
  Widget _buildLoanSummaryChart() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "ණය බෙදාහැරීම තත්ත්වය",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const SizedBox(height: 10),
            Text("සම්පූර්ණ කළ ණය: $approvedLoans", style: const TextStyle(fontSize: 16)),
            Text("පොරොත්තු ණය: $pendingLoans", style: const TextStyle(fontSize: 16)),
            Text("අර්ධ වශයෙන් ගෙවන ලද ණය: $partiallyPaidLoans", style: const TextStyle(fontSize: 16)),

            SizedBox(
              height: 200.0,
              child: PieChart(
                PieChartData(
                  sections: _generateLoanPieChartSections(),
                  centerSpaceRadius: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Generate Pie Chart Sections for Loan Statuses
  List<PieChartSectionData> _generateLoanPieChartSections() {
    return [
      PieChartSectionData(
        color: Colors.green,
        value: approvedLoans.toDouble(),
        title: 'සම්පූර්ණ කළ',
        radius: 50,
        titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      PieChartSectionData(
        color: Colors.blue,
        value: pendingLoans.toDouble(),
        title: 'පොරොත්තු',
        radius: 50,
        titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      PieChartSectionData(
        color: Colors.red,
        value: partiallyPaidLoans.toDouble(),
        title: 'අර්ධව ගෙවන ලද',
        radius: 50,
        titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    ];
  }

  // Sales Bar Chart Section
  // Widget _buildSalesBarChart() {
  //   return Card(
  //     elevation: 2,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(8.0),
  //     ),
  //     child: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           const Text(
  //             "Sales Overview",
  //             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //           ),
  //           const SizedBox(height: 10),
  //           SizedBox(
  //             height: 200,
  //             child: BarChart(
  //               BarChartData(
  //                 borderData: FlBorderData(show: false),
  //                 titlesData: FlTitlesData(
  //                   bottomTitles: AxisTitles(sideTitles: _bottomTitles()),
  //                   leftTitles: AxisTitles(sideTitles: _leftTitles()),
  //                 ),
  //                 barGroups: _generateBarChartData(),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Generate Bar Chart Data
  // List<BarChartGroupData> _generateBarChartData() {
  //   return [
  //     BarChartGroupData(
  //       x: 1,
  //       barRods: [BarChartRodData(toY: totalSales, color: Colors.blue)],
  //     ),
  //     BarChartGroupData(
  //       x: 2,
  //       barRods: [BarChartRodData(toY: totalQuantitySold.toDouble(), color: Colors.orange)],
  //     ),
  //   ];
  // }

  // Bottom Titles for Bar Chart
  // SideTitles _bottomTitles() {
  //   return SideTitles(
  //     showTitles: true,
  //     getTitlesWidget: (value, meta) {
  //       switch (value.toInt()) {
  //         case 1:
  //           return const Text("Sales");
  //         case 2:
  //           return const Text("Quantity");
  //         default:
  //           return const Text("");
  //       }
  //     },
  //   );
  // }
  //
  // // Left Titles for Bar Chart
  // SideTitles _leftTitles() {
  //   return SideTitles(
  //     showTitles: true,
  //     reservedSize: 40,
  //     getTitlesWidget: (value, meta) {
  //       return Text(value.toString());
  //     },
  //   );
  // }

  // Purchase List Section
  // Widget _buildPurchaseList() {
  //   return ListView.builder(
  //     shrinkWrap: true,
  //     physics: const NeverScrollableScrollPhysics(),
  //     itemCount: purchases.length,
  //     itemBuilder: (context, index) {
  //       final purchase = purchases[index];
  //       if (purchase.suppliername == widget.user.username && purchase.status == "Approved") {
  //         return _buildPurchasesNotPendingCard(purchase);
  //       } else {
  //         return const SizedBox.shrink();
  //       }
  //     },
  //   );
  // }
}
