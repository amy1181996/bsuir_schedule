import 'package:bsuir_schedule/domain/view_model/schedule_screen_view_model.dart';
import 'package:bsuir_schedule/ui/navigation/navigation.dart';
import 'package:bsuir_schedule/ui/screens/view_constants.dart';
import 'package:bsuir_schedule/ui/themes/app_text_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScheduleScreenAppBar extends StatefulWidget {
  const ScheduleScreenAppBar({super.key});

  @override
  State<ScheduleScreenAppBar> createState() => _ScheduleScreenAppBarState();
}

class _ScheduleScreenAppBarState extends State<ScheduleScreenAppBar> {
  ScheduleViewType? _currentScheduleType;
  // ignore: unused_field
  ScheduleGroupType? _currentGroupType;

  @override
  Widget build(BuildContext context) {
    final currentWeek =
        Provider.of<ScheduleScreenViewModel>(context).currentWeek;
    _currentScheduleType =
        Provider.of<ScheduleScreenViewModel>(context).scheduleViewType;
    _currentGroupType =
        Provider.of<ScheduleScreenViewModel>(context).scheduleGroupType;
    final bool isSessonPeriod = context.select(
            (ScheduleScreenViewModel viewModel) =>
                viewModel.exams.isNotEmpty) ??
        false;

    return SliverAppBar(
      expandedHeight: 30,
      floating: true,
      pinned: false,
      title: getTitle(DateTime.now(), currentWeek),
      actions: getActions(isSessonPeriod),
    );
  }

  Widget getTitle(DateTime now, int currentWeek) => Builder(builder: (context) {
        return Align(
          alignment: Alignment.topLeft,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  '${now.day}-е ${ScheduleWidgetConstants.monthesList[now.month - 1]}',
                  style:
                      Theme.of(context).extension<AppTextTheme>()!.titleStyle),
              Text(
                '$currentWeek-я учебная неделя',
                style: Theme.of(context)
                    .extension<AppTextTheme>()!
                    .bodyStyle
                    .copyWith(color: Colors.grey),
              ),
            ],
          ),
        );
      });

  List<Widget> getActions(bool isSessionPeriod) => [
        if (_currentScheduleType != ScheduleViewType.exams) ...[
          PopupMenuButton(
            tooltip: 'Подгруппа',
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: ScheduleGroupType.allGroup,
                child: Row(
                  children: [
                    Icon(Icons.group_outlined),
                    SizedBox(width: 8),
                    Text('Вся группа'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: ScheduleGroupType.firstSubgroup,
                child: Row(
                  children: [
                    Icon(Icons.person_2_outlined),
                    SizedBox(width: 8),
                    Text('1-я подгруппа'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: ScheduleGroupType.secondSubgroup,
                child: Row(
                  children: [
                    Icon(Icons.person_3_outlined),
                    SizedBox(width: 8),
                    Text('2-я подгруппа'),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              setState(() {
                _currentGroupType = value;
              });
              Provider.of<ScheduleScreenViewModel>(context, listen: false)
                  .setScheduleGroupType(value);
            },
            child: const Icon(Icons.group_outlined),
          ),
          const SizedBox(width: 10),
        ],
        PopupMenuButton(
          tooltip: 'Вид расписания',
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: ScheduleViewType.full,
              child: Text('Полное'),
            ),
            const PopupMenuItem(
              value: ScheduleViewType.dayly,
              child: Text('По дням'),
            ),
            if (isSessionPeriod) ...[
              const PopupMenuItem(
                value: ScheduleViewType.exams,
                child: Text('Экзамены'),
              ),
            ],
          ],
          onSelected: (value) {
            setState(() {
              _currentScheduleType = value;
            });
            Provider.of<ScheduleScreenViewModel>(context, listen: false)
                .setScheduleViewType(value);
          },
          child: const Icon(Icons.grid_view_rounded),
        ),
        IconButton(
          tooltip: 'На стройку',
          onPressed: () {
            Navigator.of(context).pushNamed(NavigationRoutes.settings);
          },
          icon: const Icon(Icons.settings_outlined),
        )
      ];
}
