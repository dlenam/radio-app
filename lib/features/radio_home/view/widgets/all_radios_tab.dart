import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:radio_app/common_ui/radio_list_view.dart';
import 'package:radio_app/features/radio_home/cubit/radio_home_cubit.dart';

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
        // This should happen within a BlocListener
        // But there's a weird issue with the first loading state.
        _handleLoaderOverlay(state);
        if (state.shouldDisplayErrorScreen) {
          return const _ErrorScreen();
        }
        return RadioListView(
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

  void _handleLoaderOverlay(RadioHomeState state) {
    if (state.shouldDisplayLoading) {
      EasyLoading.show(
        status: 'loading...',
        maskType: EasyLoadingMaskType.black,
      );
      return;
    }
    EasyLoading.dismiss();
  }
}

class _ErrorScreen extends StatelessWidget {
  const _ErrorScreen();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/no-connectivity.svg',
          width: 200,
        ),
        GestureDetector(
          onTap: () => context.read<RadioHomeCubit>().loadMoreRadioStations(),
          child: const Column(
            children: [
              Icon(
                Icons.refresh_rounded,
                size: 60,
              ),
              Text(
                'Retry',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
