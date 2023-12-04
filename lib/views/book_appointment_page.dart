import 'package:flutter/material.dart';
import 'package:health_mate/controllers/doctor_service.dart';
import 'package:health_mate/models/appointment_slot.dart';

import '../models/appointment.dart';
import '../models/chat_user.dart';
import '../models/doctor_user.dart';

class BookAppointmentPage extends StatefulWidget {
  final ChatUser chatUser;
  final DoctorUser selectedDoctor;

  BookAppointmentPage({required this.chatUser, required this.selectedDoctor});

  @override
  _BookAppointmentPageState createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentPage> {
  DateTime selectedDateTime = DateTime.now();

  void _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (picked != null && picked != selectedDateTime) {
      setState(() {
        selectedDateTime = DateTime(picked.year, picked.month, picked.day, selectedDateTime.hour, selectedDateTime.minute);
      });
    }
  }

  void _selectTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDateTime),
    );

    if (picked != null) {
      setState(() {
        selectedDateTime = DateTime(selectedDateTime.year, selectedDateTime.month, selectedDateTime.day, picked.hour, picked.minute);
      });
    }
  }

  void _confirmAppointment() async {
    AppointmentSlot newAppointment = AppointmentSlot(dateTime: selectedDateTime);
    Appointment appointment = Appointment(slot: newAppointment, doctor: widget.selectedDoctor.name, patient: widget.chatUser.name);
    widget.selectedDoctor.appointments.add(appointment);

    try {
      DoctorService().updateDoctor(widget.selectedDoctor);

      Navigator.pop(context);
    } catch (e) {
      print('Error updating doctor schedule: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Appointment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _selectDate,
              child: Text('Select Date: ${selectedDateTime.toLocal().toString().split(' ')[0]}'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _selectTime,
              child: Text('Select Time: ${selectedDateTime.toLocal().toString().split(' ')[1]}'),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _confirmAppointment,
              child: Text('Confirm Appointment'),
            ),
          ],
        ),
      ),
    );
  }
}
