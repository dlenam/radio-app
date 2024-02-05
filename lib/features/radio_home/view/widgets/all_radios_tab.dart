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
    return BlocConsumer<RadioHomeCubit, RadioHomeState>(
      listener: (BuildContext context, RadioHomeState state) {
        _errorSnackBarHandler(state);
      },
      builder: (context, state) {
        // This should happen within the listener. But there's a weird issue with the first loading state.
        _loaderOverlayHandler(state);
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

  void _loaderOverlayHandler(RadioHomeState state) {
    if (state.shouldDisplayLoading) {
      EasyLoading.show(
        status: 'loading...',
        maskType: EasyLoadingMaskType.black,
      );
      return;
    }
    EasyLoading.dismiss();
  }

  void _errorSnackBarHandler(RadioHomeState state) {
    if (state.shouldDisplayErrorSnackBar) {
      final scaffold = ScaffoldMessenger.of(context);
      scaffold.clearSnackBars();
      scaffold.showSnackBar(_buildErrorSnackBar());
    }
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

SnackBar _buildErrorSnackBar() => SnackBar(
      content: const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Center(
          child: Text(
            'Error retrieving more radios',
          ),
        ),
      ),
      duration: const Duration(milliseconds: 1500),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
