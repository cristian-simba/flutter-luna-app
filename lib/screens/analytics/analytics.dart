import 'package:flutter/material.dart';
import 'package:luna/screens/analytics/components/weekly_mood.dart';
import 'package:luna/screens/analytics/components/montly_mood.dart';
import 'package:luna/services/database.dart';
import 'package:luna/constants/colors.dart';
import 'package:provider/provider.dart';
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
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: theme.brightness == Brightness.dark 
              ? ScreenBackground.darkBackground 
              : ScreenBackground.lightBackground,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Text("Análisis", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),),
                  ),
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
                  SizedBox(height: 5), // Espacio entre las gráficas
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
        ),
      ),
    );
  }
}

