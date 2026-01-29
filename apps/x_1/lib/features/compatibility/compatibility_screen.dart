import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_1/core/theme/app_colors.dart';
import 'package:x_1/features/fortune/fortune_provider.dart';
import 'package:x_1/core/utils/mock_fortune_service.dart';

class CompatibilityScreen extends ConsumerStatefulWidget {
  const CompatibilityScreen({super.key});

  @override
  ConsumerState<CompatibilityScreen> createState() =>
      _CompatibilityScreenState();
}

class _CompatibilityScreenState extends ConsumerState<CompatibilityScreen> {
  final _nameController = TextEditingController();
  DateTime _selectedDate = DateTime(1995, 1, 1);
  Map<String, dynamic>? _result;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _analyze() {
    final fortuneState = ref.read(fortuneProvider);
    final me = fortuneState.currentProfile;
    if (me == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please set your profile first')),
      );
      return;
    }

    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter partner name')),
      );
      return;
    }

    // Force UI update
    setState(() {
      _result = MockFortuneService.generateCompatibility(
          me, _nameController.text, _selectedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Compatibility')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // My Profile Card
            const Card(
              child: ListTile(
                leading: CircleAvatar(child: Icon(Icons.person)),
                title: Text('My Profile'),
                subtitle: Text('Selected in Profile Settings'),
                trailing: Icon(Icons.check_circle, color: Colors.green),
              ),
            ),
            const SizedBox(height: 16),

            // Partner Selection
            const Text('Partner Info',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Partner Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.people),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Partner Birth Date'),
              subtitle: Text(_selectedDate.toString().split(' ')[0]),
              trailing: const Icon(Icons.calendar_today),
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  setState(() => _selectedDate = picked);
                }
              },
            ),

            const SizedBox(height: 32),

            // Analyze Button
            SizedBox(
              height: 56,
              child: FilledButton(
                onPressed: _analyze,
                child: const Text('Analyze Compatibility'),
              ),
            ),

            if (_result != null) ...[
              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 16),

              // Mock Result
              Center(
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 150,
                          height: 150,
                          child: CircularProgressIndicator(
                            value: (_result!['score'] as int) / 100,
                            strokeWidth: 12,
                            backgroundColor: Colors.grey[200],
                            color: AppColors.luckyRed,
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              '${_result!['score']}',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge
                                  ?.copyWith(
                                    color: AppColors.luckyRed,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const Text('Score'),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      _result!['summary'] as String,
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
