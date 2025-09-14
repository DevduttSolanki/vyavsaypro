import 'package:flutter/material.dart';
import '../../widgets/gradient_app_bar.dart';

class NotificationsPage extends StatelessWidget {
  final String userId; // current user UID

  NotificationsPage({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: 'Notifications',
      ),
      body: StreamBuilder(
        // TODO: Connect to Firestore 'user_notifications' collection
        // Example: FirebaseFirestore.instance.collection('user_notifications')
        stream: null, // Replace with Firestore stream
        builder: (context, snapshot) {
          // TODO: Handle snapshot.hasData, snapshot.error
          // For now, dummy list
          List<Map<String, dynamic>> notifications = [
            {
              'title': 'Invoice Reminder',
              'message': 'Invoice INV-001 is due tomorrow.',
              'timestamp': DateTime.now()
            },
            {
              'title': 'Low Stock Alert',
              'message': 'Product "Paracetamol" stock is below threshold.',
              'timestamp': DateTime.now()
            },
          ];

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final item = notifications[index];
              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  leading: Icon(Icons.notifications, color: Colors.orange),
                  title: Text(item['title']),
                  subtitle: Text(item['message']),
                  trailing: Text(
                    "${item['timestamp'].hour}:${item['timestamp'].minute}",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  onTap: () {
                    // TODO: Mark as read or navigate
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
