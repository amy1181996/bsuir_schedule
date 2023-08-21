import 'package:flutter/material.dart';

enum ScheduleViewType {
  fullAllGroup,
  fullFirstSubgroup,
  fullSecondSubgroup,
  daylyAllGroup,
  daylyFirstSubgroup,
  daylySecondSubgroup,
  exams,
}

enum ScheduleEntityType {
  group,
  lecturer,
}

abstract class ScheduleWidgetConstants {
  static const monthesList = [
    'Января',
    'Февраля',
    'Марта',
    'Апреля',
    'Мая',
    'Июня',
    'Июля',
    'Августа',
    'Сентября',
    'Октября',
    'Ноября',
    'Декабря'
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
