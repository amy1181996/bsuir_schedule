import 'package:bsuir_schedule/application/settings/models/app_settings.dart';
import 'package:bsuir_schedule/application/settings/settings_provider.dart';
import 'package:bsuir_schedule/ui/navigation/navigation.dart';
import 'package:bsuir_schedule/ui/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SettingsProvider(),
      child: const _AppDataLoader(),
    );
  }
}

class _AppDataLoader extends StatefulWidget {
  const _AppDataLoader({Key? key}) : super(key: key);

  @override
  State<_AppDataLoader> createState() => _AppDataLoaderState();
}

class _AppDataLoaderState extends State<_AppDataLoader> {
  Future<bool>? _dataFetched;

  @override
  void initState() {
    _dataFetched =
        Provider.of<SettingsProvider>(context, listen: false).fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mainNavigation = MainNavigation();

    return FutureBuilder(
      future: _dataFetched,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final currentTheme =
              Provider.of<SettingsProvider>(context).appColorScheme;
          final useMaterial3 =
              Provider.of<SettingsProvider>(context).useMaterial3;

          return MaterialApp(
            title: 'BSUIR Schedule',
            theme: getThemeData(currentTheme, useMaterial3),
            routes: mainNavigation.routes,
            onGenerateRoute: mainNavigation.onGenerateRoute,
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  ThemeData getThemeData(AppColorScheme colorScheme, bool useMaterial3) =>
      colorScheme == AppColorScheme.dark
          ? useMaterial3
              ? AppTheme.darkMaterial
              : AppTheme.dark
          : useMaterial3
              ? AppTheme.lightMaterial
              : AppTheme.light;
}
