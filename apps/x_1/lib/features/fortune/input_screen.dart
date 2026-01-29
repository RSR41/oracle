import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:x_1/features/fortune/fortune_provider.dart';
import 'package:x_1/shared/domain/models/profile.dart';
import 'package:x_1/router/app_router.dart';
import 'package:intl/intl.dart';

class InputScreen extends ConsumerStatefulWidget {
  const InputScreen({super.key});

  @override
  ConsumerState<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends ConsumerState<InputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  DateTime _selectedDate = DateTime(1990, 1, 1);
  TimeOfDay? _selectedTime = const TimeOfDay(hour: 12, minute: 0);
  bool _isUnknownTime = false;
  String _gender = 'M'; // M, F
  bool _isSolar = true;
  bool _isLeapMonth = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    if (_isUnknownTime) return;

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final profile = Profile(
        name: _nameController.text,
        birthDate: DateFormat('yyyy-MM-dd').format(_selectedDate),
        birthTime: _isUnknownTime
            ? '00:00'
            : '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}',
        isUnknownTime: _isUnknownTime,
        gender: _gender,
        isSolar: _isSolar,
        isLeapMonth: _isLeapMonth,
      );

      // Use await to ensure data is saved before navigation
      ref.read(fortuneProvider.notifier).setProfile(profile).then((_) {
        if (mounted) context.push(AppRoute.result.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Birth Info')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Date
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date of Birth',
                    prefixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    DateFormat('yyyy-MM-dd').format(_selectedDate),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Time
              InkWell(
                onTap: () => _selectTime(context),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Time of Birth',
                    prefixIcon: const Icon(Icons.access_time),
                    border: const OutlineInputBorder(),
                    enabled: !_isUnknownTime,
                  ),
                  child: Text(
                    _isUnknownTime
                        ? 'Unknown Time'
                        : _selectedTime!.format(context),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: _isUnknownTime ? Colors.grey : null,
                        ),
                  ),
                ),
              ),
              CheckboxListTile(
                title: const Text('Unknown Time'),
                value: _isUnknownTime,
                onChanged: (value) {
                  setState(() {
                    _isUnknownTime = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 16),

              // Gender
              const Text('Gender',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(
                      value: 'M', label: Text('Male'), icon: Icon(Icons.male)),
                  ButtonSegment(
                      value: 'F',
                      label: Text('Female'),
                      icon: Icon(Icons.female)),
                ],
                selected: {_gender},
                onSelectionChanged: (Set<String> newSelection) {
                  setState(() {
                    _gender = newSelection.first;
                  });
                },
              ),
              const SizedBox(height: 24),

              // Calendar Type
              const Text('Calendar Type',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(value: true, label: Text('Solar')),
                  ButtonSegment(value: false, label: Text('Lunar')),
                ],
                selected: {_isSolar},
                onSelectionChanged: (Set<bool> newSelection) {
                  setState(() {
                    _isSolar = newSelection.first;
                  });
                },
              ),

              if (!_isSolar) ...[
                const SizedBox(height: 8),
                CheckboxListTile(
                  title: const Text('Leap Month'),
                  value: _isLeapMonth,
                  onChanged: (value) {
                    setState(() {
                      _isLeapMonth = value ?? false;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),
              ],

              const SizedBox(height: 32),

              // Submit
              SizedBox(
                height: 56,
                child: FilledButton(
                  onPressed: _submit,
                  child: const Text('View Result'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
