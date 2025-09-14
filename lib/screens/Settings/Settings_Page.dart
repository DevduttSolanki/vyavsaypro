import 'package:flutter/material.dart';
import '../../widgets/gradient_app_bar.dart';

class SettingsPage extends StatefulWidget {
  final String userId; // pass the current user UID

  SettingsPage({required this.userId});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool darkMode = false;
  bool twoFactorEnabled = false;
  bool pinEnabled = false;
  bool backupEnabled = false;
  bool smsRemindersEnabled = false;
  String defaultLanguage = 'English';
  String reminderFrequency = '3_days';

  @override
  void initState() {
    super.initState();
    // TODO: Fetch user settings from Firestore
    // Example: Firestore.instance.collection('settings').doc(widget.userId)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: 'Settings',
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [

            // Default Language
            ListTile(
              title: Text('Default Language'),
              trailing: DropdownButton<String>(
                value: defaultLanguage,
                items: ['English', 'हिंदी', 'ગુજરાતી', 'मराठी']
                    .map((lang) => DropdownMenuItem(
                  value: lang,
                  child: Text(lang),
                ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    defaultLanguage = val!;
                    // TODO: Update Firestore
                  });
                },
              ),
            ),
            Divider(),

            // Dark Mode
            SwitchListTile(
              title: Text('Dark Mode'),
              value: darkMode,
              onChanged: (val) {
                setState(() {
                  darkMode = val;
                  // TODO: Update Firestore
                });
              },
            ),

            // Two Factor Authentication
            SwitchListTile(
              title: Text('Two Factor Authentication'),
              value: twoFactorEnabled,
              onChanged: (val) {
                setState(() {
                  twoFactorEnabled = val;
                  // TODO: Update Firestore
                });
              },
            ),

            // PIN Enabled
            SwitchListTile(
              title: Text('PIN Enabled'),
              value: pinEnabled,
              onChanged: (val) {
                setState(() {
                  pinEnabled = val;
                  // TODO: Update Firestore
                });
              },
            ),

            // Backup Enabled
            SwitchListTile(
              title: Text('Auto Backup'),
              value: backupEnabled,
              onChanged: (val) {
                setState(() {
                  backupEnabled = val;
                  // TODO: Update Firestore
                });
              },
            ),

            // SMS Reminders
            SwitchListTile(
              title: Text('SMS Reminders'),
              value: smsRemindersEnabled,
              onChanged: (val) {
                setState(() {
                  smsRemindersEnabled = val;
                  // TODO: Update Firestore
                });
              },
            ),

            // Reminder Frequency
            ListTile(
              title: Text('Reminder Frequency'),
              trailing: DropdownButton<String>(
                value: reminderFrequency,
                items: ['Daily', '3_days', 'Weekly', 'Monthly']
                    .map((freq) => DropdownMenuItem(
                  value: freq,
                  child: Text(freq),
                ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    reminderFrequency = val!;
                    // TODO: Update Firestore
                  });
                },
              ),
            ),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: Save all settings to Firestore
              },
              child: Text('Save Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
