import 'package:flutter/material.dart';

class AlarmInfo {
  TimeOfDay _dayTime;
  bool _toggled;

  AlarmInfo(this._dayTime,this._toggled);

  void setBool(bool? booleanValue) {
    if (booleanValue == null) return;

    _toggled = booleanValue;
  }

  bool getBool() => _toggled;
  String getStringFormat() => _getStringFormat(_dayTime);

}

class PillEntry {
  TimeOfDay _pillTime = TimeOfDay.now();

  void setTime(TimeOfDay timeOfDay) {
    _pillTime = timeOfDay;
  }
  String getStringFormat() => _getStringFormat(_pillTime);
}

class IconGetter {
  final List<IconData> _iconList = [
    Icons.medication_liquid,
    Icons.healing,
    Icons.water_drop_rounded,
    Icons.favorite,
    Icons.tag_faces_sharp,
    Icons.sunny,
  ];

  Icon getIconFromId(int id) {
    final IconData iconData = _iconList.elementAtOrNull(id) ?? _iconList.first;

    return Icon(iconData);
  }

  List<Icon> getIconList() {
    return _iconList.map(
      (iconData) => Icon(iconData)
    ).toList();
  }
  
}

String _getStringFormat(TimeOfDay dayTime) {
    String hour = dayTime.hourOfPeriod.toString();
    String minute = dayTime.minute.toString().padLeft(2, '0');
    String period = dayTime.period == DayPeriod.am ? "A.M." : "P.M.";

    return '$hour:$minute $period';
  }