import 'dart:async';

import 'package:bsuir_schedule/application/settings/models/app_settings.dart';
import 'package:bsuir_schedule/application/settings/settings_provider.dart';
import 'package:bsuir_schedule/domain/model/lecturer.dart';
import 'package:bsuir_schedule/domain/model/lesson.dart';
import 'package:bsuir_schedule/ui/themes/lesson_card_style.dart';
import 'package:bsuir_schedule/ui/screens/view_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/model/schedule_descriptor.dart';

class LessonCard extends StatelessWidget {
  final LessonCardStyle? style;

  final Lesson lesson;
  final ScheduleEntityType? scheduleEntityType;
  final Widget? image;
  final bool shouldShowTimeGradient;
  final DateTime currentTime;
  final VoidCallback? onPressed;

  const LessonCard({
    Key? key,
    this.style,
    required this.lesson,
    required this.shouldShowTimeGradient,
    required this.currentTime,
    required this.scheduleEntityType,
    this.image,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LessonCardStyle defaultStyle =
        Theme.of(context).extension<LessonCardStyle>()!;

    Color backgroundColor =
        style?.backgroundColor ?? defaultStyle.backgroundColor;
    TextStyle titleStyle = style?.titleStyle ?? defaultStyle.titleStyle;
    TextStyle bodyStyle = style?.bodyStyle ?? defaultStyle.bodyStyle;
    TextStyle secondayBodyStyle =
        style?.secondayBodyStyle ?? defaultStyle.secondayBodyStyle;
    double borderRadius = style?.borderRadius ?? defaultStyle.borderRadius;

    return GestureDetector(
      onTap: onPressed,
      child: IntrinsicHeight(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          ),
          child: getCard(context, titleStyle, bodyStyle, secondayBodyStyle),
        ),
      ),
    );
  }

  static const Map<LessonColor, Color> lessonColorToColor = {
    LessonColor.red: Colors.red,
    LessonColor.amber: Colors.amber,
    LessonColor.yellowAccent: Colors.yellowAccent,
    LessonColor.green: Colors.green,
    LessonColor.blue: Colors.blue,
    LessonColor.purple: Colors.purple,
    LessonColor.violet: Color.fromARGB(255, 135, 8, 190),
    LessonColor.grey: Colors.grey,
  };

  Color getLessonColor(BuildContext context, String lessonAbbrev) =>
      switch (lessonAbbrev) {
        'ЛК' => lessonColorToColor[
            Provider.of<SettingsProvider>(context).lectureColor]!,
        'ЛР' => lessonColorToColor[
            Provider.of<SettingsProvider>(context).laboratoryColor]!,
        'ПЗ' => lessonColorToColor[
            Provider.of<SettingsProvider>(context).practiceColor]!,
        'Консультация' => lessonColorToColor[
            Provider.of<SettingsProvider>(context).consultColor]!,
        'Экзамен' =>
          lessonColorToColor[Provider.of<SettingsProvider>(context).examColor]!,
        'ОБ' => lessonColorToColor[
            Provider.of<SettingsProvider>(context).announcementColor]!,
        _ => lessonColorToColor[
            Provider.of<SettingsProvider>(context).unknownColor]!
      };

  Widget getCard(
    BuildContext context,
    TextStyle titleStyle,
    TextStyle bodyStyle,
    TextStyle secondayBodyStyle,
  ) {
    final lessonColor = getLessonColor(context, lesson.lessonTypeAbbrev);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        getLessonTime(titleStyle, secondayBodyStyle),
        const SizedBox(
          width: 10,
        ),
        getColoredLine(color: lessonColor),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // if (lesson.isAnnouncement)
              //   getAnnouncmentTitle(context, titleStyle, bodyStyle)
              // else
                getLessonTitle(context, titleStyle, bodyStyle),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  getAuditory(bodyStyle),
                  if (lesson.dateLesson != null && lesson.weeks.isNotEmpty)
                    getWeeks(bodyStyle)
                  else
                    getExamDate(bodyStyle),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              // if (lesson.isAnnouncement == false &&
              //     lesson.note != null &&
              //     lesson.note!.isNotEmpty)
  // ScheduleEntityType? _currentScheduleEntityType;

              //   getNote(bodyStyle),
              if (scheduleEntityType == ScheduleEntityType.lecturer)
                getGroupInfo(bodyStyle)
              else
                getLecturerInfo(bodyStyle),
            ],
          ),
        ),
      ],
    );
  }

  Widget getLessonTitle(
    BuildContext context,
    TextStyle titleStyle,
    TextStyle bodyStyle,
  ) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            '${lesson.subject} (${lesson.lessonTypeAbbrev})',
            style: titleStyle.copyWith(
              color: getLessonColor(context, lesson.lessonTypeAbbrev),
            ),
          ),
          if (lesson.numSubgroup != 0) ...[
            const Spacer(),
            Text(
              '${lesson.numSubgroup}-я подгруппа',
              style: bodyStyle,
            ),
          ]
        ],
      );

  Widget getLessonTime(TextStyle bodyStyle, TextStyle secondaryBodyStyle) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            lesson.startLessonTime,
            style: bodyStyle,
          ),
          Text(
            lesson.endLessonTime,
            style: secondaryBodyStyle,
          ),
        ],
      );

  Widget getAnnouncmentTitle(
    BuildContext context,
    TextStyle titleStyle,
    TextStyle bodyStyle,
  ) =>
      Text(
        lesson.note!,
        style: titleStyle.copyWith(
          color: getLessonColor(context, lesson.lessonTypeAbbrev),
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );

  Widget getColoredLine({required Color color}) {
    List<String> parts = lesson.startLessonTime.split(':');
    int startHour = int.parse(parts[0]);
    int startMinute = int.parse(parts[1]);

    parts = lesson.endLessonTime.split(':');
    int endHour = int.parse(parts[0]);
    int endMinute = int.parse(parts[1]);

    return _TimeGradientWidget(
      color: color,
      startTime: DateTime(currentTime.year, currentTime.month, currentTime.day,
          startHour, startMinute),
      endTime: DateTime(currentTime.year, currentTime.month, currentTime.day,
          endHour, endMinute),
      shouldShowGradient: true,
    );
  }

  Widget getAuditory(TextStyle bodyStyle) =>
      lesson.auditories.where((element) => element.isNotEmpty).isNotEmpty
          ? Text(
              'ауд. ${lesson.auditories.join(', ')}',
              style: bodyStyle,
            )
          : const SizedBox.shrink();

  Widget getWeeks(TextStyle bodyStyle) => lesson.weeks.isNotEmpty
      ? Text(
          'нед. ${lesson.weeks.join(', ')}',
          style: bodyStyle,
        )
      : const SizedBox.shrink();

  Widget getExamDate(TextStyle bodyStyle) => lesson.dateLesson != null
      ? Text(
          lesson.dateLesson!.toString(),
          style: bodyStyle,
        )
      : const SizedBox.shrink();

  Widget getNote(TextStyle bodyStyle) => lesson.note != null
      ? Column(
          children: [
            Text(
              lesson.note!,
              style: bodyStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 5),
          ],
        )
      : const SizedBox.shrink();

  Widget getLecturerInfo(TextStyle bodyStyle) {
    final Lecturer? lecturer = lesson.lecturers.firstOrNull;

    return lecturer != null
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lecturer.lastName,
                    style: bodyStyle.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${lecturer.firstName} ${lecturer.middleName}',
                    style: bodyStyle,
                  ),
                ],
              ),
              image ?? const SizedBox.shrink(),
            ],
          )
        : const SizedBox.shrink();
  }

  Widget getGroupInfo(TextStyle bodyStyle) {
    final groups = lesson.studentGroups;

    return !lesson.subject.toLowerCase().contains('спецп') &&
            !lesson.subject.toLowerCase().contains('физк')
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      groups.map((group) => group.name).join(', '),
                      style: bodyStyle.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      groups
                          .map((group) =>
                              '${group.facultyAbbrev} ${group.specialityAbbrev}')
                          .join(', '),
                      style: bodyStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const CircleAvatar(
                radius: 20,
                child: Icon(Icons.person_outline),
              )
            ],
          )
        : const SizedBox.shrink();
  }
}

class _TimeGradientWidget extends StatefulWidget {
  final DateTime startTime;
  final DateTime endTime;
  final Color color;
  final bool shouldShowGradient;

  static const lessonPeriodInMinutes = 80;

  const _TimeGradientWidget({
    Key? key,
    required this.startTime,
    required this.endTime,
    required this.color,
    required this.shouldShowGradient,
  }) : super(key: key);

  @override
  State<_TimeGradientWidget> createState() => _TimeGradientWidgetState();
}

class _TimeGradientWidgetState extends State<_TimeGradientWidget> {
  final ValueNotifier<DateTime> _dateTime =
      ValueNotifier<DateTime>(DateTime.now());

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 15), (_) {
      _dateTime.value = DateTime.now();
    });
  }

  // @override
  // void dispose() {
  //   _dateTime.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<DateTime>(
      valueListenable: _dateTime,
      builder: (context, currentTime, child) {
        double progress = currentTime.difference(widget.startTime).inMinutes /
            _TimeGradientWidget.lessonPeriodInMinutes;

        // print(
        //     'progress in minutes: ${dateTime.difference(widget.startTime).inMinutes}');
        // print('progress: $progress');
        if (!widget.shouldShowGradient ||
            widget.startTime.isAfter(currentTime)) {
          return Container(
            width: 7,
            decoration: BoxDecoration(
              color: widget.color,
              borderRadius: const BorderRadius.all(Radius.circular(4)),
            ),
          );
        }

        if (widget.endTime.isBefore(currentTime)) {
          return Container(
            width: 7,
            decoration: const BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
          );
        }

        return Container(
          width: 7,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [progress, progress],
              colors: [
                Colors.grey,
                widget.color,
              ],
            ),
            borderRadius: const BorderRadius.all(Radius.circular(4)),
          ),
        );
      },
    );
  }
}

class LessonMultiChildLayoutDelegate extends MultiChildLayoutDelegate {
  @override
  Size getSize(BoxConstraints constraints) => constraints.smallest;

  @override
  void performLayout(Size size) {
    // TODO: implement performLayout
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) {
    return true;
  }
  
}
