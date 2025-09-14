import 'package:flutter/material.dart';

// Authetication
import '../../../screens/authentication/auth_gate.dart';
import '../../screens/authentication/register_screen.dart';
import '../../screens/authentication/profile_screen.dart';

//Notification & Settings
import '../../screens/Notification/Notification_Page.dart';
import '../../screens/Settings/Settings_Page.dart';

//Order management
import '../../screens/Orders/Add_EditOrder_Page.dart';
import '../../screens/Orders/DeliveryChallan_Page.dart';
import '../../screens/Orders/OrderDetail_Page.dart';
import '../../screens/Orders/OrdersList_Page.dart';
import '../../screens/Orders/StockManagement_Page.dart';

//Stock & Inventory Management
import '../../screens/Stock & Inventory Management/Add_EditProduct_Page.dart';
import '../../screens/Stock & Inventory Management/BarcodeScanner_Page.dart';
import '../../screens/Stock & Inventory Management/InventoryList_Page.dart';
import '../../screens/Stock & Inventory Management/LowStockAlerts_Page.dart';
import '../../screens/Stock & Inventory Management/StockAdjustment_Page.dart';
import '../../screens/Stock & Inventory Management/StockDetail_Page.dart';
import '../../features/inventory/inventory_dashboard.dart';


//Home Page
import '../../screens/Home/home_page.dart';
import '../../screens/dashboard/dashboard_page.dart';



class AppRoutes {
  static Map<String, WidgetBuilder> routes = {

    // Authentication
    '/register': (context) => RegisterScreen(),
    '/auth-gate': (context) => AuthGate(),
    '/profile': (context) => ProfilePage(),

    // Home page
    '/home': (context) => HomePage(),
    '/dashboard' : (context) => DashboardPage(businessName: '',),

    // Inventory
    '/inventory_dashboard': (context) => InventoryDashboard(),
    '/inventory': (context) => InventoryListPage(),
    '/add_edit_product': (context) => AddProductPage(),
    '/stock_adjustment': (context) => StockAdjustmentPage(),
    '/stock_detail': (context) => StockDetailPage(),
    '/low_stock_alerts': (context) => LowStockAlertsPage(),
    '/barcode_scanner': (context) => BarcodeScannerPage(),

    //  Orders
    '/orders': (context) => OrdersListPage(),
    '/add_order': (context) => AddEditOrderPage(),
    '/order_detail': (context) => OrderDetailPage(),
    '/delivery_challan': (context) => DeliveryChallanPage(),
    '/stock_management': (context) => StockManagementPage(),

    //Notifications & Settings
    '/notify' : (context) => NotificationsPage(userId: '',),
  };
}
