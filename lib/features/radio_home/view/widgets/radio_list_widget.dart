import 'package:flutter/material.dart';
import 'package:radio_app/common_ui/custom_network_image.dart';
import 'package:radio_app/features/radio_player/view/radio_player_screen.dart';
import 'package:radio_app/features/widgets/favorite_interactive_icon.dart';
import 'package:radio_app/model/radio_station.dart';
import 'package:radio_app/routes/custom_page_routes.dart';

class RadioListWidget extends StatelessWidget {
  final RadioList radioList;
  final ScrollController? controller;

  const RadioListWidget({
    super.key,
    this.controller,
    required this.radioList,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ListView.builder(
        controller: controller,
        shrinkWrap: true,
        itemCount: radioList.length,
        itemBuilder: (context, index) {
          final radioStation = radioList[index];
          return Card(
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              onTap: () => Navigator.of(context).push(
                bottomToTopTransitionPage(
                  RadioPlayerScreen(radioStation: radioStation),
                ),
              ),
              leading: CustomNetworkImage(
                  imageUrl: radioStation.iconUrl, radius: 10),
              title: Text(
                radioStation.name ?? 'Unknown station',
                overflow: TextOverflow.ellipsis,
              ),
              trailing: FavoriteInteractiveIcon(radioStation: radioStation),
            ),
          );
        },
      ),
    );
  }
}
