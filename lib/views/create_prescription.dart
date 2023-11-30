import 'dart:io';

import 'package:dotted_line/dotted_line.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:health_mate/components/extensions.dart';
import 'package:health_mate/components/text_styles.dart';

import '../models/data.dart';

class CreatePrescription extends StatefulWidget {
  const CreatePrescription({Key? key, required user}) : super(key: key);

  @override
  CreatePrescriptionState createState() => CreatePrescriptionState();
}

class CreatePrescriptionState extends State<CreatePrescription> {

  final TextEditingController _searchController = TextEditingController();
  final List<String> _selectedMedicines = [];
  List<String> _searchResults = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Create Prescription'),
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Button to upload prescription
                        Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              try {
                                FilePickerResult? prescriptionPdf = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

                                if (prescriptionPdf != null) {
                                  // Handle the picked file
                                  String filePath = prescriptionPdf.files.single.path!;
                                  print('File path: $filePath');

                                  _uploadPrescriptionToFirebase(prescriptionPdf);

                                  Navigator.pop(context);

                                  // Add your logic to process the picked file
                                } else {
                                  // User canceled the file picker
                                  print('File picking canceled.');
                                }
                              } catch (e) {
                                // Handle any errors that occurred during file picking
                                print('Error picking file: $e');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context)
                                  .primaryColor, // Match the theme color
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Upload Prescription',
                              style: TextStyles.body.bold.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // "OR" text
                        Center(
                          child: Text(
                            'OR',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: FontSizes.title),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Heading for prescription form
                        Text(
                          'Fill the Prescription',
                          style: TextStyles.title.bold,
                        ),
                        const SizedBox(height: 16),
                        // Container for Treatment Name
                        _buildTextFieldContainer(
                          icon: Icons.favorite,
                          hintText: 'Treatment Name',
                        ),
                        const SizedBox(height: 16),
                        // Container for Doctor's Phone Number
                        _buildTextFieldContainer(
                          icon: Icons.phone,
                          hintText: 'Phone Number',
                        ),
                        const SizedBox(height: 16),
                        // Container for Disease Name
                        _buildTextFieldContainer(
                          icon: Icons.coronavirus_outlined,
                          hintText: 'Disease Name',
                        ),
                        const SizedBox(height: 16),
                        // Container for Course Duration
                        _buildTextFieldContainer(
                          icon: Icons.access_time_rounded,
                          hintText: 'Course Duration',
                        ),
                        const SizedBox(height: 16),
                        // Heading for medicine search
                        Text(
                          'Search Medicine',
                          style: TextStyles.title.bold,
                        ),
                        const SizedBox(height: 16),
                        // Container for Search bar
                        _buildSearchBar(),
                        Card(
                          child: SizedBox(
                            height: 180,
                            child: ListView.builder(
                              itemCount: _searchResults.length,
                              itemBuilder: (context, index) {
                                final medicine = _searchResults[index];
                                final isMedicineSelected =
                                    _selectedMedicines.contains(medicine);
                                return ListTile(
                                  title: Text(medicine),
                                  trailing: isMedicineSelected
                                      ? IconButton(
                                          icon: const Icon(
                                              Icons.highlight_remove_rounded,
                                              color: Colors.red),
                                          onPressed: () {
                                            setState(() {
                                              _selectedMedicines
                                                  .remove(medicine);
                                            });
                                          },
                                        )
                                      : IconButton(
                                          icon: const Icon(Icons.add_circle_outline_rounded,
                                              color: Colors.green),
                                          onPressed: () {
                                            setState(() {
                                              _selectedMedicines.add(medicine);
                                            });
                                          },
                                        ),
                                  onTap: () {
                                    // Handle the selection of the medicine
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildPrescriptionCards(),
                        const SizedBox(height: 16),
                        Text(
                          'Add Note',
                          style: TextStyles.title.bold,
                        ),
                        const SizedBox(height: 16,),
                        const TextField(
                          maxLength: 200,
                          maxLines: 5,
                          decoration: InputDecoration(
                            hintText: 'Add a note up to 200 characters',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                        ),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              // Add functionality to handle prescription upload
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context)
                                  .primaryColor, // Match the theme color
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Send Prescription',
                              style: TextStyles.body.bold.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Future<String?> _uploadPrescriptionToFirebase(FilePickerResult? prescriptionPdf) async {
    if (prescriptionPdf == null) return null;

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return null;

    final firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('prescriptions/${currentUser.displayName}/${prescriptionPdf.files.single!.name}');

    try {
      final uploadTask = await firebaseStorageRef.putFile(File(prescriptionPdf.files.single.path!));
      if (uploadTask.state == TaskState.success) {
        final downloadUrl = await firebaseStorageRef.getDownloadURL();
        print("Uploaded to: $downloadUrl");
        return downloadUrl;
      }
    } catch (e) {
      print("Failed to upload image: $e");
    }
    return null;
  }

  Widget _buildPrescriptionCards() {
    List<Widget> cards = [];

    for (String medicine in _selectedMedicines) {
      cards.add(_buildPrescriptionCard(medicine).wrapWithDecoration());
      cards.add(const SizedBox(
        height: 16,
      ));
    }

    return Column(
      children: cards,
    );
  }

  Widget _buildPrescriptionCard(var medicine) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 7),
              title: Text(
                medicine,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.highlight_remove_rounded,
                    color: Colors.red),
                onPressed: () {
                  setState(() {
                    _selectedMedicines.remove(medicine);
                  });
                },
              ),
            ),
            const DottedLine(
              direction: Axis.horizontal,
              // or Axis.vertical for a vertical line
              lineLength: double.infinity,
              // Use double.infinity for a line that spans the full width/height
              lineThickness: 1.0,
              // Adjust the thickness of the dotted line
              dashLength: 10.0,
              // Adjust the length of each dash
              dashColor: Colors.black, // Specify the color of the dots
            ),
            const SizedBox(
              height: 16,
            ),
            _buildRowWithTextField('Quantity', '1 tablet'),
            const SizedBox(
              height: 16,
            ),
            _buildRowWithTextField('Usage', 'on empty stomach'),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCheckboxWithText(medicine, 'Morning'),
                const Spacer(),
                _buildCheckboxWithText(medicine, 'Afternoon'),
                const Spacer(),
                _buildCheckboxWithText(medicine, 'Evening'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRowWithTextField(String labelText, String hintText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 80.0, // Adjust the width as needed
          child: Text(
            labelText,
            style: const TextStyle(
              fontSize: 16.0,
            ),
          ),
        ),
        Expanded(
            child: Container(
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: Theme.of(context).primaryColor,
              width: 1.0,
            ),
          ),
          child: TextField(
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              border: InputBorder.none,
              hintText: hintText,
            ),
          ),
        ))
      ],
    );
  }

  Widget _buildCheckboxWithText(String medicine, String labelText) {
    return Row(
      children: [
        Text(
          labelText,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        Transform.scale(
          scale: 0.7,
          child: createCheckBox(medicine, labelText),
        ),
      ],
    );
  }

  Widget createCheckBox(String medicine, String labelText) {
    switch (labelText) {
      case 'Morning':
        return Checkbox(
          value: medicines[medicine]?['Morning'],
          onChanged: (value) {
            setState(() {
              // isMorningChecked = value!;
              medicines[medicine]?['Morning'] = value!;
            });
          },
        );
      case 'Afternoon':
        return Checkbox(
          value: medicines[medicine]?['Afternoon'],
          onChanged: (value) {
            setState(() {
              // isAfternoonChecked = value!;
              medicines[medicine]?['Afternoon'] = value!;
            });
          },
        );
      default:
        return Checkbox(
          value: medicines[medicine]?['Evening'],
          onChanged: (value) {
            setState(() {
              // isEveningChecked = value!;
              medicines[medicine]?['Evening'] = value!;
            });
          },
        );
    }
  }

  // Helper method to build a container with an icon and a text field separated by a vertical bar
  Widget _buildTextFieldContainer(
      {required IconData icon, required String hintText}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Theme.of(context).primaryColor),
      ),
      child: Row(
        children: [
          // Icon and vertical bar
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                Icon(icon, color: Theme.of(context).primaryColor),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            height: 24,
            width: 1,
            color: Theme.of(context).primaryColor, // Vertical bar color
          ),
          const SizedBox(width: 16),
          // TextField
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build the search bar
  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Theme.of(context).primaryColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onTap: () => {},
              controller: _searchController,
              onChanged: _onSearchTextChanged,
              decoration: const InputDecoration(
                hintText: 'Search',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
              onPressed: () {
                _searchController.clear();
                _onSearchTextChanged('');
              },
              icon: const Icon(Icons.clear)),
          Container(
            height: 24,
            width: 1,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(
            width: 16,
          ),
          Icon(Icons.search, color: Theme.of(context).primaryColor),
        ],
      ),
    );
  }

  void _onSearchTextChanged(String value) {
    value = value.toLowerCase();
    setState(() {
      _searchResults = medicines.keys
          .where((medicine) => medicine.toLowerCase().contains(value))
          .toList();
    });
  }
}
