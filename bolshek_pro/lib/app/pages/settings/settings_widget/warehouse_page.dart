import 'package:flutter/material.dart';
import 'package:bolshek_pro/app/widgets/custom_button.dart';
import 'package:bolshek_pro/app/widgets/phoneNumber_widget.dart';
import 'package:bolshek_pro/app/widgets/textfield_widget.dart';
import 'package:bolshek_pro/app/widgets/yandex_map_widget.dart';
import 'package:bolshek_pro/core/service/warehouse_service.dart';
import 'package:bolshek_pro/generated/l10n.dart';
import 'package:bolshek_pro/core/utils/theme.dart';

class WarehousePage extends StatefulWidget {
  final String organizationId;

  const WarehousePage({super.key, required this.organizationId});

  @override
  State<WarehousePage> createState() => _WarehousePageState();
}

class _WarehousePageState extends State<WarehousePage> {
  final warehouseNameController = TextEditingController();
  final addressController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneNumberController = TextEditingController();

  double? latitude;
  double? longitude;

  final _warehouseService = WarehouseService();
  bool _isLoading = false;

  Future<void> _openMap() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const YandexMapPickerScreen()),
    );
    if (result is Map<String, dynamic>) {
      setState(() {
        addressController.text = result['address'];
        latitude = result['latitude'];
        longitude = result['longitude'];
      });
    }
  }

  Future<void> _saveWarehouse() async {
    final localizations = S.of(context);

    final name = warehouseNameController.text.trim();
    final address = addressController.text.trim();
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final phone = phoneNumberController.text.replaceAll(RegExp(r'[^\d+]'), '');

    if (name.isEmpty ||
        address.isEmpty ||
        latitude == null ||
        longitude == null ||
        firstName.isEmpty ||
        lastName.isEmpty ||
        phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizations.fields_empty)),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _warehouseService.createWarehouse(
        context,
        
        longitude!,
        latitude!,
        address,
        "60f95c44-05e8-4031-9d9b-fad22fcd0d0c", // cityId пока хардкод
        firstName,
        name,
        lastName,
        phone,
        widget.organizationId,
        true, // isMain
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizations.save + ' успешно!')),
      );
   Navigator.pop(context, true);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Ошибка при создании склада: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = S.of(context);

    return Scaffold(
      backgroundColor: ThemeColors.white,
      appBar: AppBar(
        title: Text(localizations.add),
        backgroundColor: ThemeColors.white,
        foregroundColor: ThemeColors.black,
        elevation: 0.3,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomEditableField(
              title: localizations.enter_warehouse_name,
              value: '',
              onChanged: (val) => warehouseNameController.text = val,
            ),
            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Text(
                addressController.text.isNotEmpty
                    ? addressController.text
                    : localizations.addressNotSelected,
                style: const TextStyle(fontSize: 15),
              ),
            ),
            const SizedBox(height: 12),

            CustomButton(
              text: localizations.selectAddress,
              onPressed: _openMap,
            ),
            const SizedBox(height: 20),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                localizations.manager_data,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 10),
            CustomEditableField(
              title: localizations.first_name,
              value: '',
              onChanged: (val) => firstNameController.text = val,
            ),
            const SizedBox(height: 12),
            CustomEditableField(
              title: localizations.last_name,
              value: '',
              onChanged: (val) => lastNameController.text = val,
            ),
            const SizedBox(height: 12),
            OTPInputField(
              title: localizations.enter_phone,
              onChanged: (val) => phoneNumberController.text = val,
            ),
            const Spacer(),

            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: CustomButton(
                text: localizations.create_warehouse,
                onPressed: _saveWarehouse,
                isLoading: _isLoading,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
