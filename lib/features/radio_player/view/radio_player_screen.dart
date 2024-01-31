import 'package:flutter/material.dart';
import 'package:radio_app/common_ui/custom_icon.dart';
import 'package:radio_app/common_ui/custom_network_image.dart';
import 'package:radio_app/features/radio_player/view/widgets/audio_player_widget.dart';
import 'package:radio_app/model/radio_station.dart';
import 'package:radio_app/theme.dart';

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
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: primaryColor,
            ),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: IconButton(
            icon: const CustomIcon(
              icon: Icons.keyboard_arrow_down_rounded,
              // customColor: Colors.black,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: const CustomIcon(
                icon: Icons.favorite_outline,
                // customColor: Colors.black,
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(_buildSnackBar());
              },
            ),
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
              child: CustomNetworkImage(imageUrl: widget.station.iconUrl),
            ),
            Expanded(child: AudioPlayer(streamUrl: widget.station.streamUrl)),
          ],
        ),
      ),
    );
  }
}

SnackBar _buildSnackBar() => SnackBar(
      backgroundColor: primaryColor,
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
