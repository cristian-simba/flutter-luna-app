import 'package:flutter/material.dart';
import 'package:luna/widgets/theme_switcher.dart';
import 'package:provider/provider.dart';
import 'package:luna/providers/icon_color_provider.dart';
import 'package:luna/widgets/icon_color_selector.dart';
import 'package:luna/widgets/notification_toggle.dart';
import 'package:luna/services/database.dart';
import 'package:luna/constants/colors.dart';
import 'package:luna/screens/profile/components/count_cards.dart';  
import 'package:luna/screens/profile/components/about.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:luna/utils/show_top_messages.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int _diaryCount = 0;
  int _photoCount = 0;

  @override
  void initState() {
    super.initState();
    _loadCounts();
  }

  Future<void> _loadCounts() async {
    final diaryEntries = await DiaryDatabaseHelper.instance.getAllEntries();
    int totalPhotos = 0;
    for (var entry in diaryEntries) {
      if (entry.imagePaths != null) {
        totalPhotos += entry.imagePaths!.length;
      }
    }
    setState(() {
      _diaryCount = diaryEntries.length;
      _photoCount = totalPhotos;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = theme.brightness == Brightness.dark 
              ? ScreenBackground.darkBackground 
              : ScreenBackground.lightBackground;
    final cardColor = theme.brightness == Brightness.dark ? CardColors.darkCard : CardColors.lightCard;
    final separatorColor = theme.brightness == Brightness.dark ? SeparatorColors.darkSeparator : SeparatorColors.lightSeparator;

    return Scaffold(
      body: SafeArea(
        child: Container(
          color: backgroundColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ListView(
              children: [
                topTitle(),
                cardTitle(),
                CountCards(diaryCount: _diaryCount, photoCount: _photoCount),
                const SizedBox(height: 4),
                Card(
                  color: cardColor,
                  elevation: 0.25,
                  child: Padding(
                    padding: EdgeInsets.only(left: 13, top: 5, bottom: 5, right: 20),
                    child: colorSelector(),  
                  )
                ),
                const SizedBox(height: 4),
                Card(
                  color: cardColor,
                  elevation: 0.25,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Column(
                      children: [
                        NotificationToggle(),
                        Divider(height: 1, color: separatorColor,),
                        ThemeSwitcher(),
                        Divider(height: 1, color: separatorColor,),
                        _buildSuportBtn(context), 
                        Divider(height: 1, color: separatorColor,),
                        _buildAboutBtn(context),                      
                      ],
                    )
                  )
                ),
                const SizedBox(height: 20),                
              ],
            ),
          ),
        )
      ),
    );
  }

  TextButton _buildSuportBtn(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.brightness == Brightness.dark ? Colors.white : Colors.black;
    return TextButton(
      onPressed: () async {
        final Uri emailUri = Uri(
          scheme: 'mailto',
          path: 'davidsimba200@gmail.com',
          queryParameters: {
            'subject': 'Soporte/Comentarios',
          },
        );
        try {
          await launchUrl(emailUri);
        } catch (e) {
          showTopMessage(context, 'No se puede abrir el correo');
        }
      },
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero, 
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 3, right: 10), 
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Envia tus comentarios',
              style: TextStyle(color: textColor, fontWeight: FontWeight.normal),
            ),
            Icon(Icons.arrow_forward_ios, color: textColor, size: 12,),
          ],
        ),
      ),    
    );
  }

  TextButton _buildAboutBtn(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.brightness == Brightness.dark ? Colors.white : Colors.black;

    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => About()),
        );
      },
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero, 
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 3, right: 10), 
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Acerca de la aplicación',
              style: TextStyle(color: textColor, fontWeight: FontWeight.normal),
            ),
            Icon(Icons.arrow_forward_ios, color: textColor, size: 12,),
          ],
        ),
      ),
    );
  }


  Padding topTitle() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Center(
        child: Text(
        "Mis datos",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      )
    );
  }
  
  Padding cardTitle() {
    return const Padding(
      padding: EdgeInsets.only(bottom: 10, left: 6), 
      child: Text("Mis registros", style: TextStyle(fontSize: 14 ,fontWeight: FontWeight.w700),
      ),
    );
  }

  Consumer<IconColorProvider> colorSelector() {
    return Consumer<IconColorProvider>(
      builder: (context, iconColorProvider, child) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 2), 
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Colores de la aplicación'),
              GestureDetector(
                onTap: () {
                  showColorSelectorDialog(context, iconColorProvider);
                },
                child: Icon(Icons.circle, color: iconColorProvider.iconColor, size: 25),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> showColorSelectorDialog(BuildContext context, IconColorProvider iconColorProvider) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).dialogBackgroundColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
          title: const Text(
            'Selecciona un nuevo color',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          contentPadding: EdgeInsets.zero,
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10, bottom: 0),
                  child: IconColorSelector(
                    onColorSelected: (Color color) {
                      iconColorProvider.updateIconColor(color);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 10, right: 20),
                      child: TextButton(
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}