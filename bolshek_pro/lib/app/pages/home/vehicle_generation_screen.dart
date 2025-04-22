import 'package:bolshek_pro/core/models/vehicle_generation_response.dart';
import 'package:bolshek_pro/app/widgets/custom_silver_appbar.dart';
import 'package:bolshek_pro/core/service/vehicle_generation_servcie.dart';
import 'package:bolshek_pro/generated/l10n.dart';
import 'package:flutter/material.dart';

class VehicleGenerationPage extends StatefulWidget {
  final String modelId;
  final String modelName;
  final String brandName;

  const VehicleGenerationPage(
      {Key? key,
      required this.modelId,
      required this.modelName,
      required this.brandName})
      : super(key: key);

  @override
  _VehicleGenerationPageState createState() => _VehicleGenerationPageState();
}

class _VehicleGenerationPageState extends State<VehicleGenerationPage> {
  late Future<VehicleGenerationResponse> _futureGenerations;
  final VehicleGenerationService _generationService =
      VehicleGenerationService();

  @override
  void initState() {
    super.initState();
    // Выполняем запрос для получения моделей по бренду
    _futureGenerations = _generationService.fetchVehicleGenerations(
      context: context,
      modelId: widget.modelId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final local = S.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<VehicleGenerationResponse>(
        future: _futureGenerations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: Colors.grey,
            ));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData ||
              snapshot.data?.items == null ||
              snapshot.data!.items!.isEmpty) {
            return Center(child: Text(local.order_data_not_found));
          } else {
            final items = snapshot.data!.items!;
            return CustomScrollView(
              slivers: [
                // Используем кастомный SliverAppBar с именем бренда
                CustomStyledSliverAppBar(
                  title: widget.modelName,
                  automaticallyImplyLeading: true,
                ),
                // Список моделей
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final vehicle = items[index];
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
                            dense: true,
                            onTap: () {
                              // Собираем какую-нибудь строку
                              final generationString =
                                  '${widget.brandName},${widget.modelName},${vehicle.name},${vehicle.id}';
                              Navigator.pop(
                                context,
                                generationString,
                              );
                              print(generationString);
                            },
                            visualDensity: const VisualDensity(vertical: -4),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 4),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment
                                  .start, // Добавлено для выравнивания по левому краю
                              children: [
                                Text(
                                  vehicle.name ?? local.no_name,
                                  style: const TextStyle(fontSize: 15),
                                ),
                                Row(
                                  children: [
                                    Text('${vehicle.startYear.toString()}'),
                                    if (vehicle.endYear != null)
                                      Text(' - ${vehicle.endYear.toString()}'),
                                  ],
                                )
                              ],
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
                    childCount: items.length,
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
