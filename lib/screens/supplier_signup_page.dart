import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sowandgrow/screens/supplier_dashboard.dart';
import 'package:sowandgrow/service/user_service.dart';

import '../models/user.dart';
import '../provider/user_provider.dart';

class SupplierSignUpPage extends StatefulWidget {
  const SupplierSignUpPage({super.key});

  @override
  State<SupplierSignUpPage> createState() => _SupplierSignUpPageState();
}

class _SupplierSignUpPageState extends State<SupplierSignUpPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String errorMessage = "";
  Color errorMessageTextColor = Colors.yellowAccent;

  @override
  Widget build(BuildContext context) {
    // List<DropdownMenuItem<String>> dropdownSeedTypeItems = [
    //   const DropdownMenuItem(value: "", child: Text("Select Seed Type")), // Hint
    //   const DropdownMenuItem(value: "Rice", child: Text("Rice")),
    //   const DropdownMenuItem(value: "Tomato", child: Text("Tomato")),
    //   const DropdownMenuItem(value: "Brinjal", child: Text("Brinjal")),
    //   const DropdownMenuItem(value: "Capsicum", child: Text("Capsicum")),
    //   const DropdownMenuItem(value: "Beans", child: Text("Beans")),
    //   const DropdownMenuItem(value: "Spinach", child: Text("Spinach")),
    // ];
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/coffeechocowallpaper.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/sowAndGrowLogo.png',
                          width: 200.0,
                          height: 200.0,
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: "පරිශීලක නාමය",
                            labelStyle: const TextStyle(color: Colors.white),
                            errorText:
                                errorMessage.isEmpty ? null : errorMessage,
                            errorStyle: TextStyle(color: errorMessageTextColor),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: "මුරපදය",
                            labelStyle: const TextStyle(color: Colors.white),
                            errorText:
                                errorMessage.isEmpty ? null : errorMessage,
                            errorStyle: TextStyle(color: errorMessageTextColor),
                          ),
                          obscureText: true,
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: () async {
                            if (_usernameController.text.isEmpty ||
                                _passwordController.text.isEmpty) {
                              setState(() {
                                errorMessage =
                                    "පරිශීලක නාමය සහ මුරපදය අවශ්‍ය වේ";
                              });
                            } else {
                              setState(() {
                                errorMessage = "";
                              });
                              // No Errors
                              User user = User(
                                  username: _usernameController.text,
                                  password: _passwordController.text,
                                  userrole: 'Supplier',
                                  farmingarea: '',
                                  farmingtype: '',
                                  status: "Authorized",
                                  nic: '',
                                  isfarming: 'false');
                              print(await UserService()
                                  .checkUserExists(_usernameController.text));
                              print("2");
                              if (await UserService()
                                  .checkUserExists(_usernameController.text)) {
                                print("3");
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('පරිශීලක නාමය දැනටමත් පවතී !!'),
                                  ),
                                );
                              } else {
                                await UserService().saveUser(user);
                                Provider.of<UserProvider>(context,
                                        listen: false)
                                    .setUser(user);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'සැපයුම්කරු සාර්ථකව ලියාපදිංචි විය!!'),
                                  ),
                                );

                                // Wait briefly before navigating (adjust delay as needed)
                                await Future.delayed(
                                    const Duration(milliseconds: 1500));
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SupplierDashboard(user: user)),
                                );
                              }
                            }
                          },
                          // Navigate to your home screen or other pages after successful login
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.fromLTRB(
                                    100.0, 20.0, 100.0, 20.0)),
                          ),
                          child: const Text("ලියාපදිංචි වන්න"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
