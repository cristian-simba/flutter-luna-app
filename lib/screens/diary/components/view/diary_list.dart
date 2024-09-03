import 'package:flutter/material.dart';
import 'package:luna/constants/colors.dart';
import 'package:luna/services/database.dart';
import 'package:luna/models/diary_entry.dart';
import 'package:luna/screens/diary/components/view/diary_card.dart';

class DiaryList extends StatefulWidget {
  const DiaryList({Key? key}) : super(key: key);

  @override
  _DiaryListState createState() => _DiaryListState();
}

class _DiaryListState extends State<DiaryList> {
  Future<List<DiaryEntry>>? _entriesFuture;

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  void _loadEntries() {
    setState(() {
      _entriesFuture = DiaryDatabaseHelper.instance.getAllEntries();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FutureBuilder<List<DiaryEntry>>(
      future: _entriesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return 
           CustomScrollView(
            slivers: [
              SliverAppBar(
                // title: Text("Hola"),
                scrolledUnderElevation: 0,
                expandedHeight: 175.0,
                flexibleSpace: FlexibleSpaceBar(
                  background: theme.brightness == Brightness.dark ? Image.asset(
                    'assets/images/dark_background.jpg', 
                    fit: BoxFit.cover,
                  ) :  Image.asset(
                    'assets/images/diary_background.jpg', 
                    fit: BoxFit.cover,
                  ),
                ),
                pinned: true,
              ),
              SliverToBoxAdapter(
                child: Column(  
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text('Empieza a escribir tu historia')]
                  )
              )
            ]);
        } else {
          final entries = snapshot.data!;
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                // title: Text("Hola"),
                scrolledUnderElevation: 0,
                expandedHeight: 175.0,
                flexibleSpace: FlexibleSpaceBar(
                  background: theme.brightness == Brightness.dark ? Image.asset(
                    'assets/images/dark_background.jpg', 
                    fit: BoxFit.cover,
                  ) :  Image.asset(
                    'assets/images/diary_background.jpg', 
                    fit: BoxFit.cover,
                  ),
                ),
                pinned: true,
              ),
             SliverToBoxAdapter(
              child: Container(
                color: theme.brightness == Brightness.dark
                    ? ScreenBackground.darkBackground
                    : ScreenBackground.lightBackground,
                padding: const EdgeInsets.only(left: 20, top: 20, bottom: 10),
                child: const Text(
                  "2024",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Container(
                    color: theme.brightness == Brightness.dark
                        ? ScreenBackground.darkBackground
                        : ScreenBackground.lightBackground,
                    child: DiaryCard(
                      entry: entries[index],
                      onDelete: _loadEntries,
                      onUpdate: _loadEntries,
                    ),
                  ),
                  childCount: entries.length,
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
