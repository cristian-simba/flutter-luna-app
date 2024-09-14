import 'package:flutter/material.dart';
import 'package:luna/models/diary_entry.dart';
import 'package:luna/screens/diary/components/view/diary_card.dart';
import 'package:luna/services/database.dart';
import 'package:luna/services/background_image_service.dart';
import 'package:luna/screens/diary/components/view/background_image_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DiaryList extends StatefulWidget {
  const DiaryList({Key? key}) : super(key: key);

  @override
  DiaryListState createState() => DiaryListState();
}

class DiaryListState extends State<DiaryList> {
  Future<List<DiaryEntry>>? _entriesFuture;
  final BackgroundImageService _backgroundImageService = BackgroundImageService();

  @override
  void initState() {
    super.initState();
    loadEntries();
    _backgroundImageService.loadBackgroundImage();
  }

  void loadEntries() {
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
          } else {
            return CustomScrollView(
              slivers: [
                _buildSliverAppBar(theme),
                _buildYearHeader(theme),
                _buildEntriesList(snapshot, theme),
              ],
            );
          }
        },
    );
  }

  Widget _buildSliverAppBar(ThemeData theme) {
    return SliverAppBar(
      scrolledUnderElevation: 0,
      expandedHeight: 175.0,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            _backgroundImageService.buildBackgroundImage(),
            Positioned(
              right: 16,
              bottom: 16,
              child: BackgroundImagePicker(
                backgroundImageService: _backgroundImageService,
              ),
            ),
          ],
        ),
      ),
      pinned: true,
      floating: false,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildYearHeader(ThemeData theme) {
    return const SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(left: 20, top: 15, bottom: 10),
        child: Text(
          "2024",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildEntriesList(AsyncSnapshot<List<DiaryEntry>> snapshot, ThemeData theme) {
    final textColor = theme.brightness == Brightness.dark ? Colors.grey[300] : Colors.grey[600];
    if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return SliverFillRemaining(
        child: Opacity(
          opacity: 0.6,
          child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/svgs/predetermined.svg',
                height: 60,
                width: 60,
              ),
              const SizedBox(height: 10),
              Text(
                'Empieza a escribir tu historia',
                style: TextStyle(color: textColor, fontWeight: FontWeight.w700, fontSize: 14 ),
              ),
            ],
          ),
        ),
        )
      );
    } else {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 15),
            child: DiaryCard(
              entry: snapshot.data![index],
              onDelete: loadEntries,
              onUpdate: loadEntries,
            ),
          ),
          childCount: snapshot.data!.length,
        ),
      );
    }
  }
}