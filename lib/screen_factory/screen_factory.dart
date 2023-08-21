import 'package:bsuir_schedule/domain/view_model/root_screen_view_model.dart';
import 'package:bsuir_schedule/domain/view_model/schedule_screen_view_model.dart';
import 'package:bsuir_schedule/view/root_screen.dart';
import 'package:bsuir_schedule/view/schedule_screen.dart';
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
}
