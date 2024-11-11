import 'package:flutter/material.dart';
import 'package:envirosense/colors/colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  String _selectedPeriod = 'Day';
  List<FlSpot> scoreData = [];
  List<String> labels = [];

  @override
  void initState() {
    super.initState();
    _updateChartData();
  }

  void _updateChartData() {
  DateTime now = DateTime.now();
  setState(() {
    if (_selectedPeriod == 'Day') {
      // Generate data for 24 hours
      scoreData = List.generate(24, (i) {
        if (i <= now.hour) {
          // Mock hourly data
          return FlSpot(i.toDouble(), 20 + Random().nextInt(30).toDouble());
        } else {
          // Skip future data points
          return null; // Return null for future data
        }
      }).whereType<FlSpot>().toList(); // Exclude null values
      labels = List.generate(24, (i) => "${i % 12 == 0 ? 12 : i % 12}${i < 12 ? 'AM' : 'PM'}");
    } else if (_selectedPeriod == 'Week') {
      // Generate data for 7 days
      const weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      scoreData = List.generate(7, (i) {
        if (i < now.weekday) {
          // Mock daily data
          return FlSpot(i.toDouble(), 40 + Random().nextInt(20).toDouble());
        } else {
          // Skip future data points
          return null;
        }
      }).whereType<FlSpot>().toList();
      labels = weekDays;
    } else if (_selectedPeriod == 'Month') {
      // Generate data for all days in current month
      int totalDaysInMonth = DateTime(now.year, now.month + 1, 0).day;
      scoreData = List.generate(totalDaysInMonth, (i) {
        if (i < now.day) {
          // Mock daily data
          return FlSpot(i.toDouble(), 50 + Random().nextInt(50).toDouble());
        } else {
          // Skip future data points
          return null;
        }
      }).whereType<FlSpot>().toList();
      labels = List.generate(totalDaysInMonth, (i) => (i + 1).toString());
    }
    // Update labels to match scoreData length
    labels = labels.sublist(0, scoreData.length);
  });
  if (scoreData.length == 1) {
  FlSpot singlePoint = scoreData[0];
  scoreData.add(FlSpot(singlePoint.x + 1, singlePoint.y));
  labels.add(labels[0]);
}
}

  Widget _buildTimeButton(String period) {
    final isSelected = _selectedPeriod == period;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPeriod = period;
          _updateChartData();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [BoxShadow(color: AppColors.secondaryColor.withOpacity(0.3), blurRadius: 8, spreadRadius: 1)]
              : null,
        ),
        child: Text(
          period,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 46, 16, 16),
            width: double.infinity,
            child: const Text(
              'Statistics',
              textAlign: TextAlign.start,
              style: TextStyle(
                color: AppColors.whiteColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildTimeButton('Day'),
                const SizedBox(width: 8),
                _buildTimeButton('Week'),
                const SizedBox(width: 8),
                _buildTimeButton('Month'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Stack(
              children: [
                Positioned(
                  top: 400,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
                Container(
                  height: 400,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryColor,
                  ),
                  child: EnviroScoreChart(scoreData: scoreData, labels: labels, selectedPeriod: _selectedPeriod),
                ),
                Positioned(
                  top: 343,
                  left: 16,
                  right: 16,
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      padding: const EdgeInsets.only(top: 8),
                      height: 270,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(width: 20),
                              const Text(
                                'EnviroScore',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(width: 2),
                              IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                  minWidth: 24,
                                  minHeight: 24,
                                ),
                                icon: const Icon(
                                  Icons.info_outline,
                                  size: 30,
                                  color: AppColors.blackColor,
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        title: const Text(
                                          'About EnviroScore',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        content: const Text(
                                          'EnviroScore is a measure of environmental quality based on various factors including air quality, temperature, and humidity levels in your space.',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: const Text(
                                              'Got it',
                                              style: TextStyle(color: AppColors.primaryColor),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                          Divider(
                            color: Colors.grey[300],
                            thickness: 1,
                            height: 0,
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                '85',
                                style: TextStyle(
                                  fontSize: 100,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                '%',
                                style: TextStyle(
                                  fontSize: 42,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.blueColor,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
                                ),
                              ),
                              child: const Text(
                                'View Detail',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EnviroScoreChart extends StatelessWidget {
  final List<FlSpot> scoreData;
  final List<String> labels;
  final String _selectedPeriod = '';

  const EnviroScoreChart({
    super.key,
    required this.scoreData,
    required this.labels,
    required String selectedPeriod,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 50),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 20,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.grey.withOpacity(0.3),
              strokeWidth: 1,
              dashArray: [5, 5],
            ),
          ),
          titlesData: FlTitlesData(
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: _selectedPeriod == 'Day' ? 4 : (_selectedPeriod == 'Week' ? 1 : 5),
                reservedSize: 30,
                getTitlesWidget: (value, _) {
                  int index = value.toInt();
                  if (index >= 0 && index < labels.length) {
                    if (_selectedPeriod == 'Month' && index % 5 != 0) {
                      return const SizedBox.shrink();
                    }
                    return Text(
                      labels[index],
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 20,
                reservedSize: 40,
                getTitlesWidget: (value, _) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: scoreData.length > 0 ? scoreData.length - 1 : 0,
          minY: 0,
          maxY: 100,
          lineBarsData: [
            LineChartBarData(
              spots: scoreData,
              isCurved: true,
              gradient: LinearGradient(
                colors: [Colors.red.withOpacity(0.8), Colors.red.withOpacity(0.2)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              barWidth: 4,
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [Colors.red.withOpacity(0.4), Colors.red.withOpacity(0.05)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              dotData: FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}
