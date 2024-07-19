import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:benimkoin/components/selectionbox/selectionbox.dart';
import 'package:benimkoin/constants/colors.dart';
import 'package:benimkoin/provider/portfolio_provider.dart';
import 'package:provider/provider.dart';

class PortfolioChart extends StatelessWidget {
  final SelectionBoxDataTime selectedTime;

  PortfolioChart({Key? key, required this.selectedTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PortfolioProvider>(
      builder: (context, portfolioProvider, child) {
        final bitcoinPrices = portfolioProvider.bitcoinPriceHistory;

        if (bitcoinPrices.isEmpty) {
          return const Center(child: Text('No data available'));
        }

        final spots = bitcoinPrices.entries
            .map((entry) => FlSpot(
                  entry.key.millisecondsSinceEpoch.toDouble(),
                  entry.value,
                ))
            .toList();
        Color graphColor =
            spots.first.y > spots.last.y ? Colors.red : Colors.green;
        List<Color> gradientColors = [
          graphColor,
          HexColor(white),
        ];

        return LineChart(
          LineChartData(
            backgroundColor: HexColor(white),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                color: graphColor,
                barWidth: 3,
                isStrokeCapRound: true,
                belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                        colors: gradientColors,
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter)),
                dotData: const FlDotData(show: false),
              ),
            ],
            titlesData: FlTitlesData(
              show: false,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 22,
                  getTitlesWidget: (value, meta) {
                    DateTime date =
                        DateTime.fromMillisecondsSinceEpoch(value.toInt());
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: Text('${date.month}/${date.day}'),
                    );
                  },
                ),
              ),
              leftTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: true),
              ),
            ),
            borderData: FlBorderData(show: false),
            gridData: const FlGridData(show: false),
          ),
        );
      },
    );
  }
}
