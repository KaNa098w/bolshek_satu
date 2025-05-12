import 'package:bolshek_pro/core/models/warehouse_response.dart';

class WarehouseEntry {
  WarehouseItem? warehouse;
  int qty;
  WarehouseEntry({this.warehouse, this.qty = 1});
}
