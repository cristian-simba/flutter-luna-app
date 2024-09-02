import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:luna/providers/icon_color_provider.dart';

class SongOfTheDay extends StatefulWidget {
  final Function(String, String) onSongUpdated;
  final String initialSongName;
  final String initialSongUrl;

  const SongOfTheDay({
    Key? key,
    required this.onSongUpdated,
    this.initialSongName = "",
    this.initialSongUrl = "",
  }) : super(key: key);

  @override
  _SongOfTheDayState createState() => _SongOfTheDayState();
}

class _SongOfTheDayState extends State<SongOfTheDay> {
  late String _songName;
  late String _songUrl;

  @override
  void initState() {
    super.initState();
    _songName = widget.initialSongName;
    _songUrl = widget.initialSongUrl;
  }

  void _showSongDialog() {
    String tempSongName = _songName;
    String tempSongUrl = _songUrl;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        final iconColor = Provider.of<IconColorProvider>(context).iconColor;

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
                  hintStyle: const TextStyle(fontSize: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                ),
                controller: TextEditingController(text: tempSongName),
                onChanged: (value) => tempSongName = value,
              ),
              const SizedBox(height: 15),
              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.link_outlined, size: 18),
                  hintText: "Enlace de la canción",
                  hintStyle: const TextStyle(fontSize: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                ),
                controller: TextEditingController(text: tempSongUrl),
                onChanged: (value) => tempSongUrl = value,
              ),
            ],
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    child: Text(
                      "Cancelar",
                      style: TextStyle(
                        color: theme.brightness == Brightness.dark ? Colors.white : Colors.black
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(color: Colors.grey, width: 1),
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
                        widget.onSongUpdated(_songName, _songUrl);
                        Navigator.of(context).pop();
                      }
                    },
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      backgroundColor: Provider.of<IconColorProvider>(context).iconColor,
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
    if (await canLaunch(_songUrl)) {
      await launch(_songUrl);
    } else {
      throw 'Could not launch $_songUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
              _songName.isNotEmpty ? _songName : "Ingresa tu canción del día",
              style: TextStyle(
                fontSize: 16,
                fontWeight: _songUrl.isNotEmpty ? FontWeight.bold : null,
                color: _songUrl.isNotEmpty 
                    ? iconColor 
                    : theme.brightness == Brightness.dark 
                        ? Colors.grey[400] 
                        : Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
