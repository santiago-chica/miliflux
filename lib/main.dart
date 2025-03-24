import 'package:flutter/material.dart';

void main() => runApp(const Miliflux());

class Miliflux extends StatelessWidget {
  const Miliflux({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.calendar_month_outlined),
              label: "Calendario",
              tooltip: "Mira las fechas por separado",
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.medication_liquid_outlined),
              label: "Pastillas",
              tooltip: "Configura las alarmas de las pastillas"
            ),
          ],
        ),
      ),
      theme: ThemeData.light(),
    );
  }
}
