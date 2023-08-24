import 'package:bsuir_schedule/domain/view_model/group_screen_view_model.dart';
import 'package:bsuir_schedule/domain/view_model/lecturer_screen_view_model.dart';
import 'package:bsuir_schedule/domain/view_model/root_screen_view_model.dart';
import 'package:bsuir_schedule/domain/view_model/schedule_screen_view_model.dart';
import 'package:bsuir_schedule/ui/screens/group_screen.dart';
import 'package:bsuir_schedule/ui/screens/lecturer_screen.dart';
import 'package:bsuir_schedule/ui/screens/root_screen.dart';
import 'package:bsuir_schedule/ui/screens/schedule_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScreenFactory {
  Widget makeRootScreen() => ChangeNotifierProvider(
        create: (_) => RootScreenViewModel(),
        child: const RootScreen(),
      );
  Widget makeScheduleScreen() => ChangeNotifierProvider(
        create: (_) => ScheduleScreenViewModel(),
        child: const ScheduleScreen(),
      );
  Widget makeGroupScreen() => ChangeNotifierProvider(
        create: (_) => GroupScreenViewModel(),
        child: const GroupScreen(),
      );
  Widget makeLecturerScreen() => ChangeNotifierProvider(
        create: (_) => LecturerScreenViewModel(),
        child: const LecturerScreen(),
      );
}
