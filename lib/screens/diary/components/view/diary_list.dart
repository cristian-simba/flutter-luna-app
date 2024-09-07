import 'package:flutter/material.dart';
import 'package:luna/constants/colors.dart';
import 'package:luna/services/database.dart';
import 'package:luna/models/diary_entry.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:luna/screens/diary/components/view/diary_card.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
class DiaryList extends StatefulWidget {
  const DiaryList({Key? key}) : super(key: key);
  @override
  DiaryListState createState() => DiaryListState();
}
class DiaryListState extends State<DiaryList> {
  Future<List<DiaryEntry>>? _entriesFuture;
  String? _backgroundImagePath;
  final List<String> _presetImages = [
    'assets/images/preset_background_1.jpg',
    'assets/images/preset_background_2.jpg',
  ];
  @override
  void initState() {
    super.initState();
    loadEntries();
    _loadBackgroundImage();
  }
  void loadEntries() {
    setState(() {
      _entriesFuture = DiaryDatabaseHelper.instance.getAllEntries();
    });
  }
  Future<void> _loadBackgroundImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _backgroundImagePath = prefs.getString('background_image_path') ?? _presetImages[0];
    });
  }
  Future<void> _pickBackgroundImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      await _saveBackgroundImage(pickedFile.path);
    }
  }
  Future<void> _saveBackgroundImage(String path) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('background_image_path', path);
    setState(() {
      _backgroundImagePath = path;
    });
  }
  void _showBackgroundOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Elige una portada',
                ),
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        _pickBackgroundImage();
                      },
                      child: const Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)), 
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.photo_library, size: 40, color: Color(0xFFBDBDBD),),
                            SizedBox(height: 8),
                            Text('Galería', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 14),),
                          ],
                        ),
                      ),
                    ),
                    // Opciones preestablecidas
                    ..._presetImages.asMap().entries.map((entry) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          _saveBackgroundImage(entry.value);
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          clipBehavior: Clip.hardEdge, 
                          child: Column(
                            children: [
                              Expanded(
                                child: Image.asset(
                                  entry.value,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                        )
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
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
              SliverAppBar(
                scrolledUnderElevation: 0,
                expandedHeight: 200.0,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      _backgroundImagePath != null
                          ? (_backgroundImagePath!.startsWith('assets')
                              ? Image.asset(_backgroundImagePath!, fit: BoxFit.cover)
                              : Image.file(File(_backgroundImagePath!), fit: BoxFit.cover))
                          : Image.asset(_presetImages[0], fit: BoxFit.cover),
                      Positioned(
                        right: 16,
                        bottom: 16,
                        child: _buildEditButton(),

                      ),
                    ],
                  ),
                ),
                pinned: true,
                floating: false,
                backgroundColor: theme.brightness == Brightness.dark ? 
                PinnedColors.darkPinned : PinnedColors.lightPinned,
              ),
              SliverToBoxAdapter(
                child: Container(
                  color: theme.brightness == Brightness.dark
                      ? ScreenBackground.darkBackground
                      : ScreenBackground.lightBackground,
                  padding: const EdgeInsets.only(left: 20, top: 15, bottom: 5),
                  child: const Text(
                    "2024",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              if (!snapshot.hasData || snapshot.data!.isEmpty)
                SliverToBoxAdapter(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text('Empieza a escribir tu historia')],
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => Container(
                      color: theme.brightness == Brightness.dark
                          ? ScreenBackground.darkBackground
                          : ScreenBackground.lightBackground,
                      child: DiaryCard(
                        entry: snapshot.data![index],
                        onDelete: loadEntries,
                        onUpdate: loadEntries,
                      ),
                    ),
                    childCount: snapshot.data!.length,
                  ),
                ),
            ],
          );
        }
      },
    );
  }
  Widget _buildEditButton() {
    return Hero(
      tag: 'editBackgroundFAB',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _showBackgroundOptions,
          customBorder: CircleBorder(),
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.edit,
                color: Colors.grey,
                size: 15.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}