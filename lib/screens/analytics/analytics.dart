import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:luna/screens/analytics/components/weekly_mood.dart';
import 'package:luna/screens/analytics/components/montly_mood.dart';
import 'package:luna/screens/analytics/components/anual_mood.dart';
import 'package:luna/services/database.dart';
import 'package:luna/constants/colors.dart';
import 'package:luna/providers/icon_color_provider.dart';
class Analytics extends StatefulWidget {
  const Analytics({super.key});

  @override
  _AnalyticsState createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = Provider.of<IconColorProvider>(context).iconColor;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: Container(
            color: theme.brightness == Brightness.dark 
                ? ScreenBackground.darkBackground 
                : ScreenBackground.lightBackground,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Text(
                    "Análisis",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
                TabBar(
                  tabs: [
                    Tab(text: 'Mensual'),
                    Tab(text: 'Anual'),
                  ],
                  indicatorColor: iconColor,
                  labelStyle: TextStyle(color: iconColor,fontWeight: FontWeight.w700),
                  dividerHeight: 0,
                  unselectedLabelStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w700),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          child: Column(
                            children: [
                              FutureBuilder<Map<String, int>>(
                                future: DiaryDatabaseHelper.instance.getWeeklyMoodCounts(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Center(child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Center(child: Text('Error: ${snapshot.error}'));
                                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                    return Center(child: Text('No hay datos semanales disponibles'));
                                  } else {
                                    return WeeklyMood(moodCounts: snapshot.data!);
                                  }
                                },
                              ),
                              FutureBuilder<Map<String, int>>(
                                future: DiaryDatabaseHelper.instance.getMonthlyMoodCounts(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Center(child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Center(child: Text('Error: ${snapshot.error}'));
                                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                    return Center(child: Text('No hay datos mensuales disponibles'));
                                  } else {
                                    return MonthlyMoodPieChart(moodCounts: snapshot.data!);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Contenido para la pestaña Anual
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            FutureBuilder<Map<String, int>>(
                              future: DiaryDatabaseHelper.instance.getAnnualMoodCounts(), // Asegúrate de que este método esté implementado
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Center(child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(child: Text('Error: ${snapshot.error}'));
                                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                  return Center(child: Text('No hay datos anuales disponibles'));
                                } else {
                                  return AnnualMood(moodCounts: snapshot.data!);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
