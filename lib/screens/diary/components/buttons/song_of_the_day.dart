import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:luna/providers/icon_color_provider.dart';

class SongOfTheDay extends StatefulWidget {
  const SongOfTheDay({Key? key}) : super(key: key);

  @override
  _SongOfTheDayState createState() => _SongOfTheDayState();
}

class _SongOfTheDayState extends State<SongOfTheDay> {
  String _songName = "Canción del día";
  String _songUrl = "";

  void _showSongDialog() {
    String tempSongName = "";
    String tempSongUrl = "";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        final theme = Theme.of(context);

        return AlertDialog(
          title: const Center(
            child: Text(
              "Agregar tu canción del día",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.music_note, size: 18),
                  hintText: "Nombre de la canción",
                  hintStyle: const  TextStyle(fontSize: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  contentPadding: 
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                ),
                onChanged: (value) => tempSongName = value,
              ),
              const SizedBox(height: 15),
              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.link_outlined, size: 18),
                  hintText: "Enlace de la canción",
                  hintStyle: const TextStyle(fontSize: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                ),
                onChanged: (value) => tempSongUrl = value,
              ),
            ],
          ),
          // contentPadding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 25), 
          actions: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    child: Text(
                      "Cancelar",
                      style: TextStyle(
                        color: theme.brightness == Brightness.dark ? Colors.white:Colors.black
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        side: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                    ),
                  ),
                ),
                const SizedBox(width: 8), 
                Expanded(
                  child: TextButton(
                    child: Text(
                      "Guardar",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      if (tempSongName.isNotEmpty && tempSongUrl.isNotEmpty) {
                        setState(() {
                          _songName = tempSongName;
                          _songUrl = tempSongUrl;
                        });
                        Navigator.of(context).pop();
                      }
                    },
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      padding:const EdgeInsets.symmetric(vertical: 10.0),
                      backgroundColor: Colors.blueGrey,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _launchURL() async {
    await launchUrl(Uri.parse(_songUrl));
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = Provider.of<IconColorProvider>(context).iconColor;

    return GestureDetector(
      onTap: _songUrl.isNotEmpty ? _launchURL : _showSongDialog,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Row(
          children: [
            Icon(Icons.play_circle,
                size: 23, color: _songUrl.isNotEmpty ? iconColor : Colors.grey[400]),
            const SizedBox(width: 8),
            Text(
              _songName,
              style: TextStyle(
                fontSize: 16,
                fontWeight: _songUrl.isNotEmpty ? FontWeight.bold : null,
                color: _songUrl.isNotEmpty ? iconColor : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
