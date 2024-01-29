import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_it/get_it.dart';
import 'package:radio_app/features/radio_list/cubit/radio_list_cubit.dart';

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
      appBar: AppBar(title: const Text('Radios')),
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
              // TODO: Handle this case.
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
                    leading: CircleAvatar(
                      child: Image.network(
                        radioStation.iconUrl,
                        errorBuilder: (context, child, loadingProgress) =>
                            const Icon(
                          Icons.error_outline,
                          color: Colors.purple,
                        ),
                      ),
                    ),
                    title: Text(
                      radioStation.name,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: const Icon(
                      Icons.star_border_rounded,
                      size: 40,
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