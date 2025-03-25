// lib/app/pages/model_page.dart
import 'package:bolshek_pro/app/pages/home/vehicle_generation_screen.dart';
import 'package:bolshek_pro/core/models/model_response.dart';
import 'package:bolshek_pro/core/service/model_service.dart';
import 'package:bolshek_pro/app/widgets/custom_silver_appbar.dart';
import 'package:flutter/material.dart';

class ModelPage extends StatefulWidget {
  final String brandId;
  final String brandName;

  const ModelPage({Key? key, required this.brandId, required this.brandName})
      : super(key: key);

  @override
  _ModelPageState createState() => _ModelPageState();
}

class _ModelPageState extends State<ModelPage> {
  late Future<ModelResponse> _futureModels;
  final ModelService _modelService = ModelService();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _futureModels = _loadModels();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<ModelResponse> _loadModels() async {
    // Первый запрос: skip = 0, take = 100
    final response1 = await _modelService.fetchModelWithBrand(
      context: context,
      brandId: widget.brandId,
      take: 100,
      skip: 0,
    );
    // Второй запрос: skip = 100, take = 100
    final response2 = await _modelService.fetchModelWithBrand(
      context: context,
      brandId: widget.brandId,
      take: 100,
      skip: 100,
    );
    // Объединяем оба списка
    final List<Items> combined = [];
    if (response1.items != null) {
      combined.addAll(response1.items!);
    }
    if (response2.items != null) {
      combined.addAll(response2.items!);
    }
    return ModelResponse(items: combined);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<ModelResponse>(
        future: _futureModels,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.grey),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          } else if (!snapshot.hasData ||
              snapshot.data?.items == null ||
              snapshot.data!.items!.isEmpty) {
            return const Center(child: Text('Модели не найдены.'));
          } else {
            final items = snapshot.data!.items!;
            final searchQueryLower = _searchQuery.toLowerCase();
            // Фильтруем модели по названию
            final displayedModels = _searchQuery.isNotEmpty
                ? items.where((model) {
                    final name = model.name?.toLowerCase() ?? '';
                    return name.contains(searchQueryLower);
                  }).toList()
                : items;
            return CustomScrollView(
              slivers: [
                // Кастомный SliverAppBar с названием бренда
                CustomStyledSliverAppBar(
                  title: widget.brandName,
                  automaticallyImplyLeading: true,
                ),
                // Закреплённая поисковая строка
                SliverPersistentHeader(
                  pinned: true,
                  delegate: SearchBarDelegate(
                    height: 60,
                    child: Container(
                      color: Colors.grey[100],
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      child: TextField(
                        controller: _searchController,
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                          hintText: 'Поиск по модели',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                // Список моделей
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final model = displayedModels[index];
                      return Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey.shade200,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Card(
                          color: Colors.white,
                          elevation: 0,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 0),
                          child: ListTile(
                            onTap: () {
                              Navigator.push<String>(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VehicleGenerationPage(
                                    modelId: model.id ?? '',
                                    modelName: model.name ?? '',
                                    brandName: widget.brandName,
                                  ),
                                ),
                              ).then((resultFromGenPage) {
                                if (resultFromGenPage != null) {
                                  // Собираем полную строку,
                                  // либо сразу передаем resultFromGenPage, если там уже все готово
                                  final fullResult = resultFromGenPage;
                                  // Поднимаемся на VehicleBrandsPage
                                  Navigator.pop(context, fullResult);
                                }
                              });
                            },
                            dense: true,
                            visualDensity: const VisualDensity(vertical: -4),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 1),
                            title: Text(
                              model.name ?? 'Без названия',
                              style: const TextStyle(fontSize: 15),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: displayedModels.length,
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

/// Делегат для закреплённой поисковой строки.
class SearchBarDelegate extends SliverPersistentHeaderDelegate {
  final double height;
  final Widget child;

  SearchBarDelegate({required this.height, required this.child});

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(covariant SearchBarDelegate oldDelegate) {
    return oldDelegate.height != height || oldDelegate.child != child;
  }
}
