import 'package:flutter/material.dart';
import 'package:health_mate/components/light_color.dart';

import '../models/chat_user.dart';
import '../models/doctor_user.dart';
import 'book_appointment_page.dart';

class DoctorDetailsPage extends StatelessWidget {
  final DoctorUser doctor;
  final ChatUser user;

  const DoctorDetailsPage({super.key, required this.doctor, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDoctorCard(context),
            _buildAboutDoctorSection(),
            _buildLocationSection(context),
            _buildBookAppointmentButton(context),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text("Doctor Details"),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            // Handle options icon click
          },
        ),
      ],
    );
  }

  Widget _buildDoctorCard(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(100),
          bottomRight: Radius.circular(100),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: NetworkImage(doctor.image),
          ),
          const SizedBox(height: 10),
          Text(
            "Dr. ${doctor.name}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            doctor.specialization,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCircularCard(Icons.phone, Theme.of(context).primaryColor, context),
              const SizedBox(width: 20),
              _buildCircularCard(Icons.chat, Theme.of(context).primaryColor, context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCircularCard(IconData icon, Color color, BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Icon(
        icon,
        color: color,
        size: 30,
      ),
    );
  }

  Widget _buildAboutDoctorSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "About Doctor",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            doctor.description,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Location",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          // Add a map widget here to display the hospital location
          // You can use packages like google_maps_flutter for this
          // Example: GoogleMap(...),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildLocationCard(context),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hospital Name",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Hospital Address",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        color: LightColor.iconColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Icon(
        Icons.location_on,
        color: Theme.of(context).primaryColor,
        size: 30,
      ),
    );
  }

  Widget _buildBookAppointmentButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookAppointmentPage(chatUser: user, selectedDoctor: doctor),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
        ),
        child: const Text(
          "Book Appointment",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
