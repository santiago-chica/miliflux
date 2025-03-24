import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void main() => runApp(const Miliflux());

class Miliflux extends StatelessWidget {
  const Miliflux({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MilifluxHome(),
      theme: ThemeData.light(),
    );
  }
}


class MilifluxHome extends StatefulWidget {
  const MilifluxHome({super.key});

  @override
  State<MilifluxHome> createState() => _MilifluxHomeState();
}

class _MilifluxHomeState extends State<MilifluxHome> {
  int _currentIndex = 0;

  final List<Widget> screenList = [
    CalendarApp(),
    PillsApp(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.pets),
            SizedBox(
              width: 10.0,
            ),
            Text("Miliflux")
          ],
        ),
      ),
      body: screenList[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => setState(() => _currentIndex = index),
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            label: "Calendario",
            tooltip: "Mira las fechas por separado",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medication_liquid_outlined),
            label: "Pastillas",
            tooltip: "Configura las alarmas de las pastillas",
          ),
        ],
        selectedItemColor: Colors.purple.shade300,
        unselectedItemColor: Colors.grey,
        
      ),
    );
    
  }
}

class CalendarApp extends StatefulWidget {
  const CalendarApp({super.key});

  @override
  State<CalendarApp> createState() => _CalendarAppState();
}

class _CalendarAppState extends State<CalendarApp> {
  DateTime _selectedTime = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendario'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          TableCalendar(
            focusedDay: _selectedTime,
            currentDay: _selectedTime,
            onDaySelected: (selectedDay, focusedDay) => setState(() => _selectedTime = selectedDay),
            firstDay: DateTime(2024),
            lastDay: DateTime.now(),
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) => setState(() => _calendarFormat = format),
          ),
        ],
      ),
    );
  }
}

class PillEntry {
  TimeOfDay _pillTime = TimeOfDay.now();

  String getStringFormat() {
    String hour = _pillTime.hourOfPeriod.toString();
    String minute = _pillTime.minute.toString().padLeft(2, '0');
    String period = _pillTime.period == DayPeriod.am ? "A.M." : "P.M.";

    return '$hour:$minute $period';
  }

  void setTime(TimeOfDay timeOfDay) {
    _pillTime = timeOfDay;
  }

}

class PillsApp extends StatefulWidget {
  const PillsApp({super.key});

  @override
  State<PillsApp> createState() => _PillsAppState();
}

class _PillsAppState extends State<PillsApp> {
  final List<PillEntry> _pillList = [];

  Future<void> modifyEntry(PillEntry element) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dial,
      helpText: "Seleccione una hora",
      cancelText: "Cancelar",
      confirmText: "Confirmar",
      hourLabelText: "Hora",
      minuteLabelText: "Minuto",
      errorInvalidText: "Texto inválido",
    );

    if (selectedTime == null) return;

    setState(() => element.setTime(selectedTime));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pastillas'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          45,
          0,
          45,
          0,
        ),
        children: _pillList.map((e) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.medication_rounded),
              SizedBox(width: 10),
              Text(e.getStringFormat()),
              Spacer(),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => modifyEntry(e),
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => setState(() => _pillList.remove(e)),
              ),
            ],
          );
        },).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => _pillList.add(PillEntry())),
        child: Icon(Icons.add_alarm, size: 30),
        
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }
}