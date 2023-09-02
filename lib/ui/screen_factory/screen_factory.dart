import 'package:bsuir_schedule/domain/view_model/group_screen_view_model.dart';
import 'package:bsuir_schedule/domain/view_model/lecturer_screen_view_model.dart';
import 'package:bsuir_schedule/domain/view_model/root_screen_view_model.dart';
import 'package:bsuir_schedule/domain/view_model/schedule_screen_view_model.dart';
import 'package:bsuir_schedule/ui/screens/group_screen.dart';
import 'package:bsuir_schedule/ui/screens/lecturer_screen.dart';
import 'package:bsuir_schedule/ui/screens/root_screen.dart';
import 'package:bsuir_schedule/ui/screens/schedule_screen.dart';
import 'package:bsuir_schedule/ui/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScreenFactory {
  Widget makeRootScreen() => Builder(builder: (context) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: ChangeNotifierProvider(
            create: (_) => RootScreenViewModel(),
            child: const RootScreen(),
          ),
        );
      });

  Widget makeScheduleScreen() => Builder(builder: (context) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: ChangeNotifierProvider(
            create: (_) => ScheduleScreenViewModel(),
            child: const ScheduleScreen(),
          ),
        );
      });

  Widget makeGroupScreen() => Builder(builder: (context) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: ChangeNotifierProvider(
            create: (_) => GroupScreenViewModel(),
            child: const GroupScreen(),
          ),
        );
      });

  Widget makeLecturerScreen() => Builder(builder: (context) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: ChangeNotifierProvider(
            create: (_) => LecturerScreenViewModel(),
            child: const LecturerScreen(),
          ),
        );
      });

  Widget makeSettingsScreen() => Builder(builder: (context) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: const SettingsScreen(),
        );
      });
}
