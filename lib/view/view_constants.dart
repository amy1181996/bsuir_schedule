import 'package:flutter/material.dart';

enum ScheduleViewType {
  full,
  dayly,
  exams,
}

enum ScheduleGroupType {
  allGroup,
  firstSubgroup,
  secondSubgroup,
}

enum ScheduleEntityType {
  group,
  lecturer,
}

abstract class ScheduleWidgetConstants {
  static const monthesList = [
    'января',
    'февраля',
    'марта',
    'апреля',
    'мая',
    'июня',
    'июля',
    'августа',
    'сентября',
    'октября',
    'ноября',
    'декабря'
  ];

  static const weekdayList = [
    'Понедельник',
    'Вторник',
    'Среда',
    'Четверг',
    'Пятница',
    'Суббота',
    'Воскресенье'
  ];

  static const weekdayAbbrevList = ['ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ', 'СБ', 'ВС'];

  static const Map<String, String> lessonsTypeFullName = {
    'ЛК': 'Лекция',
    'ЛР': 'Лабораторная работа',
    'ПЗ': 'Практическое занятие',
  };

  static const lessonColors = {
    'ЛК': Colors.green,
    'Консультация': Colors.green,
    'ЛР': Colors.red,
    'ПЗ': Colors.yellow,
    'Экзамен': Color.fromARGB(255, 135, 8, 190),
  };
}
