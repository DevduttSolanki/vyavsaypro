# Inventory Management System

This document provides comprehensive documentation for the Stock & Inventory Management feature implemented for VyavsayPro.

## Overview

The Inventory Management system provides a complete solution for managing products, stock levels, and inventory movements within a business. It includes manual product addition, automatic stock adjustments, stock tracking, and low stock alerts.

## Architecture

### Data Models

The system uses the following Firestore collections:

#### Categories Collection (`categories`)
```dart
{
  "category_id": "string",
  "name": "string",
  "description": "string?",
  "created_at": "timestamp",
  "updated_at": "timestamp"
}
```

#### Products Collection (`products`)
```dart
{
  "product_id": "string",
  "business_id": "string",
  "category_id": "string",
  "name": "string",
  "price": "number",
  "quantity": "number", // denormalized current stock
  "gst_rate": "number",
  "barcode": "string?",
  "batch_number": "string?",
  "expiry_date": "timestamp?",
  "location": "string?",
  "unit_of_measurement": "string?",
  "low_stock_threshold": "number",
  "created_at": "timestamp",
  "updated_at": "timestamp"
}
```

#### Stock Movements Collection (`stock_movements`)
```dart
{
  "movement_id": "string",
  "business_id": "string",
  "product_id": "string",
  "type": "string", // 'init', 'purchase', 'sale', 'adjustment', 'transfer_in', 'transfer_out'
  "qty": "number", // positive for IN, negative for OUT
  "reason": "string",
  "reference_id": "string?", // invoice_id / purchase_order_id / user_action_id
  "user_id": "string",
  "location": "string?",
  "batch_number": "string?",
  "expiry_date": "timestamp?",
  "created_at": "timestamp"
}
```

### Services

#### InventoryService
Core service for inventory operations:

```dart
class InventoryService {
  // Category Management
  Future<String?> createCategory({required String name, String? description});
  Future<List<CategoryModel>> getCategories();

  // Product Management
  Future<String?> addProduct(ProductDto productDto);
  Future<String?> quickAddProduct(QuickAddProductDto quickAddDto);
  Future<bool> updateProduct(String productId, Map<String, dynamic> updates);
  Future<ProductModel?> getProduct(String productId);
  Future<List<ProductModel>> getProducts({required String businessId, ...});
  Future<List<ProductModel>> getLowStockProducts(String businessId);
  Future<int> getLowStockCount(String businessId);

  // Stock Management
  Future<bool> increaseStock({required String businessId, required String productId, ...});
  Future<bool> decreaseStock({required String businessId, required String productId, ...});
  Future<bool> reconcileProductQuantity(String productId);
  Future<List<StockMovementModel>> getStockMovements({required String productId, ...});

  // Integration Hooks
  Future<bool> decreaseStockForSale({required String businessId, ...});
  Future<bool> increaseStockForPurchase({required String businessId, ...});
}
```

#### InventoryIntegrationService
Service for other modules to interact with inventory:

```dart
class InventoryIntegrationService {
  // Sale Integration
  Future<bool> decreaseStockForSale({required String businessId, ...});
  Future<Map<String, bool>> batchDecreaseStockForSale({required String businessId, ...});
  Future<bool> checkStockAvailability({required String businessId, ...});
  Future<Map<String, bool>> validateStockAvailability({required String businessId, ...});

  // Purchase Integration
  Future<bool> increaseStockForPurchase({required String businessId, ...});
  Future<Map<String, bool>> batchIncreaseStockForPurchase({required String businessId, ...});

  // Product Information
  Future<int?> getCurrentStock({required String businessId, required String productId});
  Future<Map<String, dynamic>?> getProductInfo({required String businessId, required String productId});
}
```

## Features

### 1. Manual Product Addition

**Full Form Mode:**
- Product name (required)
- Category selection (required)
- Price (required)
- Quantity (required)
- GST rate (required)
- Low stock threshold (required)
- Barcode (optional)
- Unit of measurement (optional)
- Location (optional)
- Batch number (optional)
- Expiry date (optional)

**Quick Add Mode:**
- Product name (required)
- Price (required)
- Quantity (required)
- Uses default values for other fields

### 2. Auto Stock Adjustment

The system provides atomic stock adjustment operations:

```dart
// Increase stock
await inventoryService.increaseStock(
  businessId: 'business_id',
  productId: 'product_id',
  qty: 50,
  reason: 'Purchase order #PO001',
  userId: 'user_id',
);

// Decrease stock
await inventoryService.decreaseStock(
  businessId: 'business_id',
  productId: 'product_id',
  qty: 10,
  reason: 'Sale invoice #INV001',
  userId: 'user_id',
  allowNegativeStock: false, // Prevent negative stock
);
```

### 3. Stock Tracking

- Real-time stock quantity tracking
- Complete audit trail via stock movements
- Stock reconciliation from movement history
- Product search and filtering
- Category-based organization

### 4. Low Stock Alerts

- Per-product low stock thresholds
- Dashboard-level low stock count
- Highlighted low stock products in lists
- Global low stock default setting support

## Integration with Other Modules

### Billing/Orders Module Integration

```dart
// Before finalizing a sale
final integrationService = InventoryIntegrationService();

// Check stock availability
final available = await integrationService.checkStockAvailability(
  businessId: businessId,
  productId: productId,
  qty: quantity,
);

if (!available) {
  throw Exception('Insufficient stock');
}

// Process the sale
// ... billing logic ...

// Decrease stock after successful sale
await integrationService.decreaseStockForSale(
  businessId: businessId,
  productId: productId,
  qty: quantity,
  invoiceId: invoiceId,
);
```

### Batch Operations

```dart
// Process multiple line items in a single sale
final lineItems = [
  {'productId': 'prod1', 'qty': 5},
  {'productId': 'prod2', 'qty': 3},
  {'productId': 'prod3', 'qty': 2},
];

final results = await integrationService.batchDecreaseStockForSale(
  businessId: businessId,
  invoiceId: invoiceId,
  lineItems: lineItems,
);

// Check results
for (final entry in results.entries) {
  if (!entry.value) {
    print('Failed to decrease stock for product ${entry.key}');
  }
}
```

## Database Rules & Constraints

### Business Rules
1. **Barcode Uniqueness**: Barcodes must be unique within a business
2. **Negative Stock Prevention**: By default, stock cannot go negative (configurable)
3. **Atomic Operations**: All stock changes are atomic using Firestore transactions
4. **Audit Trail**: Every stock change is recorded in stock_movements

### Data Integrity
1. **Denormalized Quantity**: Product quantity is stored in products collection for performance
2. **Reconciliation**: Quantity can be recalculated from stock_movements if needed
3. **Consistent Timestamps**: All timestamps are stored in UTC

## Error Handling

The system provides comprehensive error handling:

```dart
try {
  await inventoryService.decreaseStock(
    businessId: businessId,
    productId: productId,
    qty: quantity,
    reason: reason,
    userId: userId,
  );
} catch (e) {
  if (e.toString().contains('Insufficient stock')) {
    // Handle insufficient stock
  } else if (e.toString().contains('Product not found')) {
    // Handle product not found
  } else {
    // Handle other errors
  }
}
```

## Testing

### Unit Tests
- Model validation tests
- Service method tests
- Error handling tests

### Widget Tests
- Form validation tests
- UI interaction tests
- State management tests

### Integration Tests
- End-to-end workflow tests
- Database transaction tests
- Cross-module integration tests

## Sample Data

Use the `InventorySeederService` to populate sample data:

```dart
final seeder = InventorySeederService();
await seeder.seedAll(businessId);
```

This creates:
- Sample categories (Clothing, Pharma, Electronics, etc.)
- Sample products with various stock levels
- Sample stock movements for testing

## Performance Considerations

1. **Pagination**: Product lists are paginated (default limit: 50)
2. **Indexing**: Firestore composite indexes may be required for complex queries
3. **Caching**: Consider implementing local caching for frequently accessed data
4. **Batch Operations**: Use batch operations for multiple stock changes

## Security

1. **Business Isolation**: All operations are scoped to business_id
2. **User Authentication**: All operations require authenticated users
3. **Data Validation**: All inputs are validated before processing
4. **Audit Trail**: Complete audit trail for all stock changes

## Migration Notes

### From Legacy System
If migrating from a legacy inventory system:

1. **Data Migration**: Use the reconciliation feature to rebuild quantities from movements
2. **Bulk Import Removal**: The old bulk import feature has been removed and replaced with Quick Add
3. **API Changes**: Update any existing integrations to use the new service methods

### Database Migration
No database migration is required as this is a new feature. The system will create the necessary Firestore collections automatically.

## Troubleshooting

### Common Issues

1. **Stock Not Updating**: Check if Firestore transactions are enabled
2. **Negative Stock**: Verify `allowNegativeStock` parameter
3. **Missing Categories**: Ensure categories are created before adding products
4. **Performance Issues**: Check Firestore indexes and consider pagination

### Debug Mode
Enable debug logging by setting the log level in the service:

```dart
// Add debug prints in service methods
print('Debug: Stock adjustment - Product: $productId, Qty: $qty');
```

## Future Enhancements

1. **Barcode Scanning**: Integration with mobile scanner
2. **Batch Tracking**: Enhanced batch and expiry date management
3. **Multi-location**: Support for multiple warehouse locations
4. **Reporting**: Advanced inventory reports and analytics
5. **Notifications**: Push notifications for low stock alerts
6. **API**: REST API for external integrations
