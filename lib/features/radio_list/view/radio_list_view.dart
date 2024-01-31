import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_it/get_it.dart';
import 'package:radio_app/common_ui/widgets.dart';
import 'package:radio_app/features/radio_list/cubit/radio_list_cubit.dart';
import 'package:radio_app/features/radio_player/view/radio_player_screen.dart';
import 'package:radio_app/routes/custom_page_routes.dart';

class RadioListScreen extends StatelessWidget {
  const RadioListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: BlocProvider<RadioStationListCubit>(
        create: (_) => GetIt.instance.get<RadioStationListCubit>()
          ..loadMoreRadioStations(),
        child: const RadioListView(),
      ),
    );
  }
}

class RadioListView extends StatefulWidget {
  const RadioListView({super.key});

  @override
  State<RadioListView> createState() => _RadioListViewState();
}

class _RadioListViewState extends State<RadioListView> {
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
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'Radios',
        style: TextStyle(fontWeight: FontWeight.bold),
      )),
      body: BlocBuilder<RadioStationListCubit, RadioListState>(
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
                    leading: CustomeNetworkImage(
                        imageUrl: radioStation.iconUrl, radius: 10),
                    title: Text(
                      radioStation.name ?? 'Unknown station',
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: const Icon(
                      Icons.star_border_rounded,
                      size: 40,
                      color: Colors.black,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _loadMoreRadioStationsListener() {
    if (controller.position.extentAfter < 500) {
      context.read<RadioStationListCubit>().loadMoreRadioStations();
    }
  }
}
