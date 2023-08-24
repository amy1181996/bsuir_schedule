import 'package:bsuir_schedule/domain/model/lecturer.dart';
import 'package:bsuir_schedule/domain/model/lesson.dart';
import 'package:bsuir_schedule/themes/lesson_card_style.dart';
import 'package:bsuir_schedule/view/view_constants.dart';
import 'package:flutter/material.dart';

class LessonCard extends StatelessWidget {
  final LessonCardStyle? style;

  final Lesson lesson;
  final ScheduleEntityType scheduleEntityType;
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
          child: getCard(titleStyle, bodyStyle, secondayBodyStyle),
        ),
      ),
    );
  }

  Widget getCard(
    TextStyle titleStyle,
    TextStyle bodyStyle,
    TextStyle secondayBodyStyle,
  ) {
    final lessonColor =
        ScheduleWidgetConstants.lessonColors[lesson.lessonTypeAbbrev] ??
            Colors.grey;

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
              getLessonTitle(titleStyle, bodyStyle),
              const SizedBox(
                height: 5,
              ),
              getLessonAdditionalInfo(bodyStyle),
              const SizedBox(
                height: 5,
              ),
              if (lesson.note != null && lesson.note!.isNotEmpty)
                getNote(bodyStyle),
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

  Widget getLessonTime(TextStyle bodyStyle, TextStyle secondaryBodyStyle) {
    return Column(
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
  }

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
      shouldShowGradiend: true,
    );
  }

  Widget getLessonTitle(TextStyle titleStyle, TextStyle bodyStyle) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            '${lesson.subject} (${lesson.lessonTypeAbbrev})',
            style: titleStyle.copyWith(
                color: ScheduleWidgetConstants
                        .lessonColors[lesson.lessonTypeAbbrev] ??
                    Colors.grey),
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

  Widget getLessonAdditionalInfo(TextStyle bodyStyle) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          getAuditory(bodyStyle),
          if (lesson.weeks.isNotEmpty)
            getWeeks(bodyStyle)
          else
            getExamDate(bodyStyle),
        ],
      );

  Widget getAuditory(TextStyle bodyStyle) =>
      lesson.auditories.where((element) => element.isNotEmpty).isNotEmpty
          ? Text(
              'ауд. ${lesson.auditories.join(', ')}',
              style: bodyStyle,
            )
          : const SizedBox.shrink();

  Widget getSubgroupNumber(TextStyle bodyStyle) => lesson.numSubgroup != 0
      ? Text(
          '${lesson.numSubgroup}-я подгруппа',
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
              getLecturerFullName(bodyStyle),
              image ?? const SizedBox.shrink()
            ],
          )
        : const SizedBox.shrink();
  }

  Widget getGroupInfo(TextStyle bodyStyle) {
    final groups = lesson.studentGroups;

    return !lesson.subject.toLowerCase().contains('спецп') &&
            !lesson.subject.toLowerCase().contains('физк')
        ? Text(
            groups.map((group) => group.name).join(', '),
            style: bodyStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
        : const SizedBox.shrink();
  }

  Widget getLecturerFullName(TextStyle bodyStyle) {
    final lecturer = lesson.lecturers.firstOrNull;

    return lecturer != null
        ? Column(
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
          )
        : const SizedBox.shrink();
  }
}

class _TimeGradientWidget extends StatefulWidget {
  final DateTime startTime;
  final DateTime endTime;
  final Color color;
  final bool shouldShowGradiend;

  static const lessonPeriodInMinutes = 80;

  const _TimeGradientWidget({
    Key? key,
    required this.startTime,
    required this.endTime,
    required this.color,
    required this.shouldShowGradiend,
  }) : super(key: key);

  @override
  State<_TimeGradientWidget> createState() => _TimeGradientWidgetState();
}

class _TimeGradientWidgetState extends State<_TimeGradientWidget> {
  @override
  Widget build(BuildContext context) {
    // const timeString = '11:00';
    // List<String> parts = timeString.split(':');
    // int hour = int.parse(parts[0]);
    // int minute = int.parse(parts[1]);

    // final now = DateTime.now();
    // final currentTime = DateTime(now.year, now.month, now.day, hour, minute);
    final currentTime = DateTime.now();

    if (!widget.shouldShowGradiend || widget.startTime.isAfter(currentTime)) {
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

    double progress = currentTime.difference(widget.startTime).inMinutes /
        _TimeGradientWidget.lessonPeriodInMinutes;
    // print(
    //     'progress in minutes: ${currentTime.difference(widget.startTime).inMinutes}');
    // print('progress: $progress');

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
  }
}
