// import 'package:flutter/material.dart';
//
// class AppDrawer extends StatelessWidget {
//   final String? ownerImageUrl;
//   final String businessName;
//
//   AppDrawer({
//     this.ownerImageUrl,
//     required this.businessName,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           DrawerHeader(
//             decoration: BoxDecoration(
//               color: Colors.blue,
//             ),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 // ✅ CircleAvatar for Owner Image
//                 CircleAvatar(
//                   radius: 30,
//                   backgroundColor: Colors.white,
//                   backgroundImage: ownerImageUrl != null
//                       ? NetworkImage(ownerImageUrl!)
//                       : null,
//                   child: ownerImageUrl == null
//                       ? Icon(Icons.person, size: 30, color: Colors.grey)
//                       : null,
//                 ),
//               ],
//             ),
//           ),
//
//           // Dashboard
//           ListTile(
//             leading: Icon(Icons.dashboard),
//             title: Text('Dashboard'),
//             onTap: () {
//               Navigator.pushNamed(context, '/dashboard');
//             },
//           ),
//
//           Divider(),
//
//           // Inventory
//           ListTile(
//             leading: Icon(Icons.inventory),
//             title: Text('Inventory'),
//             onTap: () {
//               Navigator.pushNamed(context, '/inventory');
//             },
//           ),
//
//           // Orders
//           ListTile(
//             leading: Icon(Icons.shopping_cart),
//             title: Text('Orders'),
//             onTap: () {
//               Navigator.pushNamed(context, '/orders');
//             },
//           ),
//
//           Divider(),
//
//           ListTile(
//             leading: Icon(Icons.chat),
//             title: Text('Settings'),
//             onTap: () {
//               Navigator.pushNamed(context, '/settings');
//             },
//           ),
//
//           // Logout
//           ListTile(
//             leading: Icon(Icons.logout),
//             title: Text('Logout'),
//             onTap: () {
//               // TODO: Implement logout functionality
//               Navigator.pushReplacementNamed(context, '/register');
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

//===============================================================Task 2

import 'package:flutter/material.dart';
import '../services/profile_service.dart';

class AppDrawer extends StatefulWidget {
  final String businessName;
  final String ownerImageUrl;

  const AppDrawer({
    Key? key,
    required this.businessName,
    required this.ownerImageUrl,
  }) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final ProfileService _profileService = ProfileService();

  Future<void> _checkProfileAndNavigate(String routeName) async {
    final isCompleted = await _profileService.isProfileCompleted();

    if (!isCompleted) {
      Navigator.pop(context); // Close drawer first

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Please complete your profile details to access this feature",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 3),
          action: SnackBarAction(
            label: "Go to Profile",
            textColor: Colors.white,
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ),
      );
      return;
    }

    Navigator.pop(context); // Close drawer
    Navigator.pushNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            accountName: Text(
              widget.businessName,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            accountEmail: Text("Manage your business efficiently"),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(widget.ownerImageUrl),
            ),
          ),

          // Profile - Always accessible
          ListTile(
            leading: Icon(Icons.person, color: Colors.blue[600]),
            title: Text("Profile"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/profile');
            },
          ),

          // Dashboard - Requires profile completion
          ListTile(
            leading: Icon(Icons.dashboard, color: Colors.green[600]),
            title: Text("Dashboard"),
            onTap: () => _checkProfileAndNavigate('/dashboard'),
          ),

          Divider(),

          // Inventory Management
          ExpansionTile(
            leading: Icon(Icons.inventory, color: Colors.orange[600]),
            title: Text("Inventory"),
            children: [
              ListTile(
                leading: Icon(Icons.list, color: Colors.grey[600]),
                title: Text("View Inventory"),
                onTap: () => _checkProfileAndNavigate('/inventory'),
              ),
              ListTile(
                leading: Icon(Icons.add_box, color: Colors.grey[600]),
                title: Text("Add Product"),
                onTap: () => _checkProfileAndNavigate('/add_edit_product'),
              ),
              ListTile(
                leading: Icon(Icons.warning, color: Colors.grey[600]),
                title: Text("Low Stock Alerts"),
                onTap: () => _checkProfileAndNavigate('/low_stock_alerts'),
              ),
            ],
          ),

          // Orders Management
          ExpansionTile(
            leading: Icon(Icons.shopping_cart, color: Colors.purple[600]),
            title: Text("Orders"),
            children: [
              ListTile(
                leading: Icon(Icons.list_alt, color: Colors.grey[600]),
                title: Text("View Orders"),
                onTap: () => _checkProfileAndNavigate('/orders'),
              ),
              ListTile(
                leading: Icon(Icons.add_circle, color: Colors.grey[600]),
                title: Text("Create Order"),
                onTap: () => _checkProfileAndNavigate('/add_order'),
              ),
            ],
          ),

          // Staff Management - Requires profile completion
          ListTile(
            leading: Icon(Icons.people, color: Colors.indigo[600]),
            title: Text("Staff Management"),
            onTap: () => _checkProfileAndNavigate('/staff_list'),
          ),

          // Ledger - Requires profile completion
          ListTile(
            leading: Icon(Icons.account_balance_wallet, color: Colors.teal[600]),
            title: Text("Ledger"),
            onTap: () => _checkProfileAndNavigate('/ledger_list'),
          ),

          Divider(),

          // Chatbot - Always accessible
          ListTile(
            leading: Icon(Icons.chat, color: Colors.purple[600]),
            title: Text("Chatbot Assistant"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/chatbot');
            },
          ),

          // Settings - Requires profile completion
          ListTile(
            leading: Icon(Icons.settings, color: Colors.grey[600]),
            title: Text("Settings"),
            onTap: () => _checkProfileAndNavigate('/settings'),
          ),

          // Notifications
          ListTile(
            leading: Icon(Icons.notifications, color: Colors.red[600]),
            title: Text("Notifications"),
            onTap: () => _checkProfileAndNavigate('/notify'),
          ),

          Divider(),

          // Logout
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red[600]),
            title: Text("Logout"),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Logout"),
                    content: Text("Are you sure you want to logout?"),
                    actions: [
                      TextButton(
                        child: Text("Cancel"),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      TextButton(
                        child: Text("Logout", style: TextStyle(color: Colors.red)),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop(); // Close drawer
                          // Add logout logic here
                          Navigator.pushReplacementNamed(context, '/register');
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}