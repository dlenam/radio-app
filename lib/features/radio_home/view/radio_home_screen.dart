import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:radio_app/common_ui/custom_icon.dart';
import 'package:radio_app/features/radio_favorites/cubit/radio_favorites_cubit.dart';
import 'package:radio_app/features/radio_favorites/radio_favorites_tab.dart';
import 'package:radio_app/features/radio_home/cubit/radio_home_cubit.dart';
import 'package:radio_app/features/radio_home/view/widgets/all_radios_tab.dart';
import 'package:radio_app/theme.dart';

class RadioHomeScreen extends StatelessWidget {
  const RadioHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // This is our home page, we don't want anyone to pop it
      canPop: false,
      child: MaterialApp(
        theme: ThemeData(useMaterial3: true),
        home: MultiBlocProvider(
          providers: [
            BlocProvider<RadioHomeCubit>(
              create: (BuildContext _) =>
                  GetIt.instance.get<RadioHomeCubit>()..loadMoreRadioStations(),
            ),
            BlocProvider<RadioFavoritesCubit>(
              create: (BuildContext _) =>
                  GetIt.instance.get<RadioFavoritesCubit>(),
            ),
          ],
          child: const RadioHomeContent(),
        ),
      ),
    );
  }
}

class RadioHomeContent extends StatefulWidget {
  const RadioHomeContent({super.key});

  @override
  State<RadioHomeContent> createState() => _RadioHomeContentState();
}

class _RadioHomeContentState extends State<RadioHomeContent> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: appTheme.standardBackgroundColor,
          title: Text(
            'Radios',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: appTheme.primaryColor,
            ),
          ),
          // The elevation value of the app bar when scroll view has
          // scrolled underneath the app bar.
          scrolledUnderElevation: 4.0,
          shadowColor: appTheme.primaryColor,
          bottom: TabBar(
            indicatorColor: appTheme.primaryColor,
            labelColor: appTheme.primaryColor,
            tabs: const [
              Tab(
                text: 'All',
                icon: CustomIcon(icon: Icons.radio),
              ),
              Tab(
                text: 'Favorites',
                icon: CustomIcon(icon: Icons.favorite),
              ),
            ],
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                appTheme.secondaryColor,
                appTheme.primaryColor,
                appTheme.secondaryColor,
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
          child: const TabBarView(
            children: [
              AllRadiosTab(),
              RadioFavoritesTab(),
            ],
          ),
        ),
      ),
    );
  }
}
