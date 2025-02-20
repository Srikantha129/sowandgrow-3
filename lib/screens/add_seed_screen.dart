import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sowandgrow/service/seed_service.dart';

import '../models/seed.dart';
import '../models/user.dart';

class AddSeed extends StatefulWidget {
  final User user;
  const AddSeed({required this.user});

  @override
  _AddSeedState createState() => _AddSeedState();
}

class _AddSeedState extends State<AddSeed> {
  final _formKey = GlobalKey<FormState>();
  String _seedName = '';
  double _seedPrice = 0.00;
  int _seedStock = 0;
  double _percentage = 0.00;
  String imageUrl = '';
  String selectedFarmingAreaValue = "";
  String selectedFarmingTypeValue = "";
  String errorMessagedropdownFarmingArea = "";
  String errorMessagedropdownFarmingType = "";
  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        pickedFile = result.files.first;
      });
    }
  }

  Future<String> _uploadImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      Uint8List? bytes;
      if (kIsWeb) {
        // For web platform
        final data = await pickedFile.readAsBytes();
        bytes = data.buffer.asUint8List();
      } else {
        // For mobile platforms
        final file = File(pickedFile.path);
        bytes = await file.readAsBytes();
      }

      final storageRef =
          FirebaseStorage.instance.ref().child('files/${pickedFile.name}');
      final uploadTask = storageRef.putData(bytes!);

      final snapshot = await uploadTask.whenComplete(() => () {});
      final urlDownload = await snapshot.ref.getDownloadURL();
      print('downloadLink: $urlDownload');
      return urlDownload;
    } else {}
    return "";
  }

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>> dropdownFarmingAreaItems = [
      const DropdownMenuItem(
        value: "",
        child: Text(
          "ගොවිතැන් ප්‍රදේශය තෝරන්න",
          style: TextStyle(color: Colors.white),
        ),
      ),
      const DropdownMenuItem(
        value: "Ampara",
        child: Text("අම්පාර"),
      ),
      const DropdownMenuItem(
        value: "Anuradhapura",
        child: Text("අනුරාධපුර"),
      ),
      const DropdownMenuItem(
        value: "Badulla",
        child: Text("බදුල්ල"),
      ),
      const DropdownMenuItem(
        value: "Batticaloa",
        child: Text("මඩකලපුව"),
      ),
      const DropdownMenuItem(
        value: "Colombo",
        child: Text("කොළඹ"),
      ),
      const DropdownMenuItem(
        value: "Galle",
        child: Text("ගාල්ල"),
      ),
      const DropdownMenuItem(
        value: "Gampaha",
        child: Text("ගම්පහ"),
      ),
      const DropdownMenuItem(
        value: "Hambantota",
        child: Text("හම්බන්තොට"),
      ),
      const DropdownMenuItem(
        value: "Jaffna",
        child: Text("යාපනය"),
      ),
      const DropdownMenuItem(
        value: "Kalutara",
        child: Text("කලුතර"),
      ),
      const DropdownMenuItem(
        value: "Kandy",
        child: Text("මහනුවර"),
      ),
      const DropdownMenuItem(
        value: "Kegalle",
        child: Text("කෑගල්ල"),
      ),
      const DropdownMenuItem(
        value: "Kilinochchi",
        child: Text("කිලිනොච්චි"),
      ),
      const DropdownMenuItem(
        value: "Kurunegala",
        child: Text("කුරුණෑගල"),
      ),
      const DropdownMenuItem(
        value: "Mannar",
        child: Text("මන්නාරම"),
      ),
      const DropdownMenuItem(
        value: "Matale",
        child: Text("මාතලේ"),
      ),
      const DropdownMenuItem(
        value: "Matara",
        child: Text("මාතර"),
      ),
      const DropdownMenuItem(
        value: "Monaragala",
        child: Text("මොණරාගල"),
      ),
      const DropdownMenuItem(
        value: "Mullaitivu",
        child: Text("මුලතිව්"),
      ),
      const DropdownMenuItem(
        value: "Nuwara Eliya",
        child: Text("නුවරඑළිය"),
      ),
      const DropdownMenuItem(
        value: "Polonnaruwa",
        child: Text("පොලොන්නරුව"),
      ),
      const DropdownMenuItem(
        value: "Puttalam",
        child: Text("පුත්තලම"),
      ),
      const DropdownMenuItem(
        value: "Ratnapura",
        child: Text("රත්නපුර"),
      ),
      const DropdownMenuItem(
        value: "Trincomalee",
        child: Text("ත්‍රිකුණාමලය"),
      ),
      const DropdownMenuItem(
        value: "Vavuniya",
        child: Text("වවුනියාව"),
      ),
    ];

    List<DropdownMenuItem<String>> dropdownFarmingTypeItems = [
      const DropdownMenuItem(
          value: "",
          child:
              Text("බෝග වර්ගය තෝරන්න", style: TextStyle(color: Colors.white))),
      const DropdownMenuItem(value: "Paddy", child: Text("වී")),
      const DropdownMenuItem(value: "Other", child: Text("අනෙකුත් බීජ")),
      const DropdownMenuItem(value: "Both", child: Text("බීජ දෙවර්ගයම")),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "බීජ එකතු කිරීමේ පුවරුව",
          style: TextStyle(fontSize: 14.0),
        ),
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'බීජයේ නම',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'කරුණාකර බීජ නාමයක් ඇතුළත් කරන්න';
                        }
                        return null;
                      },
                      onSaved: (newValue) => _seedName = newValue!,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'බීජ කිලෝවක මිල(රු.)',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'කරුණාකර වලංගු මිලක් ඇතුළත් කරන්න';
                        }
                        try {
                          double.parse(value);
                          return null;
                        } on FormatException {
                          return 'කරුණාකර වලංගු මිලක් ඇතුළත් කරන්න';
                        }
                      },
                      onSaved: (newValue) =>
                          _seedPrice = double.parse(newValue!),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'බීජ තොගයේ ප්‍රමාණය (කිලෝග්‍රෑම්)',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'කරුණාකර බීජ තොග ඇතුලත් කරන්න';
                        }
                        try {
                          double.parse(value);
                          return null;
                        } on FormatException {
                          return 'කරුණාකර අංකයක් ඇතුළු කරන්න';
                        }
                      },
                      onSaved: (newValue) => _seedStock = int.parse(newValue!),
                      style: const TextStyle(color: Colors.white),
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
                      style: const TextStyle(color: Colors.black),
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: selectedFarmingTypeValue,
                      decoration: InputDecoration(
                        errorText: errorMessagedropdownFarmingType.isEmpty
                            ? null
                            : errorMessagedropdownFarmingType,
                      ),
                      items: dropdownFarmingTypeItems,
                      onChanged: (newFarmingTypeValue) {
                        setState(() {
                          selectedFarmingTypeValue = newFarmingTypeValue!;
                        });
                      },
                      style: const TextStyle(color: Colors.black),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'වට්ටම් ප්‍රතිශතය',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'කරුණාකර බීජ වට්ටම් ප්‍රතිශතයක් ඇතුළත් කරන්න';
                        }
                        try {
                          double.parse(value);
                          return null;
                        } on FormatException {
                          return 'කරුණාකර වලංගු ප්‍රතිශත අංක ඇතුලත් කරන්න';
                        }
                      },
                      onSaved: (newValue) =>
                          _percentage = double.parse(newValue!),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    // ElevatedButton(
                    //   onPressed: _pickImage,
                    //   child: const Text('Pick Image'),
                    // ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          imageUrl = await _uploadImage();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('ඡායාරූපය සාර්ථකව එක් කරන ලදී'),
                            ),
                          );
                        }
                      },
                      child: const Text('ඡායාරූපයක් එක් කරන්න'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          print('imageUrl : $imageUrl');
                          Seed newSeed = Seed(
                            name: _seedName,
                            price: _seedPrice,
                            stock: _seedStock,
                            farmingarea: selectedFarmingAreaValue,
                            farmingtype: selectedFarmingTypeValue,
                            supplier: widget.user.username,
                            percentage: _percentage,
                            status: 'Available',
                            image: imageUrl,
                            id: DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString() +
                                Random().nextInt(1000).toString(),
                          );
                          try {
                            await SeedService().saveSeed(newSeed);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('බීජ සාර්ථකව එකතු කරන ලදී!'),
                              ),
                            );
                            Navigator.pop(context);
                            setState(() {});
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'බීජ එකතු කිරීමේදී දෝෂයක් ඇති විය: $e'),
                              ),
                            );
                          }
                        }
                      },
                      child: const Text('බීජ එකතු කරන්න'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
