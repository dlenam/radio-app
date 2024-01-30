import 'package:flutter/material.dart';
import 'package:radio_app/common_ui/widgets.dart';
import 'package:radio_app/features/radio_player/view/widgets/audio_player_widget.dart';
import 'package:radio_app/model/radio_station.dart';

class RadioPlayerScreen extends StatefulWidget {
  final RadioStation station;

  const RadioPlayerScreen({super.key, required this.station});

  @override
  State<RadioPlayerScreen> createState() => _RadioPlayerScreenState();
}

class _RadioPlayerScreenState extends State<RadioPlayerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            widget.station.name ?? 'Unknown station',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 40),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.star_border_rounded, size: 40),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(_buildSnackBar());
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: [
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: RoundedCornerImage(imageUrl: widget.station.iconUrl),
            ),
            Expanded(child: AudioPlayer(streamUrl: widget.station.streamUrl)),
          ],
        ),
      ),
    );
  }
}

SnackBar _buildSnackBar() => SnackBar(
      backgroundColor: Colors.deepPurple,
      content: const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Center(child: Text('Added to favourites!')),
      ),
      duration: const Duration(milliseconds: 1500),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
