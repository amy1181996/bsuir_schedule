part of 'schedule_screen.dart';

class _ScheduleScreenBodyWidget extends StatelessWidget {
  final List<DaySchedule> schedules;
  final ScheduleViewType currentScheduleType;

  const _ScheduleScreenBodyWidget({
    required this.schedules,
    required this.currentScheduleType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (schedules.isEmpty) ...[
          const SizedBox.shrink(),
        ] else ...[
          switch (currentScheduleType!) {
            ScheduleViewType.dayly => getTabBar(schedules),
            ScheduleViewType.full => getTabBar(schedules),
            ScheduleViewType.exams => const SizedBox.shrink(),
            ScheduleViewType.announcements => const SizedBox.shrink(),
          },
          if (currentScheduleType == ScheduleViewType.dayly) ...[
            const SizedBox(height: 15),
            LessonTimeBar(daySchedule: schedules.firstOrNull),
          ],
        ],
        getTabBarView(schedules),
      ],
    );
  }

  Widget getTabBar(List<DaySchedule> schedule) => Builder(
      builder: (context) => Container(
            color: Theme.of(context).appBarTheme.backgroundColor,
            child: TabBar(
              indicatorColor: Theme.of(context).primaryColor,
              physics: const BouncingScrollPhysics(),
              isScrollable: true,
              tabs: schedule
                  .map((e) => LessonTab(
                        scheduleType: currentScheduleType!,
                        date: e.date,
                      ))
                  .toList(),
            ),
          ));

  Widget getTabBarView(List<DaySchedule> schedule) => Expanded(
        child: TabBarView(
          physics: const BouncingScrollPhysics(),
          children: schedule
              .map(
                (e) => LessonListWidget(
                  daySchedule: e,
                  scheduleViewType: currentScheduleType,
                  scheduleEntityType: null,
                  // widget.scheduleDescriptor?.scheduleEntityType,
                  startDate: DateTime.now(),
                  // widget.scheduleFactory.startDate ?? DateTime.now(),
                  endDate: DateTime.now().add(
                    const Duration(days: 14),
                  ), // widget.scheduleFactory.endDate ?? DateTime.now(),
                ),
              )
              .toList(),
        ),
      );
}
