import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:radio_app/common_ui/custom_icon.dart';
import 'package:radio_app/common_ui/custom_network_image.dart';
import 'package:radio_app/features/radio_list/cubit/radio_list_cubit.dart';
import 'package:radio_app/features/radio_player/view/radio_player_screen.dart';
import 'package:radio_app/routes/custom_page_routes.dart';

class AllRadiosTab extends StatefulWidget {
  const AllRadiosTab({super.key});

  @override
  State<AllRadiosTab> createState() => _AllRadiosTabState();
}

class _AllRadiosTabState extends State<AllRadiosTab> {
  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    controller = controller..addListener(_loadMoreRadioStationsListener);
  }

  @override
  void dispose() {
    controller.removeListener(_loadMoreRadioStationsListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RadioStationListCubit, RadioListState>(
      builder: (context, state) {
        switch (state.status) {
          case RadioListStatus.initial:
          case RadioListStatus.loading:
            EasyLoading.show(
                status: 'loading...', maskType: EasyLoadingMaskType.black);
            break;
          case RadioListStatus.loaded:
            EasyLoading.dismiss();
            break;
          case RadioListStatus.error:
            // TODO: display some snackbar
            break;
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: ListView.builder(
            controller: controller,
            shrinkWrap: true,
            itemCount: state.radioList.length,
            itemBuilder: (context, index) {
              final radioStation = state.radioList[index];
              return Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  onTap: () => Navigator.of(context).push(
                      bottomToTopTransitionPage(
                          RadioPlayerScreen(station: radioStation))),
                  leading: CustomNetworkImage(
                      imageUrl: radioStation.iconUrl, radius: 10),
                  title: Text(
                    radioStation.name ?? 'Unknown station',
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing:
                      const CustomIcon(icon: Icons.favorite_border_outlined),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _loadMoreRadioStationsListener() {
    if (controller.position.extentAfter < 500) {
      context.read<RadioStationListCubit>().loadMoreRadioStations();
    }
  }
}
