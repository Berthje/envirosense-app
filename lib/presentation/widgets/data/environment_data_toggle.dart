import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';

class EnvironmentDataToggle extends StatelessWidget {
  final bool showRoomData;
  final bool roomHasDeviceData;
  final Function(bool) onToggle;

  const EnvironmentDataToggle({
    super.key,
    required this.showRoomData,
    required this.roomHasDeviceData,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.accentColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: roomHasDeviceData ? () => onToggle(true) : null,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: showRoomData && roomHasDeviceData
                      ? AppColors.secondaryColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  'Room Data',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: showRoomData && roomHasDeviceData
                        ? AppColors.whiteColor
                        : AppColors.secondaryColor
                            .withOpacity(roomHasDeviceData ? 1.0 : 0.5),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onToggle(false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !showRoomData
                      ? AppColors.secondaryColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  'Outside Data',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: !showRoomData
                        ? AppColors.whiteColor
                        : AppColors.secondaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
