import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:envirosense/core/constants/colors.dart';
import 'package:envirosense/core/enums/add_option_type.dart';
import 'package:envirosense/domain/entities/device.dart';
import 'package:envirosense/domain/entities/room.dart';
import 'package:envirosense/presentation/controllers/room_controller.dart';
import 'package:envirosense/presentation/widgets/dialogs/add_options_bottom_sheet.dart';
import 'package:envirosense/presentation/widgets/cards/device_card.dart';
import 'package:envirosense/presentation/widgets/feedback/custom_snackbar.dart';
import 'package:envirosense/presentation/widgets/layout/header.dart';
import 'package:envirosense/presentation/widgets/lists/item_grid_page.dart';
import 'package:envirosense/presentation/widgets/cards/room_card.dart';
import 'package:flutter/material.dart';
import 'package:envirosense/presentation/controllers/device_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTabIndex = 0;
  List<Room> _allRooms = [];
  List<Device> _allDevices = [];
  final RoomController _roomController = RoomController();
  final DeviceController _deviceController = DeviceController();

  final String _buildingId =
      "gox5y6bsrg640qb11ak44dh0"; //hardcoded here, but later outside PoC we would retrieve this from user that is linked to what building

  @override
  void initState() {
    super.initState();
    _getRooms();
    _getDevices();
  }

  Future<void> _refreshData() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();

      if (!mounted) return;

      if (connectivityResult == ConnectivityResult.none) {
        CustomSnackbar.showSnackBar(
          context,
          'No internet connection available',
        );
        return;
      }

      await Future.wait([
        _getRooms(),
        _getDevices(),
      ]);
    } catch (e) {
      if (!mounted) return;
      CustomSnackbar.showSnackBar(
        context,
        'Failed to refresh data',
      );
    }
  }

  Future<void> _getRooms() async {
    final rooms = await _roomController.getRooms();
    setState(() {
      _allRooms = rooms;
    });
  }

  Future<void> _getDevices() async {
    final devices = await _deviceController.getDevices(_buildingId);
    setState(() {
      _allDevices = devices;
    });
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  void _showAddOptionsBottomSheet(AddOptionType? preferredOption) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (_) => AddOptionsBottomSheet(
        preferredOption: preferredOption,
        onItemAdded: () {
          _refreshData();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Column(
        children: [
          Header(
            selectedTabIndex: _selectedTabIndex,
            onTabSelected: _onTabSelected,
          ),
          if (_selectedTabIndex == 0)
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshData,
                color: AppColors.secondaryColor,
                child: ItemGridPage<Room>(
                  allItems: _allRooms,
                  itemBuilder: (room) => RoomCard(
                    room: room,
                    onChanged: _refreshData,
                  ),
                  getItemName: (room) => room.name,
                  onAddPressed: () {
                    _showAddOptionsBottomSheet(AddOptionType.room);
                  },
                  onItemChanged: _refreshData,
                ),
              ),
            ),
          if (_selectedTabIndex == 1)
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshData,
                color: AppColors.secondaryColor,
                child: ItemGridPage<Device>(
                  allItems: _allDevices,
                  itemBuilder: (device) => DeviceCard(device: device, onChanged: _refreshData),
                  getItemName: (device) => device.identifier,
                  onAddPressed: () {
                    _showAddOptionsBottomSheet(AddOptionType.device);
                  },
                  onItemChanged: _refreshData,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
