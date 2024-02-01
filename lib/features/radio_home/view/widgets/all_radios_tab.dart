import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:radio_app/features/radio_home/cubit/radio_home_cubit.dart';
import 'package:radio_app/features/radio_home/view/widgets/radio_list_widget.dart';

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
    return BlocBuilder<RadioHomeCubit, RadioHomeState>(
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
        return RadioListWidget(
          radioList: state.radioList,
          controller: controller,
        );
      },
    );
  }

  void _loadMoreRadioStationsListener() {
    if (controller.position.extentAfter < 500) {
      context.read<RadioHomeCubit>().loadMoreRadioStations();
    }
  }
}
