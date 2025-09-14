import 'package:cloud_firestore/cloud_firestore.dart';

class BusinessModel {
  final String userId;
  final String businessId;
  final String businessName;
  final String address;
  final String contactInfo;
  final bool gstRegistered;
  final String defaultTaxType; // "GST" or "Non-GST"
  final String? logoUrl;
  final String? gstin;
  final String defaultFooterMessage;
  final String salesTerms;
  final String purchaseTerms;

  BusinessModel({
    required this.userId,
    required this.businessId,
    required this.businessName,
    required this.address,
    required this.contactInfo,
    this.gstRegistered = false,
    this.defaultTaxType = "Non-GST",
    this.logoUrl,
    this.gstin,
    required this.defaultFooterMessage,
    required this.salesTerms,
    required this.purchaseTerms,
  });

  // Convert Dart object → Firestore Map
  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'business_id': businessId,
      'business_name': businessName,
      'address': address,
      'contact_info': contactInfo,
      'gst_registered': gstRegistered,
      'default_tax_type': defaultTaxType,
      'logo_url': logoUrl,
      'gstin': gstin,
      'default_footer_message': defaultFooterMessage,
      'sales_terms': salesTerms,
      'purchase_terms': purchaseTerms,
    };
  }

  // Convert Firestore Doc → Dart object
  factory BusinessModel.fromMap(Map<String, dynamic> map) {
    return BusinessModel(
      userId: map['user_id'] ?? '',
      businessId: map['business_id'] ?? '',
      businessName: map['business_name'] ?? '',
      address: map['address'] ?? '',
      contactInfo: map['contact_info'] ?? '',
      gstRegistered: map['gst_registered'] ?? false,
      defaultTaxType: map['default_tax_type'] ?? 'Non-GST',
      logoUrl: map['logo_url'],
      gstin: map['gstin'],
      defaultFooterMessage: map['default_footer_message'] ?? '',
      salesTerms: map['sales_terms'] ?? '',
      purchaseTerms: map['purchase_terms'] ?? '',
    );
  }
}