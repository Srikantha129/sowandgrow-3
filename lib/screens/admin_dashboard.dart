import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sowandgrow/screens/agent_signup_page.dart';
import 'package:sowandgrow/screens/farmer_signup_page.dart';
import 'package:sowandgrow/screens/supplier_signup_page.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "පරිපාලක උපකරණ පුවරුව",
          style: TextStyle(fontSize: 14.0),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.description),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('පරිපාලක විස්තර වාර්තාව පූරණය කරන්න'),
              ),
            ),
          ),
        ],
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
            filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FarmerSignUpPage(),
                            ),
                          ),
                          icon: const Icon(Icons.account_circle),
                          label: const Text('ගොවියා එකතු කරන්න'),
                        ),
                        const SizedBox(height: 10.0),
                        ElevatedButton.icon(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SupplierSignUpPage(),
                            ),
                          ),
                          icon: const Icon(Icons.inventory),
                          label: const Text('සැපයුම්කරු එකතු කරන්න'),
                        ),
                        const SizedBox(height: 10.0),
                        ElevatedButton.icon(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AgentSignUpPage(),
                            ),
                          ),
                          icon: const Icon(Icons.supervisor_account),
                          label: const Text('ගොවිජන නියාමකවරයෙකු එකතු කරන්න'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
