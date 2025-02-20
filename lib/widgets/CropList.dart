import 'package:flutter/material.dart';

import '../models/crop.dart';

class CropList extends StatelessWidget {
  final Future<List<Crop>>
      crops; // Get crops from your service (e.g., CropService.getCrops())

  const CropList({Key? key, required this.crops}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop List'),
      ),
      body: FutureBuilder<List<Crop>>(
        future: crops,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final crops = snapshot.data!;
            return ListView.builder(
              itemCount: crops.length,
              itemBuilder: (context, index) {
                final crop = crops[index];
                return ListTile(
                  title: Text(crop.name),
                  subtitle: Text(crop.farmingtype),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CropDetail(crop: crop),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // Display a loading indicator while fetching crops
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class CropDetail extends StatelessWidget {
  final Crop crop;

  const CropDetail({Key? key, required this.crop}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(crop.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Name: ${crop.name}'),
            Text('Farming Type: ${crop.farmingtype}'),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditCrop(crop: crop),
                    ),
                  ),
                  child: const Text('Edit'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Call deleteCrop function from your service (e.g., CropService.deleteCrop(crop.id!))
                    // Handle success or error appropriately (e.g., show a confirmation dialog or snackbar)
                  },
                  child: const Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EditCrop extends StatefulWidget {
  final Crop crop;

  const EditCrop({Key? key, required this.crop}) : super(key: key);

  @override
  State<EditCrop> createState() => _EditCropState();
}

class _EditCropState extends State<EditCrop> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _farmingTypeController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.crop.name);
    _farmingTypeController =
        TextEditingController(text: widget.crop.farmingtype);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _farmingTypeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Crop'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a name' : null,
              ),
              TextFormField(
                controller: _farmingTypeController,
                decoration: const InputDecoration(labelText: 'Farming Type'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a farming type' : null,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final updatedCrop = Crop(
                      name: _nameController.text,
                      farmingtype: _farmingTypeController.text,
                      id: widget.crop.id, // Maintain existing ID
                    );

                    // Call updateCrop function from your service (e.g., CropService.updateCrop(updatedCrop))
                    // Handle success or error appropriately (e.g., show a confirmation dialog or snackbar)
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
