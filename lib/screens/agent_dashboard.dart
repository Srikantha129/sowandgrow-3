import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../provider/user_provider.dart';
import '../service/user_service.dart';

class AgentDashboard extends StatefulWidget {
  final User user;
  const AgentDashboard({required this.user});

  @override
  State<AgentDashboard> createState() => _AgentDashboardState();
}

class _AgentDashboardState extends State<AgentDashboard> {
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    users = await UserService().fetchAllUsersByStatus("Pending");
    setState(() {});
  }

  Future<void> refreshData() async {
    users = await UserService().fetchAllUsersByStatus("Pending");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    print(userProvider.user?.farmingarea);
    print('asdf ');
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ගොවිජන නියාමක පුවරුව",
          style: TextStyle(fontSize: 16.0),
        ),
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
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Text(
                    "ඔබ ගොවියා අනුමත කරන්නේ නම් ✔ ලකුණද, ඔබ ප්‍රතික්ෂේප කරන්නේ ✘ ලකුණද තෝරන්න",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 15.0),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];

                      print(userProvider.user!.farmingarea);
                      if (user.farmingarea == widget.user.farmingarea) {
                        return _buildUserCard(user);
                      }
                      else {
                        return const SizedBox.shrink();
                      }
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

  Widget _buildUserCard(User user) {
    var farmingtype = '';
    if(user.farmingtype == 'Paddy'){
      farmingtype = 'වී';
    } else if (user.farmingtype == 'Other') {
      farmingtype = 'අනෙකුත් බීජ';
    } else if (user.farmingtype == 'Both') {
      farmingtype = 'බීජ දෙවර්ගයම';
    }

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
              flex: 3,
              child: Text(
                user.username,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                ),
              ),
            ),
            Row(
              children: [
                Text(
                  'බීජ වර්ගය : $farmingtype',
                  style: const TextStyle(fontSize: 12.0),
                ),
              ],
            ),
            const SizedBox(
              width: 10.0,
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 18.0),
              color: Colors.red,
              onPressed: () async {
                print('${user.username} Rejected');
                await UserService().updateUserStatus(user.username, "Rejected");
                setState(() {});
              },
            ),
            IconButton(
              icon: const Icon(Icons.done, size: 18.0),
              color: Colors.green,
              onPressed: () async {
                print('${user.username} Authorized');
                await UserService()
                    .updateUserStatus(user.username, "Authorized");
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}
