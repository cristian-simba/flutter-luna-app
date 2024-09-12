import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:luna/screens/analytics/components/progress_card.dart';
import 'package:luna/screens/analytics/components/weekly_mood.dart';
import 'package:luna/screens/analytics/components/montly_mood.dart';
import 'package:luna/screens/analytics/components/annual_mood.dart';
import 'package:luna/screens/analytics/components/examples/weekly_mood_example.dart';
import 'package:luna/screens/analytics/components/examples/montly_mood_example.dart';
import 'package:luna/screens/analytics/components/examples/annual_mood_example.dart';
import 'package:luna/services/database.dart';
import 'package:luna/constants/colors.dart';
import 'package:luna/providers/icon_color_provider.dart';

class Analytics extends StatelessWidget {
  const Analytics({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = Provider.of<IconColorProvider>(context).iconColor;
    
    return FutureBuilder<int>(
      future: DiaryDatabaseHelper.instance.getDiaryCount(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final diaryCount = snapshot.data ?? 0;
        final showRealGraphs = diaryCount >= 5;

        return DefaultTabController(
          length: 2,
          child: SafeArea(
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
              _buildTabBarNav(iconColor),
              Expanded(
                child: TabBarView(
                  children: [
                    SingleChildScrollView(
                      child: _buildMensualView(showRealGraphs),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: SingleChildScrollView(
                        child: _buildAnnualView(showRealGraphs),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
          ))
        );
      },
    );
  }

  Column _buildAnnualView(bool showRealGraphs) {
    return Column(
      children: [
        if (showRealGraphs)
          _buildAnnualChart()
        else
          AnnualMoodExample(),
      ],
    );
  }

  Padding _buildMensualView(bool showRealGraphs) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        children: [
          ProgressCard(),
          if (showRealGraphs)
            _buildWeeklyChart()
          else
            WeeklyMoodExample(),
          if (showRealGraphs)
            _buildMontlyChart()
          else
            MonthlyMoodExample(),
        ],
      ),
    );
  }

  TabBar _buildTabBarNav(Color iconColor) {
    return TabBar(
      tabs: [
        Tab(text: 'Mensual'),
        Tab(text: 'Anual'),
      ],
        indicatorColor: iconColor,
        labelStyle: TextStyle(color: iconColor,fontWeight: FontWeight.w700),
        dividerHeight: 0,
        unselectedLabelStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w700),
    );
  }

  FutureBuilder<Map<String, int>> _buildWeeklyChart() {
    return FutureBuilder<Map<String, int>>(
      future: DiaryDatabaseHelper.instance.getWeeklyMoodCounts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return WeeklyMoodExample();
        } else {
          return WeeklyMood(moodCounts: snapshot.data!);
        }
      },
    );
  }

  FutureBuilder<Map<String, int>> _buildMontlyChart() {
    return FutureBuilder<Map<String, int>>(
      future: DiaryDatabaseHelper.instance.getMonthlyMoodCounts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return MonthlyMoodExample();
        } else {
          return MonthlyMood(moodCounts: snapshot.data!);
        }
      },
    );
  }

  FutureBuilder<Map<String, int>> _buildAnnualChart() {
    return FutureBuilder<Map<String, int>>(
      future: DiaryDatabaseHelper.instance.getAnnualMoodCounts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || _isDataEmpty(snapshot.data!)) {
          return AnnualMoodExample();
        } else {
          return AnnualMood(moodCounts: snapshot.data!);
        }
      },
    );
  }

  bool _isDataEmpty(Map<String, int> data) {
    return data.values.every((count) => count == 0);
  }
}