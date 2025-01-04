import 'package:envirosense/core/constants/colors.dart';
import 'package:envirosense/core/enums/limit_type.dart';
import 'package:envirosense/domain/entities/air_data.dart';
import 'package:envirosense/domain/entities/room_air_quality.dart';
import 'package:envirosense/domain/entities/room.dart';
import 'package:envirosense/presentation/controllers/device_controller.dart';
import 'package:envirosense/presentation/controllers/outside_air_data_controller.dart';
import 'package:envirosense/presentation/controllers/room_controller.dart';
import 'package:envirosense/presentation/widgets/feedback/custom_snackbar.dart';
import 'package:envirosense/presentation/widgets/lists/device_list.dart';
import 'package:envirosense/presentation/widgets/cards/enviro_score_card.dart';
import 'package:envirosense/presentation/widgets/data/environment_data_section.dart';
import 'package:envirosense/presentation/widgets/feedback/loading_error_widget.dart';
import 'package:envirosense/presentation/widgets/core/custom_app_bar.dart';
import 'package:envirosense/presentation/widgets/tabs/room_actions_tab.dart';
import 'package:envirosense/presentation/widgets/actions/target_temperature_button.dart';
import 'package:envirosense/presentation/widgets/dialogs/target_temperature_sheet.dart';
import 'package:envirosense/services/room_service.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RoomOverviewScreen extends StatefulWidget {
  String roomName;
  final String roomId;

  RoomOverviewScreen({super.key, required this.roomName, required this.roomId});

  @override
  State<RoomOverviewScreen> createState() => _RoomOverviewScreenState();
}

class _RoomOverviewScreenState extends State<RoomOverviewScreen>
    with SingleTickerProviderStateMixin {
  late final RoomController _roomController = RoomController();
  late final DeviceController _deviceController = DeviceController();
  late final OutsideAirDataController _outsideAirController =
      OutsideAirDataController();
  late final TabController _tabController =
      TabController(length: _tabs.length, vsync: this);

  bool _isLoading = true;
  bool _showRoomData = true;
  bool _roomHasDeviceData = false;
  double _targetTemperature = 22.0; // hardcoded for now

  Room? _room;
  RoomAirQuality? _airQuality;
  AirData? _outsideAirData;
  String? _error;
  String city = 'Brugge'; //TODO: later in poc we would get city from user

  final List<Tab> _tabs = const [
    Tab(text: 'Overview'),
    Tab(text: 'Devices'),
    Tab(text: 'Actions'),
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() => _isLoading = true);
      final room = await _roomController.getRoom(widget.roomId);
      final airQuality = await _roomController.getRoomAirQuality(widget.roomId);
      final outsideAirData =
          await _outsideAirController.getOutsideAirData(city);
      setState(() {
        _room = room;
        _airQuality = airQuality;
        _outsideAirData = outsideAirData;
        _isLoading = false;
        _roomHasDeviceData = isDeviceDataAvailable();
        _showRoomData = _roomHasDeviceData;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  bool isDeviceDataAvailable() {
    return _airQuality?.enviroScore != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: _room?.name ?? widget.roomName,
        tabController: _tabController,
        tabs: _tabs,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: LoadingErrorWidget(
        isLoading: _isLoading,
        error: _error,
        onRetry: _loadData,
        child: TabBarView(
          controller: _tabController,
          children: [
            RefreshIndicator(
              onRefresh: _loadData,
              color: AppColors.secondaryColor,
              child: _buildOverviewTab(),
            ),
            RefreshIndicator(
              onRefresh: _loadData,
              color: AppColors.secondaryColor,
              child: DevicesList(devices: _room?.devices ?? []),
            ),
            _buildActionsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    if (_outsideAirData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        EnviroScoreCard(
          score: _airQuality?.enviroScore ?? 0,
          isDataAvailable: _roomHasDeviceData,
          type: 'Room',
        ),
        const SizedBox(height: 24),
        TargetTemperatureButton(
          temperature: _targetTemperature,
          onPressed: () => _showTargetTemperatureSheet(context),
        ),
        const SizedBox(height: 24),
        EnvironmentDataSection(
          showRoomData: _showRoomData,
          roomHasDeviceData: _roomHasDeviceData,
          onToggleData: (value) => setState(() => _showRoomData = value),
          roomData: _airQuality?.airData ??
              AirData(temperature: 0, humidity: 0, ppm: 0),
          outsideData: _outsideAirData!,
        ),
      ],
    );
  }

  Widget _buildActionsTab() {
    return RoomActionsTab(
      roomName: widget.roomName,
      roomId: _room?.id ?? '',
      roomService: RoomService(_roomController),
      onRoomRenamed: (newName) {
        setState(() {
          widget.roomName = newName; // This updates the header
        });
      },
      onRoomRemoved: () => Navigator.pop(context),
    );
  }

  void _showTargetTemperatureSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => TargetTemperatureSheet(
              currentTemperature: _targetTemperature,
              onTemperatureChanged: _handleTemperatureLimitChanged,
            ));
  }

  void _handleTemperatureLimitChanged(double newTemperature) async {
    try {
      await _deviceController.updateDeviceLimit(
          widget.roomId, LimitType.temperature, newTemperature);
      setState(() => _targetTemperature = newTemperature);
    } catch (e) {
      if (mounted) {
        CustomSnackbar.showSnackBar(
            context, 'Failed to update temperature limit');
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
