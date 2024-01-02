import 'dart:async';

import 'package:bsuir_schedule/data/db/db_helper/db_helper.dart';
import 'package:bsuir_schedule/domain/model/schedule_descriptor.dart';
import 'package:bsuir_schedule/domain/model/schedule_factory.dart';
import 'package:bsuir_schedule/domain/view_model/root_screen_view_model.dart';
import 'package:bsuir_schedule/domain/view_model/schedule_screen_view_model.dart';
import 'package:bsuir_schedule/ui/screens/view_constants.dart';
import 'package:bsuir_schedule/ui/themes/app_text_theme.dart';
import 'package:bsuir_schedule/ui/widget/lecturer_image_factory.dart';
import 'package:bsuir_schedule/ui/widget/lesson_bottom_sheet.dart';
import 'package:bsuir_schedule/ui/widget/lesson_card.dart';
import 'package:bsuir_schedule/ui/widget/lesson_tab.dart';
import 'package:bsuir_schedule/ui/widget/lesson_time_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../navigation/navigation.dart';
import '../../widget/date_button.dart';

part 'schedule_screen_app_bar.dart';
part 'schedule_screen_body.dart';

// TODO: refactor this shitty code

// корневой виджет отслеживает текущее выбранное расписание и получает его от VM
// виджет внутри получает ScheduleFactory и в качестве состояния использует вид расписания

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  ScheduleFactory? _scheduleFactory;
  ScheduleDescriptor? _scheduleDescriptor;

  @override
  Widget build(BuildContext context) {
    final rootViewModel = context.watch<RootScreenViewModel>();
    final viewModel = context.watch<ScheduleScreenViewModel>();
    _scheduleDescriptor = rootViewModel.currentScheduleDescriptor;

    final currentScheduleType = viewModel.scheduleViewType;
    final currentGroupType = viewModel.scheduleGroupType;

    return FutureBuilder(
        future: _fetchData(rootViewModel.db, viewModel),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final schedules = _scheduleFactory!.getSchedule(
              scheduleViewType: currentScheduleType,
              scheduleGroupType: currentGroupType,
            );

            return DefaultTabController(
              length: schedules.length,
              child: SafeArea(
                child: Scaffold(
                  body: NestedScrollView(
                    headerSliverBuilder: (
                      BuildContext context,
                      bool innerBoxIsScrolled,
                    ) =>
                        [
                      _ScheduleScreenAppBar(
                        scheduleFactory: _scheduleFactory!,
                        scheduleDescriptor: _scheduleDescriptor,
                        onScheduleViewTypeChanged: null,
                        onScheduleGroupTypeChanged: null,
                        onDateChanged: null,
                      ),
                    ],
                    body: _ScheduleScreenBodyWidget(
                      schedules: schedules,
                      currentScheduleType: currentScheduleType,
                    ),
                  ),
                ),
              ),
              // ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Future<void> _fetchData(
      DatabaseHelper db, ScheduleScreenViewModel viewModel) async {
    _scheduleFactory = _scheduleDescriptor == null
        ? ScheduleFactory.empty()
        : await viewModel.getSchedule(
            db: db,
            scheduleDescriptor: _scheduleDescriptor!,
          );
  }
}

class ScheduleScreenTabBarView extends StatelessWidget {
  final List<DaySchedule> schedule;
  final ScheduleViewType? currentScheduleType;
  final ScheduleDescriptor? scheduleDescriptor;
  final DateTime? startDate;
  final DateTime? endDate;

  const ScheduleScreenTabBarView({
    super.key,
    required this.schedule,
    required this.currentScheduleType,
    required this.scheduleDescriptor,
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TabBarView(
        physics: const BouncingScrollPhysics(),
        children: schedule
            .map(
              (e) => LessonListWidget(
                daySchedule: e,
                scheduleViewType: currentScheduleType!,
                scheduleEntityType: scheduleDescriptor?.scheduleEntityType,
                startDate: startDate ?? DateTime.now(),
                endDate: endDate ?? DateTime.now(),
              ),
            )
            .toList(),
      ),
    );
  }
}

class TabBarSliverPersistentHeaderDelegate
    extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double maxHeight;
  final double minHeight;

  TabBarSliverPersistentHeaderDelegate({
    required this.child,
    required this.maxHeight,
    required this.minHeight,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Align(
      child: Container(
        color: Theme.of(context).appBarTheme.backgroundColor,
        child: child,
      ),
    );
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class LessonListWidget extends StatefulWidget {
  final ScheduleViewType scheduleViewType;
  final ScheduleEntityType? scheduleEntityType;
  final DaySchedule daySchedule;
  final DateTime startDate;
  final DateTime endDate;

  const LessonListWidget({
    Key? key,
    required this.scheduleViewType,
    required this.scheduleEntityType,
    required this.daySchedule,
    required this.startDate,
    required this.endDate,
  }) : super(key: key);

  @override
  State<LessonListWidget> createState() => _LessonListWidgetState();
}

class _LessonListWidgetState extends State<LessonListWidget>
    with AutomaticKeepAliveClientMixin {
  static final imageFactory = LecturerImageFactory();

  String _convertDate(DateTime date) {
    return '${date.day} ${ScheduleWidgetConstants.monthesList[date.month - 1]}';
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final cardKeyMixin =
        'lesson_list_widget_card_key_${widget.daySchedule.date}}';

    final List<Widget> lessonCards =
        List.generate(widget.daySchedule.lessons.length, (index) {
      final lesson = widget.daySchedule.lessons[index];
      final shouldShowTimeGradient =
          widget.scheduleViewType == ScheduleViewType.dayly ? true : false;

      return LessonCard(
        key: ValueKey(lesson.hashCode ^ cardKeyMixin.hashCode),
        lesson: lesson,
        currentTime: widget.daySchedule.date ?? DateTime.now(),
        shouldShowTimeGradient: shouldShowTimeGradient,
        scheduleEntityType: widget.scheduleEntityType,
        image: imageFactory.fetchImage(
          radius: 20,
          borderSize: 0,
          lecturer: lesson.lecturers.firstOrNull,
        ),
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          builder: (context) => LessonBottomSheet(
            lesson: lesson,
            scheduleEntityType: widget.scheduleEntityType,
            image: imageFactory.fetchImage(
              radius: 25,
              borderSize: 0,
              lecturer: lesson.lecturers.firstOrNull,
            ),
          ),
        ),
      );
    });

    final textTheme = Theme.of(context).extension<AppTextTheme>()!;
    final textStyle = textTheme.bodyStyle;

    if (lessonCards.isEmpty) {
      if (widget.scheduleEntityType == null) {
        return Center(
          child: Text(
            'Выберите расписание',
            style: textStyle,
          ),
        );
      }

      if (widget.scheduleViewType == ScheduleViewType.dayly) {
        final now = widget.daySchedule.date;

        if (now!.compareTo(widget.startDate) < 0) {
          return Center(
            child: Text(
              'Занятия начнутся ${_convertDate(widget.startDate)}',
              style: textStyle,
            ),
          );
        } else if (now.compareTo(widget.endDate) > 0) {
          return Center(
            child: Text(
              'Занятия закончились ${_convertDate(widget.endDate)}',
              style: textStyle,
            ),
          );
        }
      }

      return Center(
        child: Text(
          'Отдыхай',
          style: textStyle,
        ),
      );
    }

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate([
            const SizedBox(height: 10),
            ...lessonCards,
            const SizedBox(height: 15),
          ]),
        )
      ],
    );
  }
}
