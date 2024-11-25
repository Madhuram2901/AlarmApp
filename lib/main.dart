import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Alarm Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  String currenttime = '';
  TimeOfDay? alarmtime;
  Timer? timer;

  void updatetime() {
    DateTime now = DateTime.now();
    setState(() {
      currenttime = '${now.hour}:${now.minute}:${now.second}';
    });
    if (alarmtime != null) {
      if (now.hour == alarmtime!.hour && now.minute == alarmtime!.minute) {
        showalarm();
      }
    }
  }

  @override
  void initState(){
    super.initState();
    updatetime();
    timer = Timer.periodic(const Duration(seconds: 1),(timer) => updatetime());
  }

  void endalarm(){
    timer?.cancel();
    super.dispose();
  }

  void setalarm() async {
    TimeOfDay? pickedtime = await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (pickedtime != null){
        setState(() {
          alarmtime = pickedtime;
        });
    }
  }

  void showalarm(){
    showDialog(context: context, builder: (context) => const AlertDialog(
      title: Text('Alarm Ringing!!!'),
    ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'AlarmIt',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Current Time: ',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),

            Text(
                currenttime,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                height: 2.0, // Increase height
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            ElevatedButton(
              onPressed: setalarm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1E1E1E),
              ),
              child: Text('Set Alarm', style: TextStyle(fontSize: 20, color: Color(0xFFD78B15)), textAlign: TextAlign.center,),
            ),
          ],

        ),
      ),

    );
  }
}