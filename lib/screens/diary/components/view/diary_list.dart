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
  final List<DiaryEntry> _entries = [];
  bool _isLoading = false;
  bool _hasMore = true;
  final int _pageSize = 10;
  final ScrollController _scrollController = ScrollController();
  final BackgroundImageService _backgroundImageService = BackgroundImageService();

  @override
  void initState() {
    super.initState();
    _loadMore();
    _backgroundImageService.loadBackgroundImage();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent * 0.9 && !_isLoading) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_isLoading || !_hasMore) return;
    setState(() {
      _isLoading = true;
    });

    try {
      // await Future.delayed(Duration(seconds: 2));

      final newEntries = await DiaryDatabaseHelper.instance.getEntries(_entries.length, _pageSize);
      setState(() {
        _entries.addAll(newEntries);
        _isLoading = false;
        _hasMore = newEntries.length == _pageSize;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Manejo de errores
    }
  }

  void _reloadEntries() {
    setState(() {
      _entries.clear();
      _hasMore = true;
    });
    _loadMore();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        _buildSliverAppBar(theme),
        _buildYearHeader(theme),
        _buildEntriesList(theme),
        if (_isLoading)
          const SliverToBoxAdapter(
            child: Center(child: Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            )),
          ),
      ],
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

  Widget _buildEntriesList(ThemeData theme) {
    final textColor = theme.brightness == Brightness.dark ? Colors.grey[300] : Colors.grey[600];
    if (_entries.isEmpty && !_isLoading) {
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
                  style: TextStyle(color: textColor, fontWeight: FontWeight.w700, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 15),
            child: DiaryCard(
              entry: _entries[index],
              onDelete: _reloadEntries,
              onUpdate: _reloadEntries,
            ),
          ),
          childCount: _entries.length,
        ),
      );
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }
}