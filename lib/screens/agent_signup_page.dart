import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sowandgrow/models/user.dart';
import 'package:sowandgrow/service/user_service.dart';

import '../provider/user_provider.dart';
import 'agent_dashboard.dart';

class AgentSignUpPage extends StatefulWidget {
  const AgentSignUpPage({super.key});

  @override
  State<AgentSignUpPage> createState() => _AgentSignUpPageState();
}

class _AgentSignUpPageState extends State<AgentSignUpPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String errorMessage = "";
  String errorMessagedropdownFarmingArea = "";
  String errorMessagedropdownFarmingType = "";
  String selectedFarmingAreaValue = "";
  Color errorMessageTextColor = Colors.yellowAccent;

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>> dropdownFarmingAreaItems = [
      const DropdownMenuItem(
        value: "",
        child: Text(
          "වගා ප්‍රදේශය තෝරන්න",
          style: TextStyle(color: Colors.white),
        ),
      ),
      const DropdownMenuItem(
        value: "Gampaha",
        child: Text(
          "ගම්පහ",
          style: TextStyle(color: Colors.black),
        ),
      ),
      const DropdownMenuItem(
        value: "Kalutara",
        child: Text(
          "කලුතර",
          style: TextStyle(color: Colors.black),
        ),
      ),
      const DropdownMenuItem(
        value: "Colombo",
        child: Text(
          "කොළඹ",
          style: TextStyle(color: Colors.black),
        ),
      ),
      const DropdownMenuItem(
        value: "Kandy",
        child: Text(
          "මහනුවර",
          style: TextStyle(color: Colors.black),
        ),
      ),
      const DropdownMenuItem(
        value: "Matale",
        child: Text(
          "මාතලේ",
          style: TextStyle(color: Colors.black),
        ),
      ),
      const DropdownMenuItem(
        value: "Nuwara Eliya",
        child: Text(
          "නුවරඑළිය",
          style: TextStyle(color: Colors.black),
        ),
      ),
      const DropdownMenuItem(
        value: "Galle",
        child: Text(
          "ගාල්ල",
          style: TextStyle(color: Colors.black),
        ),
      ),
      const DropdownMenuItem(
        value: "Matara",
        child: Text(
          "මාතර",
          style: TextStyle(color: Colors.black),
        ),
      ),
      const DropdownMenuItem(
        value: "Hambantota",
        child: Text(
          "හම්බන්තොට",
          style: TextStyle(color: Colors.black),
        ),
      ),
      const DropdownMenuItem(
        value: "Jaffna",
        child: Text(
          "යාපනය",
          style: TextStyle(color: Colors.black),
        ),
      ),
      const DropdownMenuItem(
        value: "Kilinochchi",
        child: Text(
          "කිලිනොච්චි",
          style: TextStyle(color: Colors.black),
        ),
      ),
      const DropdownMenuItem(
        value: "Mannar",
        child: Text(
          "මන්නාරම",
          style: TextStyle(color: Colors.black),
        ),
      ),
      const DropdownMenuItem(
        value: "Vavuniya",
        child: Text(
          "වවුනියාව",
          style: TextStyle(color: Colors.black),
        ),
      ),
      const DropdownMenuItem(
        value: "Mullaitivu",
        child: Text(
          "මුලතිවු",
          style: TextStyle(color: Colors.black),
        ),
      ),
      const DropdownMenuItem(
        value: "Batticaloa",
        child: Text(
          "මඩකලපුව",
          style: TextStyle(color: Colors.black),
        ),
      ),
      const DropdownMenuItem(
        value: "Ampara",
        child: Text(
          "අම්පාර",
          style: TextStyle(color: Colors.black),
        ),
      ),
      const DropdownMenuItem(
        value: "Trincomalee",
        child: Text(
          "ත්‍රිකුණාමලය",
          style: TextStyle(color: Colors.black),
        ),
      ),
      const DropdownMenuItem(
        value: "Kurunegala",
        child: Text(
          "කුරුණෑගල",
          style: TextStyle(color: Colors.black),
        ),
      ),
      const DropdownMenuItem(
        value: "Puttalam",
        child: Text(
          "පුත්තලම",
          style: TextStyle(color: Colors.black),
        ),
      ),
      const DropdownMenuItem(
        value: "Anuradhapura",
        child: Text(
          "අනුරාධපුර",
          style: TextStyle(color: Colors.black),
        ),
      ),
      const DropdownMenuItem(
        value: "Polonnaruwa",
        child: Text(
          "පොළොන්නරුව",
          style: TextStyle(color: Colors.black),
        ),
      ),
      const DropdownMenuItem(
        value: "Badulla",
        child: Text(
          "බදුල්ල",
          style: TextStyle(color: Colors.black),
        ),
      ),
      const DropdownMenuItem(
        value: "Monaragala",
        child: Text(
          "මොනරාගල",
          style: TextStyle(color: Colors.black),
        ),
      ),
      const DropdownMenuItem(
        value: "Ratnapura",
        child: Text(
          "රත්නපුර",
          style: TextStyle(color: Colors.black),
        ),
      ),
      const DropdownMenuItem(
        value: "Kegalle",
        child: Text(
          "කෑගල්ල",
          style: TextStyle(color: Colors.black),
        ),
      ),
    ];


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
                            errorText:
                                errorMessage.isEmpty ? null : errorMessage,
                            errorStyle: TextStyle(color: errorMessageTextColor),
                          ),
                          style: const TextStyle(color: Colors.white),
                          obscureText: true,
                        ),
                        const SizedBox(height: 20),
                        DropdownButtonFormField<String>(
                          value: selectedFarmingAreaValue,
                          decoration: InputDecoration(
                            errorText: errorMessagedropdownFarmingArea.isEmpty
                                ? null
                                : errorMessagedropdownFarmingArea,
                          ),
                          items: dropdownFarmingAreaItems,
                          onChanged: (newFarmingAreaValue) {
                            setState(() {
                              selectedFarmingAreaValue = newFarmingAreaValue!;
                            });
                          },
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
                            }
                            if (selectedFarmingAreaValue.isEmpty) {
                              setState(() {
                                errorMessagedropdownFarmingArea =
                                    "කෘෂිකාර්මික ප්රදේශය අවශ්ය වේ";
                              });
                            } else {
                              setState(() {
                                errorMessagedropdownFarmingArea = "";
                              });
                            }
                              User user = User(
                                  username: _usernameController.text,
                                  password: _passwordController.text,
                                  farmingarea: selectedFarmingAreaValue,
                                  farmingtype: "",
                                  userrole: 'Agent',
                                  status: "Authorized",
                                  nic: '',
                                  isfarming: 'false'
                              );
                              if (await UserService()
                                  .checkUserExists(_usernameController.text)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('පරිශීලක නාමය දැනටමත් පවතී!!'),
                                  ),
                                );
                              } else {
                                await UserService().saveUser(user);
                                Provider.of<UserProvider>(context, listen: false).setUser(user);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('ගොවිජන නියාමකවරයා සාර්ථකව ලියාපදිංචි විය!!'),
                                  ),
                                );
                                await Future.delayed(
                                  const Duration(milliseconds: 1500),
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AgentDashboard(user: user),
                                  ),
                                );
                              }
                          },
                          style: ButtonStyle(
                            padding: WidgetStateProperty.all(
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
          ),
        ],
      ),
    );
  }
}
