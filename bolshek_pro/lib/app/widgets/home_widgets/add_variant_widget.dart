import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bolshek_pro/app/widgets/custom_alert_dialog_widget.dart';
import 'package:bolshek_pro/app/widgets/custom_dropdown_field.dart';
import 'package:bolshek_pro/app/widgets/editable_dropdown_field.dart';
import 'package:bolshek_pro/app/widgets/home_widgets/hex_colors_widget.dart';
import 'package:bolshek_pro/app/widgets/textfield_widget.dart';
import 'package:bolshek_pro/core/models/manufacturers_response.dart';
import 'package:bolshek_pro/core/models/tags_response.dart';
import 'package:bolshek_pro/core/service/maufacturers_service.dart';
import 'package:bolshek_pro/app/widgets/custom_button.dart';
import 'package:bolshek_pro/core/service/tags_service.dart';
import 'package:bolshek_pro/core/utils/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bolshek_pro/generated/l10n.dart';

class ProductDetailsWidget extends StatefulWidget {
  @override
  _ProductDetailsWidgetState createState() => _ProductDetailsWidgetState();
}

class _ProductDetailsWidgetState extends State<ProductDetailsWidget> {
  final ManufacturersService _service = ManufacturersService();
  List<ManufacturersItems> _manufacturers = [];
  ManufacturersItems? _selectedManufacturer;
  List<ItemsTags> _selectedTags = [];

  final TagsService _tagsService = TagsService();
  List<ItemsTags> _tags = [];
  int _quantity = 0;
  // Значение по умолчанию для типа товара – локализуемые строки можно использовать,
  // но здесь для логики используются внутренние значения, поэтому отображаемые подписи локализуем отдельно
  String selectedType = '';
  String selectedDelivery = '';
  String? descriptionText = '';
  final TextEditingController _focusController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadManufacturers();
    _loadTags();
  }

  @override
  void dispose() {
    _focusController.dispose();
    super.dispose();
  }

  Future<void> _loadManufacturers() async {
    try {
      final response = await _service.fetchManufacturers(context);
      setState(() {
        _manufacturers = response.items ?? [];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                '${S.of(context).error}: Ошибка загрузки производителей: $e')),
      );
    }
  }

  Future<void> _loadTags() async {
    try {
      final responseTags = await _tagsService.getTags(context);
      setState(() {
        _tags = responseTags.items ?? [];
      });
    } catch (e) {
      print(e);
    }
  }

  void _showTypeOptions() {
    // Используем локализацию для названий типов
    final typeOptions = [
      S.of(context).original,
      S.of(context).sub_original,
      S.of(context).auto_disassembly
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        String searchQuery = ''; // Локальная переменная для поиска
        return StatefulBuilder(
          builder: (context, setStateModal) {
            final filteredTypes = typeOptions
                .where((type) =>
                    type.toLowerCase().contains(searchQuery.toLowerCase()))
                .toList();
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Text(
                            S.of(context).product_amount), // ключ: product_type
                      ],
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredTypes.length,
                        itemBuilder: (context, index) {
                          final type = filteredTypes[index];
                          return ListTile(
                            title: Text(type),
                            onTap: () {
                              Navigator.pop(context);
                              setState(() {
                                selectedType = type;
                                String kind = '';
                                if (type == S.of(context).original)
                                  kind = 'original';
                                if (type == S.of(context).sub_original)
                                  kind = 'sub_original';
                                if (type == S.of(context).auto_disassembly)
                                  kind = 'disassemble';
                                context.read<GlobalProvider>().setKind(kind);
                                FocusScope.of(context).unfocus();
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showDeliveryMethods() {
    final deliveryMethods = [
      S.of(context).express,
      S.of(context).standard,
      S.of(context).custom_delivery
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        String searchQuery = '';
        return StatefulBuilder(
          builder: (context, setStateModal) {
            final filteredMethods = deliveryMethods
                .where((method) =>
                    method.toLowerCase().contains(searchQuery.toLowerCase()))
                .toList();
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Text(S
                            .of(context)
                            .delivery_methods), // ключ: delivery_methods
                      ],
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredMethods.length,
                        itemBuilder: (context, index) {
                          final method = filteredMethods[index];
                          return ListTile(
                            title: Text(method),
                            onTap: () {
                              Navigator.pop(context);
                              setState(() {
                                selectedDelivery = method;
                                String deliveryType = '';
                                if (method == S.of(context).express)
                                  deliveryType = 'express';
                                if (method == S.of(context).standard)
                                  deliveryType = 'standard';
                                if (method == S.of(context).custom_delivery)
                                  deliveryType = 'custom';
                                context
                                    .read<GlobalProvider>()
                                    .setDeliveryType(deliveryType);
                                FocusScope.of(context).unfocus();
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showManufacturers() {
    if (_manufacturers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(S.of(context).error)), // ключ: manufacturers_empty
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        String searchQuery = '';
        return StatefulBuilder(
          builder: (context, setStateModal) {
            final filteredManufacturers = _manufacturers
                .where((manufacturer) =>
                    manufacturer.name != null &&
                    manufacturer.name!
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase()))
                .toList();

            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: S
                                  .of(context)
                                  .manufacturer_search, // ключ: manufacturer_search
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 12),
                            ),
                            onChanged: (value) {
                              setStateModal(() {
                                searchQuery = value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredManufacturers.length,
                        itemBuilder: (context, index) {
                          final manufacturer = filteredManufacturers[index];
                          return ListTile(
                            title: Text(
                                manufacturer.name ?? S.of(context).no_name),
                            onTap: () {
                              Navigator.pop(context);
                              setState(() {
                                _selectedManufacturer = manufacturer;
                                context
                                    .read<GlobalProvider>()
                                    .setManufacturerId(manufacturer.id ?? '');
                              });
                              FocusScope.of(context).unfocus();
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 25.0),
                      child: CustomButton(
                        text: S
                            .of(context)
                            .add_manufacturer, // ключ: add_manufacturer
                        onPressed: () async {
                          final TextEditingController nameController =
                              TextEditingController();
                          await showCustomAlertDialog(
                            context: context,
                            title: S.of(context).add_manufacturer,
                            content: TextField(
                              controller: nameController,
                              decoration: InputDecoration(
                                labelText: S
                                    .of(context)
                                    .manufacturer_name, // ключ: manufacturer_name
                                hintText: S
                                    .of(context)
                                    .enter_manufacturer_name, // ключ: enter_manufacturer_name
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.orange),
                                ),
                              ),
                            ),
                            onCancel: () {
                              Navigator.pop(context);
                            },
                            onConfirm: () async {
                              final name = nameController.text.trim();
                              if (name.isNotEmpty) {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => const Center(
                                      child: CircularProgressIndicator(
                                    color: Colors.grey,
                                  )),
                                );
                                try {
                                  await _service.createManufacturers(
                                      context, name);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(S
                                          .of(context)
                                          .error), // ключ: manufacturer_added, например: "Производитель \"$name\" успешно добавлен"
                                    ),
                                  );
                                  await _loadManufacturers();
                                  Navigator.pop(
                                      context); // Закрываем диалог загрузки
                                  Navigator.pop(
                                      context); // Закрываем диалог добавления производителя
                                } catch (e) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          '${S.of(context).error}: $e'), // ключ: error_adding_manufacturer
                                    ),
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(S
                                        .of(context)
                                        .error), // ключ: manufacturer_name_empty
                                  ),
                                );
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showTags() {
    if (_tags.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).tags_empty)), // ключ: tags_empty
      );
      return;
    }

    List<ItemsTags> tempSelectedTags = List.from(_selectedTags);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        String searchQuery = '';
        return StatefulBuilder(
          builder: (context, setStateModal) {
            final filteredTags = _tags
                .where((tag) =>
                    tag.text != null &&
                    tag.text!.toLowerCase().contains(searchQuery.toLowerCase()))
                .toList();
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 12.0),
                          child: Text(
                            'Выберите теги',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredTags.length,
                        itemBuilder: (context, index) {
                          final tag = filteredTags[index];
                          final isSelected = tempSelectedTags.contains(tag);
                          Color bgColor = tag.backgroundColor != null
                              ? HexColor(tag.backgroundColor!)
                              : Colors.white;
                          Color txtColor = tag.textColor != null
                              ? HexColor(tag.textColor!)
                              : Colors.black;
                          return ListTile(
                            title: Container(
                              padding: const EdgeInsets.all(9.0),
                              decoration: BoxDecoration(
                                color: bgColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    tag.text ??
                                        S.of(context).no_name, // ключ: no_name
                                    style: TextStyle(
                                      color: txtColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (isSelected)
                                    const Icon(Icons.check_box,
                                        color: Colors.greenAccent),
                                ],
                              ),
                            ),
                            onTap: () {
                              setStateModal(() {
                                if (isSelected) {
                                  tempSelectedTags.remove(tag);
                                } else {
                                  tempSelectedTags.add(tag);
                                }
                              });
                            },
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: CustomButton(
                        onPressed: () {
                          setState(() {
                            _selectedTags = tempSelectedTags;
                            context.read<GlobalProvider>().setTagsId(
                                  _selectedTags
                                      .map((tag) => tag.id ?? '')
                                      .join(','),
                                );
                          });
                          Navigator.pop(context);
                          FocusScope.of(context).unfocus();
                        },
                        text: S.of(context).save, // ключ: save
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: CustomDropdownField(
                  title: S.of(context).variant, // ключ: variant
                  value: selectedType.isNotEmpty
                      ? selectedType
                      : S.of(context).choose_type, // ключ: choose_type
                  onTap: _showTypeOptions,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          Row(
            children: [
              Expanded(
                child: CustomDropdownField(
                  title:
                      S.of(context).delivery_methods, // ключ: delivery_methods
                  value: selectedDelivery.isNotEmpty
                      ? selectedDelivery
                      : S
                          .of(context)
                          .choose_delivery_method, // ключ: choose_delivery_method
                  onTap: _showDeliveryMethods,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          CustomDropdownField(
            title: S.of(context).manufacturer, // ключ: manufacturer
            value: _selectedManufacturer?.name ??
                S.of(context).choose_manufacturer, // ключ: choose_manufacturer
            onTap: _showManufacturers,
          ),
          const SizedBox(height: 12.0),
          CustomDropdownField(
            title: S.of(context).tags, // ключ: tags
            value: _selectedTags.isNotEmpty
                ? _selectedTags.map((tag) => tag.text).join(', ')
                : S.of(context).choose_tags, // ключ: choose_tags
            onTap: _showTags,
          ),
          const SizedBox(height: 12.0),
          Row(
            children: [
              Expanded(
                child: EditableDropdownField(
                  title: S.of(context).description, // ключ: description
                  value: '',
                  maxLines: 4,
                  onChanged: (value) {
                    context.read<GlobalProvider>().setDescriptionText(value);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          Row(
            children: [
              Expanded(
                child: CustomEditableField(
                  title: S.of(context).sku, // ключ: sku
                  value: '',
                  onChanged: (value) {
                    context.read<GlobalProvider>().setSku(value);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          Row(
            children: [
              Expanded(
                child: CustomEditableField(
                  title: S.of(context).vendor_code, // ключ: vendor_code
                  value: '',
                  onChanged: (value) {
                    context.read<GlobalProvider>().setVendorCode(value);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
