import 'package:envirosense/presentation/widgets/dialogs/clear_cache_warning_dialog.dart';
import 'package:envirosense/presentation/widgets/models/cache_option.dart';
import 'package:envirosense/services/auth_service.dart';
import 'package:envirosense/services/database_service.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../items/cache_option_item.dart';

class ClearCacheOptionsSheet extends StatefulWidget {
  const ClearCacheOptionsSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColors.transparent,
      builder: (context) => const ClearCacheOptionsSheet(),
    );
  }

  @override
  State<ClearCacheOptionsSheet> createState() => _ClearCacheOptionsSheetState();
}

class _ClearCacheOptionsSheetState extends State<ClearCacheOptionsSheet> {
  final List<CacheOption> cacheOptions = [
    CacheOption(
      title: 'Device Data',
      subtitle: 'Clear stored sensor readings',
    ),
    CacheOption(
      title: 'Device Names',
      subtitle: 'Reset device names to default',
    ),
    CacheOption(
      title: 'All',
      subtitle: 'Clear all stored data and preferences',
      isHighImpact: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    bool isSelected = cacheOptions.any((option) => option.isSelected);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.accentColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Clear Cache',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Select the cache you want to remove',
                  style: TextStyle(
                    color: AppColors.accentColor,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 24),
                ...cacheOptions.map(
                  (option) => CacheOptionItem(
                    option: option,
                    onTap: () => _handleOptionSelection(option),
                  ),
                ),
              ],
            ),
          ),
          Divider(color: AppColors.accentColor.withOpacity(0.2)),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: AppColors.secondaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: AppColors.secondaryColor),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FilledButton(
                      onPressed: isSelected ? _handleClearCache : null,
                      style: FilledButton.styleFrom(
                        backgroundColor: isSelected ? AppColors.secondaryColor : AppColors.secondaryColor.withOpacity(0.5),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Clear Cache',
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleOptionSelection(CacheOption option) {
    setState(() {
      if (option.title == 'All') {
        // When "All" is selected/deselected, update all other options
        bool newValue = !option.isSelected;
        for (var opt in cacheOptions) {
          opt.isSelected = newValue;
        }
      } else {
        option.isSelected = !option.isSelected;
        // If all individual options are selected, select "All" as well
        CacheOption allOption = cacheOptions.firstWhere((opt) => opt.title == 'All');
        if (cacheOptions.where((opt) => opt.title != 'All').every((opt) => opt.isSelected)) {
          allOption.isSelected = true;
        } else {
          allOption.isSelected = false;
        }
      }
    });
  }

  void _handleClearCache() async {
    if (!cacheOptions.any((option) => option.isSelected)) return;

    final DatabaseService dbService = DatabaseService();
    final AuthService authService = AuthService();

    final hasHighImpactSelection = cacheOptions.where((opt) => opt.isSelected).any((opt) => opt.isHighImpact);

    if (hasHighImpactSelection) {
      final confirmed = await ClearCacheWarningDialog.show(context);
      if (!confirmed) return;
    }

    if (!mounted) return;
    Navigator.pop(context);

    for (final option in cacheOptions) {
      if (option.isSelected) {
        if (option.title == 'Device Data') {
          await dbService.clearDeviceDataCache();
        } else if (option.title == 'Device Names') {
          await dbService.clearDeviceNames();
        } else if (option.title == 'All') {
          await dbService.clearAll();
          await authService.signOut(context);
        }
      }
    }
  }
}
