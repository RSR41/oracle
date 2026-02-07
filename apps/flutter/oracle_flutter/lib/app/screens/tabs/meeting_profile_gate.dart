import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MeetingProfileGate extends StatelessWidget {
  const MeetingProfileGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('인연 찾기')),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.account_circle_outlined,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 24),
            const Text(
              '사주 프로필이 필요합니다',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              '정확한 사주 기반 인연 추천을 받으려면\n먼저 사주 프로필을 생성해 주세요.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 40),
            FilledButton.icon(
              onPressed: () => context.push('/onboarding'),
              icon: const Icon(Icons.edit_note),
              label: const Text('사주 프로필 만들기'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
