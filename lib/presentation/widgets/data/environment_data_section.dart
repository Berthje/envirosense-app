import 'package:envirosense/presentation/widgets/data/data_display_box.dart';
import 'package:envirosense/presentation/widgets/data/environment_data_toggle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../domain/entities/air_data.dart';

class EnvironmentDataSection extends StatelessWidget {
  final bool showRoomData;
  final bool roomHasDeviceData;
  final Function(bool) onToggleData;
  final AirData roomData;
  final AirData outsideData;

  const EnvironmentDataSection({
    super.key,
    required this.showRoomData,
    required this.roomHasDeviceData,
    required this.onToggleData,
    required this.roomData,
    required this.outsideData,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          EnvironmentDataToggle(
            showRoomData: showRoomData,
            roomHasDeviceData: roomHasDeviceData,
            onToggle: onToggleData,
          ),
          const SizedBox(height: 32),
          DataDisplayBox(
            key: ValueKey(showRoomData),
            title: showRoomData ? l10n.roomEnvironment : l10n.outsideEnvironment,
            data: showRoomData && roomHasDeviceData ? roomData : outsideData,
          )
        ],
      ),
    );
  }
}
