import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:envirosense/core/helpers/connectivity_helper.dart';
import 'package:envirosense/core/helpers/data_status_helper.dart';
import 'package:envirosense/domain/entities/building_air_quality.dart';
import 'package:envirosense/main.dart';
import 'package:envirosense/presentation/controllers/building_controller.dart';
import 'package:envirosense/presentation/widgets/cards/enviro_score_card.dart';
import 'package:envirosense/presentation/widgets/feedback/loading_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:envirosense/core/constants/colors.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> with RouteAware {
  late final BuildingController _buildingController = BuildingController();
  final String buildingId =
      "gox5y6bsrg640qb11ak44dh0"; //hardcoded here, but later outside PoC we would retrieve this from user that is linked to what building
  BuildingAirQuality _buildingAirQuality = BuildingAirQuality(enviroScore: 0.0, roomsAirQuality: []);
  bool _buildingHasData = false;
  bool _buildingHasRooms = false;
  bool _isLoading = true;
  String? _error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    _loadData(); // Reload when returning to this screen
    super.didPopNext();
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (!mounted) return;

    try {
      setState(() => _isLoading = true);

      final hasConnection = await ConnectivityHelper.checkConnectivity(
        context,
        setError: (error) => setState(() => _error = error),
        setLoading: (loading) => setState(() => _isLoading = loading),
      );

      if (!hasConnection) return;

      final buildingAirQuality = await _buildingController.getBuildingAirQuality(buildingId);

      if (!mounted) return;

      setState(() {
        _buildingAirQuality = buildingAirQuality;
        _buildingHasData = isBuildingDataAvailable();
        _buildingHasRooms = _buildingAirQuality.roomsAirQuality.isNotEmpty;
        _error = null;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = 'no_connection';
        _isLoading = false;
      });
    }
  }

  bool isBuildingDataAvailable() {
    return _buildingAirQuality.enviroScore != null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.whiteColor, // All white underneath
      appBar: AppBar(
        title: Text(
          l10n.statisticsTitle,
          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.whiteColor, fontSize: 22),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final l10n = AppLocalizations.of(context)!;
    double screenHeight = MediaQuery.of(context).size.height;
    double topBackgroundHeight = screenHeight * 0.10;

    return LoadingErrorWidget(
        isLoading: _isLoading,
        error: _error,
        onRetry: _loadData,
        child: RefreshIndicator(
          onRefresh: _loadData,
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    height: topBackgroundHeight,
                    color: AppColors.primaryColor,
                  ),
                  Expanded(
                    child: Container(
                      color: AppColors.whiteColor,
                      child: Column(
                        children: [
                          SizedBox(height: topBackgroundHeight + 30),
                          // ROOMS Card
                          Container(
                            height: MediaQuery.of(context).size.height -
                                topBackgroundHeight // Top blue section
                                -
                                kToolbarHeight // AppBar
                                -
                                100 // EnviroScore card
                                -
                                100 // Bottom navigation
                                -
                                50, // Additional padding/margins
                            margin: const EdgeInsets.symmetric(horizontal: 16.0),
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.blackColor.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                    color: AppColors.secondaryColor,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                                  child: Text(
                                    _buildingHasRooms ? l10n.rooms : l10n.noRoomsInBuilding,
                                    style: TextStyle(
                                      color: AppColors.whiteColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                // Rooms List
                                Expanded(
                                  child: ListView.separated(
                                    itemCount: _buildingAirQuality.roomsAirQuality.length,
                                    separatorBuilder: (context, index) => const Divider(height: 0),
                                    itemBuilder: (context, index) {
                                      final room = _buildingAirQuality.roomsAirQuality[index];
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                            context,
                                            '/roomOverview',
                                            arguments: {
                                              'roomId': room?.id,
                                              'roomName': room?.name,
                                            },
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                          child: Row(
                                            children: [
                                              // EnviroScore Percentage
                                              Container(
                                                width: 65,
                                                height: 60,
                                                decoration: BoxDecoration(
                                                  color: DataStatusHelper.getStatusColor(DataStatusHelper.getEnviroSenseStatus(room?.enviroScore)),
                                                  borderRadius: const BorderRadius.only(
                                                    topLeft: Radius.circular(15),
                                                    bottomLeft: Radius.circular(15),
                                                  ),
                                                ),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  room?.enviroScore != null ? '${room?.enviroScore?.toDouble()}%' : l10n.notAvailable,
                                                  style: const TextStyle(
                                                    color: AppColors.whiteColor,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              // Room Title
                                              Expanded(
                                                  child: Container(
                                                      height: 60,
                                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                                      decoration: BoxDecoration(
                                                        color: AppColors.primaryColor.withAlpha(10),
                                                        borderRadius: const BorderRadius.only(
                                                          topRight: Radius.circular(15),
                                                          bottomRight: Radius.circular(15),
                                                        ),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text(
                                                            room?.name ?? '',
                                                            style: const TextStyle(
                                                              color: AppColors.primaryColor,
                                                              fontSize: 18,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                          const Icon(
                                                            Icons.arrow_forward_ios,
                                                            color: AppColors.primaryColor,
                                                            size: 16,
                                                          ),
                                                        ],
                                                      ))),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              // Positioned EnviroScore card
              Positioned(
                top: topBackgroundHeight - 70,
                left: MediaQuery.of(context).size.width * 0.04,
                right: MediaQuery.of(context).size.width * 0.04,
                child: EnviroScoreCard(
                  score: _buildingAirQuality.enviroScore ?? 0.0,
                  isDataAvailable: _buildingHasData,
                ),
              ),
            ],
          ),
        ));
  }
}
