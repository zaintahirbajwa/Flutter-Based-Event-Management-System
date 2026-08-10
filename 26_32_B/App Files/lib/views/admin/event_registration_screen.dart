import 'package:flutter/material.dart';
import 'package:event_management_system/views/components/custom_button.dart';
import 'package:event_management_system/views/components/custom_text_field.dart';
import 'package:event_management_system/models/event_model.dart';
import 'package:event_management_system/services/firebase_storage_service.dart';
import 'package:event_management_system/utils/constants.dart';
import 'package:event_management_system/utils/theme.dart';
import 'package:intl/intl.dart';

class EventRegistrationScreen extends StatefulWidget {
  const EventRegistrationScreen({super.key});

  @override
  _EventRegistrationScreenState createState() =>
      _EventRegistrationScreenState();
}

class _EventRegistrationScreenState extends State<EventRegistrationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _eventDescriptionController =
      TextEditingController();
  final TextEditingController _ticketQuantityController =
      TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _organizerNameController =
      TextEditingController();
  final TextEditingController _organizerContactController =
      TextEditingController();

  DateTime? _eventDate;
  TimeOfDay? _eventTime;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _eventDate = picked;
        _dateController.text = DateFormat('MMM dd, yyyy').format(_eventDate!);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _eventTime = picked;
        _timeController.text = _eventTime!.format(context);
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      if (_eventDate == null || _eventTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select both date and time.")),
        );
        return;
      }

      final DateTime eventDateTime = DateTime(
        _eventDate!.year,
        _eventDate!.month,
        _eventDate!.day,
        _eventTime!.hour,
        _eventTime!.minute,
      );

      // Allow events for the present or future
      final DateTime now = DateTime.now();
      if (eventDateTime.isBefore(now.subtract(const Duration(minutes: 1)))) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text("Event date and time must be in the present or future."),
          ),
        );
        return;
      }

      final event = EventModel(
        id: UniqueKey().toString(),
        name: _eventNameController.text,
        description: _eventDescriptionController.text,
        date: eventDateTime,
        location: _locationController.text,
        totalTickets: int.tryParse(_ticketQuantityController.text) ?? 0,
        ticketsSold: 0,
        organizerName: _organizerNameController.text,
        organizerContact: _organizerContactController.text,
      );

      try {
        await FirestoreService().saveEvent(event);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppConstants.eventRegistered)),
        );
        _clearFields();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Error saving event. Please try again later.')),
        );
      }
    }
  }

  void _clearFields() {
    _eventNameController.clear();
    _eventDescriptionController.clear();
    _ticketQuantityController.clear();
    _locationController.clear();
    _dateController.clear();
    _timeController.clear();
    _organizerNameController.clear();
    _organizerContactController.clear();
    _eventDate = null;
    _eventTime = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.eventRegistrationTitle),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
                        controller: _eventNameController,
                        label: AppConstants.eventTitle,
                        validator: (value) => value?.isEmpty ?? true
                            ? AppConstants.emptyFieldError
                            : null,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _eventDescriptionController,
                        label: AppConstants.eventDescriptionLabel,
                        validator: (value) => value?.isEmpty ?? true
                            ? AppConstants.emptyFieldError
                            : null,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _ticketQuantityController,
                        label: AppConstants.ticketQuantityLabel,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return AppConstants.ticketQuantityError;
                          }
                          final quantity = int.tryParse(value!);
                          return (quantity == null || quantity <= 0)
                              ? "Enter a valid number."
                              : null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _locationController,
                        label: AppConstants.eventLocation,
                        validator: (value) => value?.isEmpty ?? true
                            ? AppConstants.emptyFieldError
                            : null,
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: AbsorbPointer(
                          child: CustomTextField(
                            controller: _dateController,
                            label: AppConstants.eventDateLabel,
                            validator: (value) => value?.isEmpty ?? true
                                ? AppConstants.eventDateError
                                : null,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () => _selectTime(context),
                        child: AbsorbPointer(
                          child: CustomTextField(
                            controller: _timeController,
                            label: "Event Time",
                            validator: (value) =>
                                value?.isEmpty ?? true ? "Select event time." : null,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _organizerNameController,
                        label: "Organizer Name",
                        validator: (value) =>
                            value?.isEmpty ?? true ? "Enter organizer name." : null,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _organizerContactController,
                        label: "Organizer Contact",
                        validator: (value) =>
                            value?.isEmpty ?? true ? "Enter contact info." : null,
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          text: AppConstants.registerEventButtonText,
                          onPressed: _submitForm,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
