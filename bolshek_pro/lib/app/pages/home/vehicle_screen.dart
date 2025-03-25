// lib/app/pages/vehicle_brands_page.dart
import 'package:bolshek_pro/app/pages/home/model_screen.dart';
import 'package:bolshek_pro/app/widgets/custom_silver_appbar.dart';
import 'package:bolshek_pro/app/widgets/loading_widget.dart';
import 'package:bolshek_pro/core/service/vehicle_brands_service.dart';
import 'package:bolshek_pro/core/models/vehicle_brands_response.dart';
import 'package:flutter/material.dart';

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

class VehicleBrandsPage extends StatefulWidget {
  const VehicleBrandsPage({Key? key}) : super(key: key);

  @override
  _VehicleBrandsPageState createState() => _VehicleBrandsPageState();
}

class _VehicleBrandsPageState extends State<VehicleBrandsPage> {
  final VehicleBrandsService _vehicleBrands = VehicleBrandsService();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  List<Items> _brands = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _skip = 0;
  final int _take = 100;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadInitialBrands();
    _scrollController.addListener(() {
      // Подгружаем данные только если поиск не активен
      if (_searchQuery.isEmpty &&
          _scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_isLoading &&
          _hasMore) {
        _fetchBrands();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialBrands() async {
    // Загружаем 4 страницы по 100 элементов (например, всего 400)
    for (int i = 0; i < 4; i++) {
      await _fetchBrands();
    }
  }

  Future<void> _fetchBrands() async {
    setState(() {
      _isLoading = true;
    });
    try {
      // Запрос идёт без передачи параметра name, так как поиск происходит локально
      final response = await _vehicleBrands.fetchVehicleBrands(
        context: context,
        take: _take,
        skip: _skip,
      );
      final fetchedBrands = response.items ?? [];
      setState(() {
        _skip += _take;
        _brands.addAll(fetchedBrands);
        if (fetchedBrands.length < _take) {
          _hasMore = false;
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Ошибка: $e")));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isSearching = _searchQuery.isNotEmpty;
    final searchQueryLower = _searchQuery.toLowerCase();

    // Фильтрация по name и aliases (если aliases присутствуют)
    final List<Items> displayedBrands = isSearching
        ? _brands.where((brand) {
            final name = brand.name?.toLowerCase() ?? '';
            bool matchesName = name.contains(searchQueryLower);
            bool matchesAliases = false;
            if (brand.aliases != null) {
              for (var aliasItem in brand.aliases!) {
                if (aliasItem is String) {
                  // Если aliasItem — строка, проверяем её напрямую.
                  if (aliasItem.toLowerCase().contains(searchQueryLower)) {
                    matchesAliases = true;
                    break;
                  }
                } else if (aliasItem is List) {
                  // Явно приводим aliasItem к List, чтобы избежать ошибки.
                  for (var alias in aliasItem as List) {
                    if (alias is String &&
                        alias.toLowerCase().contains(searchQueryLower)) {
                      matchesAliases = true;
                      break;
                    }
                  }
                  if (matchesAliases) break;
                }
              }
            }

            return matchesName || matchesAliases;
          }).toList()
        : _brands;

    return Scaffold(
      backgroundColor: Colors.white,
      // Оборачиваем всё содержимое в GestureDetector для снятия фокуса с поля поиска
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Кастомный SliverAppBar
            const CustomStyledSliverAppBar(
              title: 'Марка автомобилей',
              automaticallyImplyLeading: true,
            ),
            // Закреплённая поисковая строка
            SliverPersistentHeader(
              pinned: true,
              delegate: SearchBarDelegate(
                height: 60,
                child: Container(
                  color: Colors.grey[100],
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: TextField(
                    controller: _searchController,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: 'Поиск по марке',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onChanged: _onSearchChanged,
                  ),
                ),
              ),
            ),
            // Список марок
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final brand = displayedBrands[index];
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
                      child: ListTile(
                        dense: true,
                        visualDensity: const VisualDensity(vertical: -4),
                        onTap: () {
                          Navigator.push<String>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ModelPage(
                                brandId: brand.id ?? '',
                                brandName: brand.name ?? '',
                              ),
                            ),
                          ).then((resultFromModelPage) {
                            // Если result не null, значит на ModelPage дошли до конца
                            if (resultFromModelPage != null) {
                              // Возвращаемся на CrossNumberScreen
                              Navigator.pop(context, resultFromModelPage);
                            }
                          });
                        },
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 20),
                        title: Text(
                          brand.name ?? 'Без названия',
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
                childCount: displayedBrands.length,
              ),
            ),
            // Если не производится поиск и данные загружаются, добавляем индикатор загрузки,
            // расположенный по центру оставшегося пространства
            if (!isSearching && _hasMore && _isLoading)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.grey,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
