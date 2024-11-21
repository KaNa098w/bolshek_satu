import 'package:flutter/material.dart';
import 'package:bolshek_pro/core/models/category_response.dart' as category;

class CategoryModal extends StatelessWidget {
  final List<category.CategoryItems> categories; // Уточнить тип через псевдоним
  final Function(String) onCategorySelected;

  const CategoryModal({
    Key? key,
    required this.categories,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String searchQuery = '';
    return StatefulBuilder(
      builder: (context, setStateModal) {
        final filteredCategories = categories
            .where((categoryItem) =>
                categoryItem.name != null &&
                categoryItem.name!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()))
            .toList();
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Поиск категории',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 12,
                          ),
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
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredCategories.length,
                    itemBuilder: (context, index) {
                      final categoryItem = filteredCategories[index];
                      return ListTile(
                        title: Text(categoryItem.name ?? 'Без названия'),
                        onTap: () {
                          Navigator.pop(context);
                          onCategorySelected(
                              categoryItem.name ?? 'Без названия');
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
  }
}
