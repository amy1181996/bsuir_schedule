import 'package:bsuir_schedule/application/settings/models/app_settings.dart';
import 'package:bsuir_schedule/application/settings/settings_provider.dart';
import 'package:bsuir_schedule/ui/themes/app_text_theme.dart';
import 'package:bsuir_schedule/ui/themes/settings_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widget/settings_helpers.dart';

enum _AppTheme {
  light,
  dark,
  system,
  byDefault,
}

// enum _AppIcon {
//   light,
//   dark,
//   pride,
//   byDefault,
// }

class SettingsScreen extends StatelessWidget {
  final SettingsTheme? theme;

  const SettingsScreen({
    super.key,
    this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).extension<AppTextTheme>()!.titleStyle;
    final bodyStyle = Theme.of(context).extension<AppTextTheme>()!.bodyStyle;
    final defaultTheme = Theme.of(context).extension<SettingsTheme>()!;
    final scaffoldColor = theme?.scaffoldColor ?? defaultTheme.scaffoldColor;
    final menuColor = theme?.menuColor ?? defaultTheme.menuColor;

    return Scaffold(
      backgroundColor: scaffoldColor,
      body: NestedScrollView(
        headerSliverBuilder: (
          BuildContext context,
          bool innerBoxIsScrolled,
        ) =>
            <Widget>[
          SliverAppBar(
              expandedHeight: 100,
              pinned: true,
              floating: true,
              flexibleSpace: FlexibleSpaceBar(
                expandedTitleScale: 1,
                centerTitle: true,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Настройки',
                      style: titleStyle,
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.settings_outlined,
                    ),
                  ],
                ),
              )),
        ],
        body: SingleChildScrollView(
          child: Column(children: [
            const SizedBox(
              height: 20,
            ),
            getColorsSettings(bodyStyle, menuColor),
            const SizedBox(
              height: 20,
            ),
            getThemeSettings(bodyStyle, menuColor),
            const SizedBox(
              height: 20,
            ),
          ]),
        ),
      ),
    );
  }

  Widget getColoredBox(Color color) => Container(
        height: 20,
        width: 20,
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
      );

  Widget getColorsSettings(TextStyle bodyStyle, Color backgroundColor) {
    final Map<LessonColor, Color> lessonColorToColor = {
      LessonColor.red: Colors.red,
      LessonColor.amber: Colors.amber,
      LessonColor.yellowAccent: Colors.yellowAccent,
      LessonColor.green: Colors.green,
      LessonColor.blue: Colors.blue,
      LessonColor.purple: Colors.purple,
      LessonColor.violet: const Color.fromARGB(255, 135, 8, 190),
      LessonColor.grey: Colors.grey,
    };

    final colorSwitcherItems = <SettingsSelectorItem<LessonColor>>[
      SettingsSelectorItem(
        name: 'Красный',
        value: LessonColor.red,
        trailing: getColoredBox(Colors.red),
      ),
      SettingsSelectorItem(
        name: 'Янтарный',
        value: LessonColor.amber,
        trailing: getColoredBox(Colors.amber),
      ),
      SettingsSelectorItem(
        name: 'Желтый',
        value: LessonColor.yellowAccent,
        trailing: getColoredBox(Colors.yellowAccent),
      ),
      SettingsSelectorItem(
        name: 'Зеленый',
        value: LessonColor.green,
        trailing: getColoredBox(Colors.green),
      ),
      SettingsSelectorItem(
        name: 'Голубой',
        value: LessonColor.blue,
        trailing: getColoredBox(Colors.blue),
      ),
      SettingsSelectorItem(
        name: 'Пурпурный',
        value: LessonColor.purple,
        trailing: getColoredBox(Colors.purple),
      ),
      SettingsSelectorItem(
        name: 'Фиолетовый',
        value: LessonColor.violet,
        trailing: getColoredBox(const Color.fromARGB(255, 135, 8, 190)),
      ),
      SettingsSelectorItem(
        name: 'Серый',
        value: LessonColor.grey,
        trailing: getColoredBox(Colors.grey),
      ),
    ];

    return Builder(builder: (context) {
      return SettingsBlock(
        backgroundColor: backgroundColor,
        title: Text(
          'Цвета',
          style: bodyStyle.copyWith(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        items: [
          SettingsSelector<LessonColor>(
            leading: getColoredBox(lessonColorToColor[
                Provider.of<SettingsProvider>(context).lectureColor]!),
            title: Text(
              'Лекция',
              style: bodyStyle,
            ),
            items: colorSwitcherItems
                .map((e) => e.copyWith(onPressed: () {
                      Provider.of<SettingsProvider>(context, listen: false)
                          .setLectureColor(e.value);
                    }))
                .toList(),
            currentValue: Provider.of<SettingsProvider>(context).lectureColor,
          ),
          SettingsSelector<LessonColor>(
            leading: getColoredBox(lessonColorToColor[
                Provider.of<SettingsProvider>(context).practiceColor]!),
            title: Text(
              'Практическое занятие',
              style: bodyStyle,
            ),
            items: colorSwitcherItems
                .map((e) => e.copyWith(onPressed: () {
                      Provider.of<SettingsProvider>(context, listen: false)
                          .setPracticeColor(e.value);
                    }))
                .toList(),
            currentValue: Provider.of<SettingsProvider>(context).practiceColor,
          ),
          SettingsSelector<LessonColor>(
            leading: getColoredBox(lessonColorToColor[
                Provider.of<SettingsProvider>(context).laboratoryColor]!),
            title: Text(
              'Лабораторная',
              style: bodyStyle,
            ),
            items: colorSwitcherItems
                .map((e) => e.copyWith(onPressed: () {
                      Provider.of<SettingsProvider>(context, listen: false)
                          .setLaboratoryColor(e.value);
                    }))
                .toList(),
            currentValue:
                Provider.of<SettingsProvider>(context).laboratoryColor,
          ),
          SettingsSelector<LessonColor>(
            leading: getColoredBox(lessonColorToColor[
                Provider.of<SettingsProvider>(context).consultColor]!),
            title: Text(
              'Консультация',
              style: bodyStyle,
            ),
            items: colorSwitcherItems
                .map((e) => e.copyWith(onPressed: () {
                      Provider.of<SettingsProvider>(context, listen: false)
                          .setConsultColor(e.value);
                    }))
                .toList(),
            currentValue: Provider.of<SettingsProvider>(context).consultColor,
          ),
          SettingsSelector<LessonColor>(
            leading: getColoredBox(lessonColorToColor[
                Provider.of<SettingsProvider>(context).examColor]!),
            title: Text(
              'Экзамен',
              style: bodyStyle,
            ),
            items: colorSwitcherItems
                .map((e) => e.copyWith(onPressed: () {
                      Provider.of<SettingsProvider>(context, listen: false)
                          .setExamColor(e.value);
                    }))
                .toList(),
            currentValue: Provider.of<SettingsProvider>(context).examColor,
          ),
          SettingsSelector<LessonColor>(
            leading: getColoredBox(lessonColorToColor[
                Provider.of<SettingsProvider>(context).announcementColor]!),
            title: Text(
              'Объявление',
              style: bodyStyle,
            ),
            items: colorSwitcherItems
                .map((e) => e.copyWith(onPressed: () {
                      Provider.of<SettingsProvider>(context, listen: false)
                          .setAnnouncementColor(e.value);
                    }))
                .toList(),
            currentValue:
                Provider.of<SettingsProvider>(context).announcementColor,
          ),
          SettingsSelector<LessonColor>(
            leading: getColoredBox(lessonColorToColor[
                Provider.of<SettingsProvider>(context).unknownColor]!),
            title: Text(
              'Неизвестно',
              style: bodyStyle,
            ),
            items: colorSwitcherItems
                .map((e) => e.copyWith(onPressed: () {
                      Provider.of<SettingsProvider>(context, listen: false)
                          .setUnknownColor(e.value);
                    }))
                .toList(),
            currentValue: Provider.of<SettingsProvider>(context).unknownColor,
          ),
          SettingsItem(
            onPressed: () =>
                Provider.of<SettingsProvider>(context, listen: false)
                    .resetLessonColors(),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Сбросить',
                  style: bodyStyle.copyWith(color: Colors.blue),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget getThemeSettings(TextStyle bodyStyle, Color backgroundColor) =>
      Builder(
        builder: (context) {
          return SettingsBlock(
            backgroundColor: backgroundColor,
            title: Text(
              'Внешний вид',
              style: bodyStyle.copyWith(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            items: <Widget>[
              SettingsSelector<_AppTheme>(
                leading: const Icon(Icons.palette_outlined),
                currentValue: _AppTheme.byDefault,
                title: Text(
                  'Тема приложения',
                  style: bodyStyle,
                ),
                items: [
                  SettingsSelectorItem(
                    name: 'Тёмная',
                    value: _AppTheme.dark,
                    trailing: const Icon(Icons.dark_mode_outlined),
                    onPressed: () => {
                      Provider.of<SettingsProvider>(context, listen: false)
                          .setTheme(AppColorScheme.dark),
                    },
                  ),
                  SettingsSelectorItem(
                    name: 'Светлая',
                    value: _AppTheme.light,
                    trailing: const Icon(Icons.light_mode_outlined),
                    onPressed: () => {
                      Provider.of<SettingsProvider>(context, listen: false)
                          .setTheme(AppColorScheme.light),
                    },
                  ),
                  SettingsSelectorItem(
                    name: 'Как в системе',
                    value: _AppTheme.system,
                    trailing: const Icon(Icons.auto_mode_outlined),
                    onPressed: () {
                      final systemBrightness =
                          MediaQuery.platformBrightnessOf(context);
                      Provider.of<SettingsProvider>(context, listen: false)
                          .setTheme(
                        systemBrightness == Brightness.dark
                            ? AppColorScheme.dark
                            : AppColorScheme.light,
                      );
                    },
                  ),
                ],
              ),
              SettingsSwitch(
                onChanged: (bool value) {
                  context.read<SettingsProvider>().setUseMaterial3(value);
                  print(value);
                },
                value: Provider.of<SettingsProvider>(context).useMaterial3,
                title: Text(
                  'Использовать Material тему?',
                  style: bodyStyle,
                ),
              ),
              SettingsItem(
                onPressed: () =>
                    Provider.of<SettingsProvider>(context, listen: false)
                        .resetColorTheme(),
                title: Text(
                  'Сбросить',
                  style: bodyStyle.copyWith(color: Colors.blue),
                ),
              ),
              // _SettingsSwitcher<_AppIcon>(
              //   leading: const Icon(Icons.flag_outlined),
              //   title: Text(
              //     'Иконка приложения',
              //     style: bodyStyle,
              //   ),
              //   items: [
              //     _SettingsSwitcherItem(
              //       name: 'Тёмная',
              //       value: _AppIcon.dark,
              //       onPressed: () => {
              //         Provider.of<SettingsProvider>(context, listen: false)
              //             .setAppIcon(AppIcon.dark),
              //       },
              //     ),
              //     _SettingsSwitcherItem(
              //       name: 'Светлая',
              //       value: _AppIcon.light,
              //       onPressed: () => {
              //         Provider.of<SettingsProvider>(context, listen: false)
              //             .setAppIcon(AppIcon.light),
              //       },
              //     ),
              //     _SettingsSwitcherItem(
              //       name: 'Pride',
              //       value: _AppIcon.pride,
              //       onPressed: () => {
              //         Provider.of<SettingsProvider>(context, listen: false)
              //             .setAppIcon(AppIcon.pride),
              //       },
              //     ),
              //     _SettingsSwitcherItem(
              //       name: 'По умолчанию',
              //       value: _AppIcon.byDefault,
              //       onPressed: () => {
              //         Provider.of<SettingsProvider>(context, listen: false)
              //             .setDefaultAppIcon(),
              //       },
              //     ),
              //   ],
              // ),
            ],
          );
        },
      );
}
