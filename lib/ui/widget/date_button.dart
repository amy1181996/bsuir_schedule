import 'dart:async';

import 'package:flutter/material.dart';

class DateButton extends StatefulWidget {
  final VoidCallback? onPressed;

  const DateButton({
    super.key,
    required this.onPressed,
  });

  @override
  State<DateButton> createState() => _DateButtonState();
}

class _DateButtonState extends State<DateButton> {
  final ValueNotifier<bool> _dateTimeChanged = ValueNotifier<bool>(false);
  DateTime _currentDateTime = DateTime.now();
  DateTime _prevDateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 15), (_) {
      _currentDateTime = DateTime.now();

      if (_prevDateTime != _currentDateTime) {
        _prevDateTime = _currentDateTime;
        _dateTimeChanged.value = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _dateTimeChanged,
      builder: (context, now, child) => GestureDetector(
        onTap: widget.onPressed,
        child: Stack(
          alignment: Alignment.center,
          children: [
            const ImageIcon(
              AssetImage("assets/icons/calendar.png"),
              color: Colors.blue,
            ),
            Text(
              '${_currentDateTime.day}',
              style: const TextStyle(color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
