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
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController);

    _animationController.forward();

    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainPage()),
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.alarm,
                size: 100,
                color: Color(0xFFD78B15), // Matching your button color
              ),
              const SizedBox(height: 20),
              const Text(
                'AlarmIt',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Your Alarm Companion',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFFD78B15),
                ),
              ),
            ],
          ),
        ),
      ),
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
  void initState() {
    super.initState();
    updatetime();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) => updatetime());
  }

  void endalarm() {
    timer?.cancel();
    super.dispose();
  }

  void setalarm() async {
    TimeOfDay? pickedtime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedtime != null) {
      setState(() {
        alarmtime = pickedtime;
      });
    }
  }

  void showalarm() {
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
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
                height: 2.0,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              onPressed: setalarm,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E1E1E),
              ),
              child: const Text(
                'Set Alarm',
                style: TextStyle(fontSize: 20, color: Color(0xFFD78B15)),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}