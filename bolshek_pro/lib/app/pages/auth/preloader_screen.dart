import 'package:bolshek_pro/app/pages/auth/auth_main_page.dart';
import 'package:bolshek_pro/app/widgets/main_controller.dart';
import 'package:bolshek_pro/core/service/auth_service.dart';
import 'package:bolshek_pro/core/utils/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PreloaderScreen extends StatefulWidget {
  const PreloaderScreen({Key? key}) : super(key: key);

  @override
  State<PreloaderScreen> createState() => _PreloaderScreenState();
}

class _PreloaderScreenState extends State<PreloaderScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      final globalProvider = context.read<GlobalProvider>();

      // Загружаем authResponse из локалки
      await globalProvider.loadAuthData(context);

      final auth = globalProvider.authResponse;

      // Если токена нет — редирект на экран авторизации
      if (auth == null || auth.token == null ) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => AuthMainScreen()),
        );
        return;
      }

      // Иначе — грузим сессии
      final authSession = await AuthService().fetchAuthSession(context);

      final orgName = authSession.user?.organization?.name ?? 'Без названия';
      final warehouseId = authSession.user?.warehouses?.first.id ?? '';
      final managerName = authSession.user?.roles?.first.role?.name ?? '';
      final permissions = authSession.permissions ?? [];

      globalProvider.setPermissions(permissions);
      globalProvider.getWarehouseId(warehouseId);
      globalProvider.getManager(managerName);
      globalProvider.setOrganizationName(orgName);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainControllerNavigator()),
      );
    } catch (e) {
      print('Ошибка инициализации: $e');
      // При любой ошибке отправим на экран авторизации
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => AuthMainScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 100),
        child: Center(child: Image.asset('assets/icons/main.png')),
      ),
    );
  }
}
