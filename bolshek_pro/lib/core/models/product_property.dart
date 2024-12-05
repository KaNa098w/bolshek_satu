import 'package:bolshek_pro/core/models/properties_response.dart';

class ProductProperty {
  PropertyItems? property;
  String? value;

  ProductProperty({this.property, this.value});

  ProductProperty.fromJson(Map<String, dynamic> json) {
    property = json['property'] != null
        ? PropertyItems.fromJson(json['property'])
        : null;
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (property != null) {
      data['property'] = property!.toJson();
    }
    data['value'] = value;
    return data;
  }
}
