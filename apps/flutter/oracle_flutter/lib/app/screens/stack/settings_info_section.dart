import 'package:flutter/material.dart';

class SettingsInfoSection extends StatelessWidget {
  const SettingsInfoSection({
    super.key,
    required this.appVersion,
    required this.contactEmail,
    required this.onShowTerms,
    required this.onShowPrivacy,
    required this.onShowOpenSourceLicenses,
    required this.onShowDataDeletionGuide,
  });

  final String appVersion;
  final String contactEmail;
  final VoidCallback onShowTerms;
  final VoidCallback onShowPrivacy;
  final VoidCallback onShowOpenSourceLicenses;
  final VoidCallback onShowDataDeletionGuide;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.gavel_outlined),
            title: const Text('이용약관'),
            trailing: const Icon(Icons.chevron_right),
            onTap: onShowTerms,
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('개인정보처리방침'),
            trailing: const Icon(Icons.chevron_right),
            onTap: onShowPrivacy,
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.contact_mail_outlined),
            title: const Text('문의 연락처'),
            subtitle: Text(contactEmail),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('앱 버전'),
            subtitle: Text(appVersion),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: const Text('데이터 삭제 안내'),
            subtitle: const Text('계정/데이터 삭제 전 유의사항을 확인하세요.'),
            trailing: const Icon(Icons.chevron_right),
            onTap: onShowDataDeletionGuide,
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.code_outlined),
            title: const Text('오픈소스 라이선스'),
            trailing: const Icon(Icons.chevron_right),
            onTap: onShowOpenSourceLicenses,
          ),
        ],
      ),
    );
  }
}
