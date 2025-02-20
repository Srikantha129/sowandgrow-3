import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sowandgrow/screens/admin_dashboard.dart';
import 'package:sowandgrow/screens/farmer_signup_page.dart';
import 'package:sowandgrow/screens/supplier_dashboard.dart';
import 'package:sowandgrow/screens/supplier_signup_page.dart';
import 'package:sowandgrow/service/user_service.dart';

import '../models/user.dart';
import '../provider/user_provider.dart';
import 'agent_dashboard.dart';
import 'farmer_dashboard.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String errorMessage = "";
  String? userRole;
  Color errorMessageTextColor = Colors.yellowAccent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            labelStyle: const TextStyle(color: Colors.white),
                            labelText: "පරිශීලක නාමය",
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
                            labelStyle: const TextStyle(color: Colors.white),
                            labelText: "මුරපදය",
                            errorText: errorMessage.isEmpty ? null : errorMessage,
                            errorStyle: TextStyle(color: errorMessageTextColor),
                          ),
                          style: const TextStyle(color: Colors.white),
                          obscureText: true,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            if (_usernameController.text.isEmpty ||
                                _passwordController.text.isEmpty) {
                              setState(() {
                                errorMessage = "පරිශීලක නාමය සහ මුරපදය අවශ්‍ය වේ";
                              });
                            } else {
                              setState(() {
                                errorMessage = ""; // Clear previous error messages
                              });
                              if (_usernameController.text == "admin" &&
                                  _passwordController.text == "admin") {
                                Navigator.push(
                                  context, // Current context
                                  MaterialPageRoute(
                                      builder: (context) => const AdminDashboard()),
                                );
                              } else {
                                userRole = await UserService().loginCheck(
                                    _usernameController.text,
                                    _passwordController.text);
                                if (userRole != null) {
                                  print( 'Login successful! User role: $userRole');
                                  User user = User(
                                      username: _usernameController.text,
                                      password: _passwordController.text,
                                      farmingarea: '',
                                      farmingtype: '',
                                      userrole: userRole.toString(),
                                      status: '',
                                      nic: '',
                                      isfarming: 'false');
                                  Provider.of<UserProvider>(context, listen: false).setUser(user);
                                  if (userRole == "Farmer") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute( builder: (context) => FarmerDashboard(user: user)),
                                    );
                                  } else if (userRole == "Supplier") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute( builder: (context) => SupplierDashboard(user: user)),
                                    );
                                  } else if (userRole == "Agent") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute( builder: (context) => AgentDashboard(user: user)),
                                    );
                                  } else {
                                    print("Invalid Userrole");
                                  }
                                } else {
                                  print('Login failed!');
                                  setState(() {
                                    errorMessage = "පරිශීලක නාමය හෝ මුරපදය වලංගු නොවේ";
                                  });
                                }
                              }
                            }
                          },
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.fromLTRB( 60.0, 20.0, 60.0, 20.0)),
                            backgroundColor: MaterialStateProperty.all(
                                const Color.fromARGB(120, 0, 0, 0)),
                          ),
                          child: const Text( "ඇතුල් වන්න",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text( "ඔබට ගිණුමක් නොමැතිනම්",
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 20),
                        // SIGN UP AS FARMER
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context, // Current context
                              MaterialPageRoute( builder: (context) => const FarmerSignUpPage()),
                            );
                          },
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                              const EdgeInsets.fromLTRB(60.0, 20.0, 60.0, 20.0),
                            ),
                            backgroundColor: MaterialStateProperty.all(
                                const Color.fromARGB(120, 0, 0, 0)),
                          ),
                          child: const Text( "ගොවියෙකු ලෙස ලියාපදිංචි වන්න",
                            style: TextStyle(color: Colors.white, fontSize: 13.0),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // SIGN UP AS SUPPLIER
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const SupplierSignUpPage()),
                            );
                          },
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                              const EdgeInsets.fromLTRB(60.0, 20.0, 60.0, 20.0),
                            ),
                            backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(120, 0, 0, 0),
                            ),
                          ),
                          child: const Text( "සැපයුම්කරු ලෙස ලියාපදිංචි වන්න",
                            style: TextStyle(color: Colors.white, fontSize: 13.0),
                            textAlign: TextAlign.center,
                          ),
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
