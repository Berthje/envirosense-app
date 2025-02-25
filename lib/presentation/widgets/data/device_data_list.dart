import 'package:envirosense/presentation/widgets/actions/pagination_controls.dart';
import 'package:envirosense/presentation/widgets/cards/device_data_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/constants/colors.dart';
import '../../../../domain/entities/device_data.dart';

class DeviceDataList extends StatefulWidget {
  final List<DeviceData> deviceData;
  final Future<void> Function() onRefresh;

  const DeviceDataList({
    super.key,
    required this.deviceData,
    required this.onRefresh,
  });

  @override
  State<DeviceDataList> createState() => _DeviceDataListState();
}

class _DeviceDataListState extends State<DeviceDataList> {
  static const int itemsPerPage = 6;
  int currentPage = 1;

  int get totalPages => (widget.deviceData.length / itemsPerPage).ceil();

  List<DeviceData> get currentPageItems {
    final startIndex = (currentPage - 1) * itemsPerPage;
    final endIndex = startIndex + itemsPerPage;
    return widget.deviceData.sublist(
      startIndex,
      endIndex > widget.deviceData.length ? widget.deviceData.length : endIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      color: AppColors.secondaryColor,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (widget.deviceData.isEmpty)
                  Center(
                    child: Text(
                      l10n.noDeviceData,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.accentColor,
                      ),
                    ),
                  )
                else
                  ...currentPageItems.map(
                    (data) => DeviceDataCard(
                      data: data,
                      isNewest: widget.deviceData.first == data,
                    ),
                  ),
              ],
            ),
          ),
          if (widget.deviceData.isNotEmpty)
            PaginationControls(
              currentPage: currentPage,
              totalPages: totalPages,
              onPageChanged: (page) => setState(() => currentPage = page),
            ),
        ],
      ),
    );
  }
}
