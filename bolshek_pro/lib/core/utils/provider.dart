import 'package:flutter/material.dart';
import 'package:bolshek_pro/core/models/auth_response.dart';
import 'package:bolshek_pro/core/service/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalProvider extends ChangeNotifier {
  AuthResponse? _authResponse;
  String? _selectedCategoryId;
  String? _name;
  String? _brandId;
  String? _status;
  String _deliveryType = 'standard';
  String _vendorCode = '';
  String? _descriptionText = '';
  String? _organizationName;
  String? get organizationName => _organizationName;
  // Новые поля
  double _price = 0.0;
  String _kind = 'original'; // Default kind
  String _sku = '';
  String? _manufacturerId;
  String? _tagsId;

  String? _fcmToken;
  String? get fcmToken => _fcmToken;
  void setFcmToken(String token) {
    _fcmToken = token;
    notifyListeners();
  }

  String? _organizationId;
String? get organizationId => _organizationId;

void setOrganizationId(String id) {
  _organizationId = id;
  notifyListeners();
}

void setOrganizationName(String name) {
  _organizationName = name;
  notifyListeners();
}

  String? _manager;
String? get managerValue => _manager;

void getManager(String name) {
  _manager = name;
  notifyListeners();
}


  String?_warehouseId;
String? get warehouseId => _warehouseId;

void getWarehouseId(String id) {
  _warehouseId = id;
  notifyListeners();
}

List<String> _permissions = [];
List<String> get permissions => _permissions;

void setPermissions(List<String> value) {
  _permissions = value;
  notifyListeners();
}


  // Геттерый
  double get price => _price;
  String get kind => _kind;
  String get sku => _sku;
  String? get manufacturerId => _manufacturerId;
  String? get tagsId => _tagsId;

  // Геттеры
  String? get selectedCategoryId => _selectedCategoryId;
  String? get name => _name;
  String? get brandId => _brandId;
  String? get status => _status;
  String get deliveryType => _deliveryType;
  String get vendorCode => _vendorCode;
  String? get descriptionText => _descriptionText;

  AuthResponse? get authResponse => _authResponse;

  List<Map<String, dynamic>> _images = [];

  List<Map<String, dynamic>> get images => _images;
  Map<String, String> _propertyValues = {};

  Map<String, String> get propertyValues => _propertyValues;

  List<Map<String, dynamic>> _carMappings = [];
  List<Map<String, dynamic>> get carMappings => _carMappings;

  void setCarMappings(List<Map<String, dynamic>> mappings) {
    _carMappings = mappings;
    notifyListeners();
  }

  void setPropertyValues(Map<String, String> values) {
    _propertyValues = values;
    notifyListeners();
  }

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

  void setAuthData(AuthResponse response) async {
    _authResponse = response;
    notifyListeners();

    // Сохранение данных в SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', response.token ?? '');
    await prefs.setString('userName', response.user?.firstName ?? '');
    await prefs.setString('userLastName', response.user?.lastName ?? '');
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

  void setDescriptionText(String descriptionText) {
    print('Установлено descriptionText: $descriptionText');
    _descriptionText = descriptionText;
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

  void setImages(List<Map<String, dynamic>> images) {
    _images = images;
    notifyListeners();
  }

  void setManufacturerId(String manufacturerId) {
    _manufacturerId = manufacturerId;
    notifyListeners();
  }

  void setTagsId(String tagsId) {
    _tagsId = tagsId;
    notifyListeners();
  }

  // Новый метод logout
  Future<void> logout() async {
    // Очистка данных из SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Удаляем все сохраненные данные

    // Очистка данных в памяти
    _authResponse = null;
    _selectedCategoryId = null;
    _name = null;
    _brandId = null;
    _status = 'awaiting_approval';
    _deliveryType = 'standard';
    _vendorCode = '';
    _descriptionText = null;
    _price = 0.0;
    _kind = 'original';
    _sku = '';
    _manufacturerId = null;
    _images.clear();
    notifyListeners();
  }

  Future<void> loadAuthData(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final firstName = prefs.getString('userName');
    final lastName = prefs.getString('userLastName');

    if (token != null) {
      try {
        // Проверяем токен на сервере
        final authService = AuthService();
        final authSession = await authService.checkAuthToken(context, token);

        if (authSession != null) {
          // Если токен валиден, восстанавливаем данные авторизации
          _authResponse = AuthResponse(
            token: token,
            user: User(firstName: firstName, lastName: lastName),
          );
          notifyListeners();
        }
      } catch (e) {
        // Если ошибка, очищаем данные авторизации
        await prefs.remove('token');
        await prefs.remove('userName');
        await prefs.remove('userLastName');
        _authResponse = null;
        notifyListeners();
        print('Failed to validate token: $e');
      }
    }
  }

  void clearProductData() {
    _selectedCategoryId = null;
    _name = null;
    _brandId = null;
    _status = 'awaiting_approval';
    _deliveryType = 'standard';
    _vendorCode = '';
    _descriptionText = null;
    _price = 0.0;
    _kind = 'original';
    _sku = '';
    _manufacturerId = null;
    _images.clear();
    _propertyValues.clear();
    _carMappings.clear();
    _tagsId = null;
    _permissions = [];
    _manager = null;
    _warehouseId = null;
    notifyListeners();
  }

  static of(BuildContext context, {required bool listen}) {}
}
