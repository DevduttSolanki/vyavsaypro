import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vyavsaypro/features/inventory/product_form.dart';
import 'package:vyavsaypro/models/category_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  group('ProductForm Widget Tests', () {
    late List<CategoryModel> mockCategories;

    setUp(() {
      mockCategories = [
        CategoryModel(
          categoryId: 'cat1',
          name: 'Clothing',
          description: 'Apparel',
          createdAt: Timestamp.now(),
          updatedAt: Timestamp.now(),
        ),
        CategoryModel(
          categoryId: 'cat2',
          name: 'Electronics',
          description: 'Electronic devices',
          createdAt: Timestamp.now(),
          updatedAt: Timestamp.now(),
        ),
      ];
    });

    testWidgets('should display all required form fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ProductForm(
            businessId: 'test_business_id',
            categories: mockCategories,
          ),
        ),
      );

      // Check if required fields are present
      expect(find.text('Product Name'), findsOneWidget);
      expect(find.text('Category'), findsOneWidget);
      expect(find.text('Price'), findsOneWidget);
      expect(find.text('Quantity'), findsOneWidget);
      expect(find.text('GST Rate (%)'), findsOneWidget);
      expect(find.text('Low Stock Threshold'), findsOneWidget);
      expect(find.text('Save Product'), findsOneWidget);
    });

    testWidgets('should display optional fields when not in quick add mode', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ProductForm(
            businessId: 'test_business_id',
            categories: mockCategories,
          ),
        ),
      );

      // Check if optional fields are present
      expect(find.text('Barcode'), findsOneWidget);
      expect(find.text('Unit of Measurement'), findsOneWidget);
      expect(find.text('Location'), findsOneWidget);
      expect(find.text('Batch Number'), findsOneWidget);
      expect(find.text('Select Expiry Date (Optional)'), findsOneWidget);
    });

    testWidgets('should validate required fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ProductForm(
            businessId: 'test_business_id',
            categories: mockCategories,
          ),
        ),
      );

      // Try to save without filling required fields
      await tester.tap(find.text('Save Product'));
      await tester.pump();

      // Should show validation errors
      expect(find.text('Product name is required'), findsOneWidget);
      expect(find.text('Please select a category'), findsOneWidget);
      expect(find.text('Price is required'), findsOneWidget);
      expect(find.text('Quantity is required'), findsOneWidget);
      expect(find.text('GST rate is required'), findsOneWidget);
      expect(find.text('Low stock threshold is required'), findsOneWidget);
    });

    testWidgets('should validate price format', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ProductForm(
            businessId: 'test_business_id',
            categories: mockCategories,
          ),
        ),
      );

      // Enter invalid price
      await tester.enterText(find.byType(TextField).at(2), 'invalid_price'); // Price field
      await tester.tap(find.text('Save Product'));
      await tester.pump();

      expect(find.text('Please enter a valid price'), findsOneWidget);
    });

    testWidgets('should validate quantity format', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ProductForm(
            businessId: 'test_business_id',
            categories: mockCategories,
          ),
        ),
      );

      // Enter invalid quantity
      await tester.enterText(find.byType(TextField).at(3), 'invalid_qty'); // Quantity field
      await tester.tap(find.text('Save Product'));
      await tester.pump();

      expect(find.text('Please enter a valid quantity'), findsOneWidget);
    });

    testWidgets('should validate negative values', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ProductForm(
            businessId: 'test_business_id',
            categories: mockCategories,
          ),
        ),
      );

      // Enter negative price
      await tester.enterText(find.byType(TextField).at(2), '-10'); // Price field
      await tester.tap(find.text('Save Product'));
      await tester.pump();

      expect(find.text('Please enter a valid price'), findsOneWidget);
    });

    testWidgets('should show quick add button for new products', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ProductForm(
            businessId: 'test_business_id',
            categories: mockCategories,
          ),
        ),
      );

      // Check if quick add toggle is present
      expect(find.text('Quick Add'), findsOneWidget);
    });

    testWidgets('should toggle between full form and quick add', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ProductForm(
            businessId: 'test_business_id',
            categories: mockCategories,
          ),
        ),
      );

      // Initially should show full form
      expect(find.text('Barcode'), findsOneWidget);

      // Tap quick add toggle
      await tester.tap(find.text('Quick Add'));
      await tester.pump();

      // Should show quick add button
      expect(find.text('Quick Add'), findsOneWidget);
    });

    testWidgets('should populate fields when editing existing product', (WidgetTester tester) async {
      final existingProduct = ProductModel(
        productId: 'test_product_id',
        businessId: 'test_business_id',
        categoryId: 'cat1',
        name: 'Existing Product',
        price: 150.0,
        quantity: 25,
        gstRate: 18.0,
        barcode: 'EXISTING123',
        batchNumber: 'BATCH001',
        location: 'Warehouse A',
        unitOfMeasurement: 'pieces',
        lowStockThreshold: 5,
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: ProductForm(
            businessId: 'test_business_id',
            categories: mockCategories,
            product: existingProduct,
          ),
        ),
      );

      // Check if fields are populated
      expect(find.text('Existing Product'), findsOneWidget);
      expect(find.text('150.0'), findsOneWidget);
      expect(find.text('25'), findsOneWidget);
      expect(find.text('18.0'), findsOneWidget);
      expect(find.text('EXISTING123'), findsOneWidget);
      expect(find.text('BATCH001'), findsOneWidget);
      expect(find.text('Warehouse A'), findsOneWidget);
      expect(find.text('pieces'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('should show update button for existing product', (WidgetTester tester) async {
      final existingProduct = ProductModel(
        productId: 'test_product_id',
        businessId: 'test_business_id',
        categoryId: 'cat1',
        name: 'Existing Product',
        price: 150.0,
        quantity: 25,
        gstRate: 18.0,
        lowStockThreshold: 5,
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: ProductForm(
            businessId: 'test_business_id',
            categories: mockCategories,
            product: existingProduct,
          ),
        ),
      );

      // Should show update button instead of save button
      expect(find.text('Update Product'), findsOneWidget);
      expect(find.text('Save Product'), findsNothing);
    });
  });
}
