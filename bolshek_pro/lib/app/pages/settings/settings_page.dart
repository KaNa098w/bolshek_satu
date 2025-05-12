import 'package:bolshek_pro/app/pages/auth/auth_main_page.dart';
import 'package:bolshek_pro/app/pages/settings/settings_widget/warehouse_edit_page.dart';
import 'package:bolshek_pro/app/pages/settings/settings_widget/warehouse_page.dart';
import 'package:bolshek_pro/app/widgets/custom_alert_dialog_widget.dart';
import 'package:bolshek_pro/app/widgets/custom_button.dart';
import 'package:bolshek_pro/app/widgets/loading_widget.dart';
import 'package:bolshek_pro/core/models/auth_session_response.dart';
import 'package:bolshek_pro/core/models/address_response.dart';
import 'package:bolshek_pro/core/models/organization_members_response.dart';
import 'package:bolshek_pro/core/models/warehouse_response.dart';
import 'package:bolshek_pro/core/service/address_service.dart';
import 'package:bolshek_pro/core/service/auth_service.dart';
import 'package:bolshek_pro/core/service/my_organization_service.dart';
import 'package:bolshek_pro/core/service/warehouse_service.dart';
import 'package:bolshek_pro/core/utils/locale_provider.dart';
import 'package:bolshek_pro/core/utils/provider.dart';
import 'package:bolshek_pro/core/utils/theme.dart';
import 'package:bolshek_pro/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class MyOrganizationPage extends StatefulWidget {
  @override
  _MyOrganizationPageState createState() => _MyOrganizationPageState();
}

class _MyOrganizationPageState extends State<MyOrganizationPage> {
  late Future<AuthSessionResponse> _authSessionFuture;
  // late Future<AddressResponse> _addressFuture;
  // late Future<OrganizationMembersResponse> _membersFuture;
  late Future<WarehouseResponse> _warehousesFuture;
  final _warehouseService = WarehouseService();
  
  @override
  void initState() {
    super.initState();
    _authSessionFuture = AuthService().fetchAuthSession(context);
    _authSessionFuture.then((data) {
      final organizationId = data.user?.organization?.id;
      if (organizationId != null) {
  context.read<GlobalProvider>().setOrganizationId(organizationId);
  _warehousesFuture = _warehouseService.getWarehouses(context, organizationId);
}
      if (organizationId != null) {
        _warehousesFuture =
            _warehouseService.getWarehouses(context, organizationId);
      }
    });
  }

    Future<void> _openWhatsAppChat() async {
    const phoneNumber = '77001012200';
    final Uri whatsappUri = Uri.parse('https://wa.me/$phoneNumber');

    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(
        whatsappUri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).support),
        ),
      );
    }
  }

  Future<void> _logout(S localizations) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => CustomAlertDialog(
        title: localizations.logout_title,
        content: Text(localizations.logout_confirmation),
        onConfirm: () => Navigator.pop(context, true),
        onCancel: () => Navigator.pop(context, false),
      ),
    );
    if (confirm == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('organization_name');
      await context.read<GlobalProvider>().logout();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => AuthMainScreen()),
        (route) => false,
      );
    }
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'ru':
        return 'Русский';
      case 'en':
        return 'English';
      case 'kk':
        return 'Қазақ';
      case 'zh':
        return '中文';
      case 'ar':
        return 'العربية';
      default:
        return code;
    }
  }

  void _showLanguageSelectionDialog(BuildContext context, S localizations) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (_) => SimpleDialog(
        title: Text(localizations.choose_language),
        children: [
          ...['ru', 'en', 'kk', 'zh', 'ar'].map((code) => SimpleDialogOption(
                onPressed: () {
                  localeProvider.setLocale(Locale(code));
                  Navigator.pop(context);
                },
                child: Text(_getLanguageName(code)),
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = S.of(context);

    return Scaffold(
      backgroundColor: ThemeColors.white,
      body: FutureBuilder<AuthSessionResponse>(
        future: _authSessionFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final data = snapshot.data!;
          final organization = data.user?.organization;
          if (organization == null) {
            return Center(
              child: Text(localizations.org_info_missing),
            );
          }

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(
                    title: localizations.org_name_label,
                    value: organization.name ?? localizations.unknown,
                  ),
                  _buildInfoRow(
                    title: localizations.owner_label,
                    value: '${data.user?.firstName} ${data.user?.lastName}',
                  ),
                  _buildInfoRow(
                    title: localizations.phone_label,
                    value: data.user?.phoneNumber ?? '',
                  ),
                  Row(
                    children: [
                      Text(
                        '${localizations.choose_language}: ',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Consumer<LocaleProvider>(
                        builder: (_, localeProvider, __) => Text(
                          _getLanguageName(localeProvider.locale.languageCode),
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () => _showLanguageSelectionDialog(
                            context, localizations),
                        child: Text(
                          localizations.change_language,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Список складов
          // Список складов или сообщение о недоступности
if (!data.permissions!.contains('warehouse_read')) ...[
  Text(
    localizations.your_warehouse,
    style: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
  ),
  const SizedBox(height: 8),
  Center(
    child: Text(localizations.no_access),
  ),
] else ...[
  Text(
    localizations.your_warehouse,
    style: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
  ),
  const SizedBox(height: 8),
  FutureBuilder<WarehouseResponse>(
    future: _warehousesFuture,
    builder: (context, whSnap) {
      if (whSnap.connectionState == ConnectionState.waiting) {
        return const Center(
          child: LoadingWidget(width: 400, height: 80),
        );
      } else if (whSnap.hasError) {
        return Center(
          child: Text('Ошибка: ${whSnap.error}'),
        );
      } else if (!whSnap.hasData || whSnap.data!.items.isEmpty) {
        return Center(
          child: Text(localizations.empty),
        );
      }

      final warehouses = whSnap.data!.items;
      return Column(
        children: warehouses.map((wh) {
          return Card(
            color: Colors.grey.shade100,
            elevation: 0,
            margin: const EdgeInsets.symmetric(vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              title: Text(wh.name),
              subtitle: Row(
                children: [
                  Text(
                    wh.address.address.replaceFirst(
                      RegExp(r'^Казахстан\s*,\s*'), ''),
                  ),
                ],
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WarehouseEditPage(id: wh.id),
                  ),
                );

                if (result == true) {
                  setState(() {
                    _warehousesFuture = _warehouseService.getWarehouses(
                      context,
                      organization.id!,
                    );
                  });
                }
              },
            ),
          );
        }).toList(),
      );
    },
  ),
],


                  const SizedBox(height: 20),

if (data.permissions!.contains('warehouse_read'))
SizedBox(
  width: double.infinity,
  child: CustomButton(
    text: data.permissions!.contains('warehouse_read')
        ? localizations.add_warehouse
        : localizations.request_permission,
    onPressed: data.permissions!.contains('warehouse_read')
        ? () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => WarehousePage(
                  organizationId: organization.id!,
                ),
              ),
            );

            if (result == true) {
              setState(() {
                _warehousesFuture = _warehouseService.getWarehouses(
                  context,
                  organization.id!,
                );
              });
            }
          }
        : () {
    //  _openWhatsAppChat();
          },
  ),
),

                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () => _logout(localizations),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 0.1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        localizations.logout_button,
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow({
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 15, color: Colors.grey)),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
