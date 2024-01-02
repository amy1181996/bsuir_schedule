part of 'schedule_screen.dart';

class _ScheduleScreenAppBar extends StatelessWidget {
  final void Function(ScheduleViewType)? onScheduleViewTypeChanged;
  final void Function(ScheduleGroupType)? onScheduleGroupTypeChanged;
  final void Function(DateTime)? onDateChanged;

  final ScheduleFactory _scheduleFactory;
  final ScheduleDescriptor? _scheduleDescriptor;

  const _ScheduleScreenAppBar({
    super.key,
    required ScheduleFactory scheduleFactory,
    required ScheduleDescriptor? scheduleDescriptor,
    this.onScheduleViewTypeChanged,
    this.onScheduleGroupTypeChanged,
    this.onDateChanged,
  })  : _scheduleFactory = scheduleFactory,
        _scheduleDescriptor = scheduleDescriptor;

  @override
  Widget build(BuildContext context) {
    bool isSessionPeriod = _scheduleFactory!
        .getSchedule(scheduleViewType: ScheduleViewType.exams)
        .first
        .lessons
        .isNotEmpty;
    bool hasAnnouncements = _scheduleFactory!
        .getSchedule(scheduleViewType: ScheduleViewType.announcements)
        .first
        .lessons
        .isNotEmpty;

    return SliverAppBar(
      expandedHeight: 30,
      floating: true,
      pinned: false,
      title: getTitle(
        _scheduleFactory.currentDate ?? DateTime.now(),
        _scheduleFactory.currentWeek ?? 1,
      ),
      actions: getActions(isSessionPeriod, hasAnnouncements, () {
        Navigator.of(context).pushNamed(NavigationRoutes.settings);
      }),
    );
  }

  List<Widget> getActions(bool isSessionPeriod, bool hasAnnouncements, Function()? navigate) => [
    if (_scheduleDescriptor != null) ...[
      if (_scheduleDescriptor!.scheduleViewType ==
          ScheduleViewType.dayly ||
          _scheduleDescriptor!.scheduleViewType ==
              ScheduleViewType.full) ...[
        getSubgroupButton(),
      ],
      getScheduleViewButton(isSessionPeriod, hasAnnouncements),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: DateButton(
          onPressed: setDate,
        ),
      ),
    ],
    IconButton(
      tooltip: 'На стройку',
      onPressed: navigate ?? () {},
      icon: const Icon(Icons.settings_outlined),
    ),
  ];

  Widget getTitle(DateTime now, int currentWeek) => Builder(builder: (context) {
        return Align(
          alignment: Alignment.topLeft,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getGreeting(),
                style: Theme.of(context).extension<AppTextTheme>()!.titleStyle,
              ),
              Text(
                '${now.day}-е ${ScheduleWidgetConstants.monthesList[now.month - 1]}, '
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

  String getGreeting() {
    if (_scheduleDescriptor == null) {
      return 'Выберите расписание';
    }

    final scheduleName = _scheduleFactory.getScheduleName();

    switch (_scheduleDescriptor!.scheduleViewType) {
      case ScheduleViewType.full:
        return 'Расписание $scheduleName';
      case ScheduleViewType.dayly:
        return 'Расписание $scheduleName';
      case ScheduleViewType.exams:
        return 'Экзамены $scheduleName';
      case ScheduleViewType.announcements:
        return 'Объявления $scheduleName';
      default:
        return 'Выберите расписание';
    }
  }

  Widget getScheduleViewButton(bool isSessionPeriod, bool hasAnnouncements) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: PopupMenuButton(
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
          if (hasAnnouncements) ...[
            const PopupMenuItem(
              value: ScheduleViewType.announcements,
              child: Text('Объявления'),
            ),
          ],
        ],
        onSelected: (value) {
          onScheduleViewTypeChanged?.call(value);
        },
        child: const Icon(Icons.grid_view_rounded),
      ),
    );
  }

  Padding getSubgroupButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: PopupMenuButton(
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
          onScheduleGroupTypeChanged?.call(value);
        },
        child: const Icon(Icons.group_outlined),
      ),
    );
  }

  Future<void> setDate() async {
    final now = DateTime.now();
    final startDate =
        _scheduleFactory.startDate ?? DateTime(now.year, 9, 1);
    final endDate =
        _scheduleFactory.endDate ?? DateTime(now.year + 1, 5, 31);

    final newDate = DateTime.now();
    // final newDate = await showDatePicker(
    //   context: context,
    //   initialDate: DateTime.now(),
    //   firstDate: startDate,
    //   lastDate: endDate,
    // );

    if (newDate != null) {
      onDateChanged?.call(newDate);
    }
  }
}
