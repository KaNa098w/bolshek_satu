import 'package:bolshek_pro/core/models/auth_response.dart';
import 'package:flutter/material.dart';

class GlobalProvider extends ChangeNotifier {
  AuthResponse? _authResponse;
  String? _selectedCategoryId;
  String? _name;
  String? _brandId;
  String _status = 'awaiting_approval';
  String _deliveryType = 'standard';
  String _vendorCode = '';

  // Новые поля
  double _price = 0.0;
  String _kind = 'original'; // Default kind
  String _sku = '';
  String? _manufacturerId;

  // Геттеры
  double get price => _price;
  String get kind => _kind;
  String get sku => _sku;
  String? get manufacturerId => _manufacturerId;

  // Геттеры
  String? get selectedCategoryId => _selectedCategoryId;
  String? get name => _name;
  String? get brandId => _brandId;
  String get status => _status;
  String get deliveryType => _deliveryType;
  String get vendorCode => _vendorCode;

  AuthResponse? get authResponse => _authResponse;

  List<Map<String, dynamic>> _images = [];

  List<Map<String, dynamic>> get images => _images;

  void addImageData(Map<String, dynamic> imageData) {
    if (_images.length < 5) {
      _images.add(imageData);
      notifyListeners();
    } else {
      print('Достигнут лимит фотографий (5)');
    }
  }

  void clearImages() {
    _images.clear();
    notifyListeners();
  }

  void setAuthData(AuthResponse response) {
    _authResponse = response;
    notifyListeners();
    // Обновление виджетов, которые слушают провайдер
    print(authResponse?.token);
  }

  void clearAuthData() {
    _authResponse = null;
    notifyListeners();
  }

  void setCategoryId(String? categoryId) {
    _selectedCategoryId = categoryId;
    notifyListeners();
  }

  void setName(String? name) {
    _name = name;
    notifyListeners();
  }

  void setBrandId(String? brandId) {
    _brandId = brandId;
    notifyListeners();
  }

  void setStatus(String status) {
    _status = status;
    notifyListeners();
  }

  void setDeliveryType(String deliveryType) {
    _deliveryType = deliveryType;
    notifyListeners();
  }

  void setVendorCode(String vendorCode) {
    _vendorCode = vendorCode;
    notifyListeners();
  }

  void setPrice(double price) {
    _price = price;
    notifyListeners();
  }

  void setKind(String kind) {
    _kind = kind;
    notifyListeners();
  }

  void setSku(String sku) {
    _sku = sku;
    notifyListeners();
  }

  void setManufacturerId(String manufacturerId) {
    _manufacturerId = manufacturerId;
    notifyListeners();
  }
}
