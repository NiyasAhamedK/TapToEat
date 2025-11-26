import 'package:flutter/material.dart';
import 'package:users_app/global/global_instances.dart';
import 'package:users_app/view/widgets/simple_text_field.dart';
import 'package:users_app/global/global_vars.dart';
import 'package:users_app/model/address.dart'; // Import the updated Address model

// IMPORT THE NEW BUILDING SELECTOR MODAL
import 'fixed_building_selector.dart';


class SaveAddressScreen extends StatefulWidget {
  const SaveAddressScreen({super.key});

  @override
  State<SaveAddressScreen> createState() => _SaveAddressScreenState();
}

class _SaveAddressScreenState extends State<SaveAddressScreen> {
  final _nameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // New State variables to hold the selected building data
  Address? _selectedBuilding;
  String _selectedBuildingID = '';

  // Removed: _locationController, placemarks, Position

  // NEW METHOD to open the fixed building selection modal
  void _selectBuilding() async {
    // Show the modal and await the user's selection
    final result = await showBuildingSelector(context);

    if (result != null) {
      setState(() {
        _selectedBuilding = result['model'] as Address;
        _selectedBuildingID = result['id'] as String;
      });
      commonViewModel.showSnackBar("Building selected: ${_selectedBuilding!.name ?? 'A location'}", context);
    }
  }

  // UPDATED SAVE METHOD (moved from FloatingActionButton)
  void _saveFinalAddress() {
    if (!formKey.currentState!.validate()) {
      return;
    }

    // Check if a building has been selected
    if (_selectedBuilding == null) {
      commonViewModel.showSnackBar("Please select a building location.", context);
      return;
    }

    // Call the updated ViewModel method with COMBINED data
    addressViewModel.saveShipmentAddressToDatabase(
        _nameController.text.trim(),                  // 1. User Input: Name
        _phoneNumberController.text.trim(),           // 2. User Input: Phone Number
        _selectedBuilding!.name ?? "N/A",             // 3. Fixed: Building Name
        _selectedBuildingID,                          // 4. Fixed: Building ID
        _selectedBuilding!.city ?? "",                // 5. Fixed: City
        _selectedBuilding!.state ?? "",               // 6. Fixed: State
        _selectedBuilding!.fullAddress ?? "",         // 7. Fixed: Full Address
        _selectedBuilding!.flatNumber ?? "",          // 8. Fixed: flatNumber/Unit from Building
        _selectedBuilding!.lat ?? 0.0,                // 9. Fixed: Lat
        _selectedBuilding!.lng ?? 0.0,                // 10. Fixed: Lng
        context
    ).then((_) {
      formKey.currentState!.reset();
      // Optional: Navigate back after saving
      Navigator.pop(context);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Address"),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),

      // Removed the FloatingActionButton and moved the save button into the body

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              // 1. NAME FIELD (User Input)
              SimpleTextField(
                hint: "Name",
                controller: _nameController,

              ),

              // 2. PHONE NUMBER FIELD (User Input)
              SimpleTextField(
                hint: "Phone Number",
                controller: _phoneNumberController,

              ),

              const SizedBox(height: 20),

              // 3. BUILDING SELECTOR BUTTON (New UI Element)
              InkWell(
                onTap: _selectBuilding,
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueGrey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.location_city, color: _selectedBuilding != null ? Colors.green : Colors.grey),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _selectedBuilding?.name ?? "Tap to Select Building",
                          style: TextStyle(
                            fontSize: 16,
                            color: _selectedBuilding != null ? Colors.white : Colors.grey[700],
                          ),
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Display Selected Address Summary
              if (_selectedBuilding != null)
                Text(
                  "Selected: ${_selectedBuilding!.fullAddress}, Unit: ${_selectedBuilding!.flatNumber}",
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),

              const SizedBox(height: 30),

              // 4. SAVE BUTTON (Replacing the FloatingActionButton)
              ElevatedButton.icon(
                label: const Text(
                  "Save Address",
                  style: TextStyle(color: Colors.white),
                ),
                icon: const Icon(Icons.save, color: Colors.white,),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _saveFinalAddress,
              ),

              // Removed: All original map/location and address text fields
              // Removed: The original "Get My Location" button
            ],
          ),
        ),
      ),
    );
  }
}