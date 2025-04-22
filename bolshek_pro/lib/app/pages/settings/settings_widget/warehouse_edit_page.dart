import 'package:bolshek_pro/app/widgets/custom_button.dart';
import 'package:bolshek_pro/app/widgets/yandex_map_widget.dart';
import 'package:bolshek_pro/core/models/warehouse_response.dart';
import 'package:bolshek_pro/core/service/warehouse_service.dart';
import 'package:bolshek_pro/core/utils/theme.dart';
import 'package:bolshek_pro/generated/l10n.dart';
import 'package:flutter/material.dart';

class WarehouseEditPage extends StatefulWidget {
  final String id;

  const WarehouseEditPage({super.key, required this.id});

  @override
  State<WarehouseEditPage> createState() => _WarehouseEditPageState();
}

class _WarehouseEditPageState extends State<WarehouseEditPage> {
  final WarehouseService _warehouseService = WarehouseService();
  WarehouseItem? war;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadWarehouse();
  }

  Future<void> _loadWarehouse() async {
    try {
      final warehouseResponse =
          await _warehouseService.getWarehousesById(context, widget.id);
      setState(() {
        war = warehouseResponse;
        _isLoading = false;
      });
    } catch (e) {
      print('Ошибка при получении склада: $e');
    }
  }

  void _showEditManagerBottomSheet({
    required String firstName,
    required String lastName,
    required void Function(String, String) onSave,
  }) {
    final firstNameController = TextEditingController(text: firstName);
    final lastNameController = TextEditingController(text: lastName);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(S.of(context).edit_manager_title),
              const SizedBox(height: 16),
              TextField(
                controller: firstNameController,
                decoration: InputDecoration(hintText: S.of(context).first_name),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: lastNameController,
                decoration: InputDecoration(hintText: S.of(context).last_name),
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: S.of(context).save,
                onPressed: () {
                  onSave(firstNameController.text, lastNameController.text);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectAddress() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const YandexMapPickerScreen()),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        war = war!.copyWith(
          address: war!.address.copyWith(address: result['address']),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = S.of(context);

    if (_isLoading || war == null) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator(color: Colors.grey)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(war!.name, style: const TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _infoCard(
              title: loc.org_name_label,
              value: war!.name,
              icon: Icons.store,
              editIcon: Icons.edit,
              onEdit: () => _showEditBottomSheet(
                loc.edit,
                war!.name,
                (newVal) => setState(() {
                  war = war!.copyWith(name: newVal);
                }),
              ),
            ),
            _infoCard(
              title: loc.manager_data,
              value: '${war!.manager.firstName} ${war!.manager.lastName}',
              icon: Icons.person,
              editIcon: Icons.edit,
              onEdit: () => _showEditManagerBottomSheet(
                firstName: war!.manager.firstName,
                lastName: war!.manager.lastName,
                onSave: (first, last) {
                  setState(() {
                    war = war!.copyWith(
                      manager: war!.manager.copyWith(
                        firstName: first,
                        lastName: last,
                      ),
                    );
                  });
                },
              ),
            ),
            _infoCard(
              title: loc.address,
              value: war!.address.address,
              icon: Icons.location_on_outlined,
              editIcon: Icons.edit,
              onEdit: _selectAddress,
            ),
            // _infoCard(
            //   title: loc.your_warehouse,
            //   value: war!.isMain ? loc.accept : loc.cancel,
            //   icon: Icons.check_circle_outline,
            //   onEdit: () => setState(() {
            //     war = war!.copyWith(isMain: !war!.isMain);
            //   }),
            // ),
            _infoCard(
              title: loc.date,
              value: formatDateTime(war!.createdAt),
              icon: Icons.calendar_today_outlined,
              onEdit: null,
            ),
            const SizedBox(height: 20),
            _isSaving
                ? const CircularProgressIndicator(color: ThemeColors.orange)
                : CustomButton(
                    text: loc.save,
                    onPressed: () async {
                      setState(() => _isSaving = true);
                      try {
                        await _warehouseService.updateWarehouse(
                          context,
                          war!.id,
                          war!,
                        );

                        if (context.mounted) {
                          Navigator.of(context).pop(true);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(loc.success),
                              backgroundColor: ThemeColors.green,
                            ),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${loc.error}: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } finally {
                        if (mounted) setState(() => _isSaving = false);
                      }
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard({
    required String title,
    required String value,
    required IconData icon,
    VoidCallback? onEdit,
    IconData? editIcon,
  }) {
    return Card(
      color: Colors.grey.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 0,
      child: ListTile(
        leading: Icon(icon, color: ThemeColors.orange),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(value, style: const TextStyle(fontSize: 15)),
        trailing: onEdit != null && editIcon != null
            ? IconButton(
                icon: Icon(editIcon),
                color: ThemeColors.orange,
                onPressed: onEdit,
              )
            : null,
      ),
    );
  }

  void _showEditBottomSheet(
      String title, String initialValue, void Function(String) onSave) {
    final controller = TextEditingController(text: initialValue);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 20),
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Введите значение...',
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: CustomButton(
                  text: S.of(context).save,
                  onPressed: () {
                    onSave(controller.text);
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
