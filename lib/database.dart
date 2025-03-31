import 'dart:async';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:miliflux/data_structures.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();

  final String _alarmTableName = 'alarms';
  final String _alarmIdColumn = 'id';
  final String _alarmNameColumn = 'name';
  final String _alarmHourColumn = 'hour';
  final String _alarmMinuteColumn = 'minute';

  final String _calendarTableName = 'calendar';
  final String _calendarIdColumn = 'id';
  final String _calendarDayColumn = 'entry_day';
  final String _calendarTakenColumn = 'is_taken';
  final String _calendarAlarmIdColumn = 'alarm_id';

  DatabaseService._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, 'miliflux.db');

    final database = openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
        CREATE TABLE $_alarmTableName (
          $_alarmIdColumn INTEGER PRIMARY KEY AUTOINCREMENT,
          $_alarmNameColumn TEXT NULL,
          $_alarmHourColumn INTEGER NOT NULL CHECK ($_alarmHourColumn BETWEEN 0 AND 23),
          $_alarmMinuteColumn INTEGER NOT NULL CHECK ($_alarmMinuteColumn BETWEEN 0 AND 59)
        )
        ''');
        db.execute('''
        CREATE TABLE $_calendarTableName (
          $_calendarIdColumn INTEGER PRIMARY KEY AUTOINCREMENT,
          $_calendarDayColumn DATE NOT NULL,
          $_calendarTakenColumn INTEGER NOT NULL DEFAULT 0,
          $_calendarAlarmIdColumn INTEGER NOT NULL,
          FOREIGN KEY ($_calendarAlarmIdColumn) REFERENCES $_alarmTableName ($_alarmIdColumn)
        )
        ''');
      },
    );

    return database;
  }

  void insertAlarm(Int id, String name, Int hour, Int minute) async {
    final db = await getDatabase();

    final values = {
      _alarmNameColumn: name,
      _alarmHourColumn: hour,
      _alarmMinuteColumn: minute,
    };

    await db.insert(
      _alarmTableName,
      values,
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  void removeAlarm(Int id) async {
    final db = await getDatabase();

    await db.delete(
      _alarmTableName,
      where: '$_alarmIdColumn = ?',
      whereArgs: [id],
    );
  }
}