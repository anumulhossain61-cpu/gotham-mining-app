import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const GothamMiningApp());
}

class GothamMiningApp extends StatelessWidget {
  const GothamMiningApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gotham Power Markets',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0A0C),
        primaryColor: const Color(0xFFE50914), // Premium accent color
      ),
      home: const MiningDashboard(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MiningDashboard extends StatefulWidget {
  const MiningDashboard({Key? key}) : super(key: key);

  @override
  State<MiningDashboard> createState() => _MiningDashboardState();
}

class _MiningDashboardState extends State<MiningDashboard> {
  // --- Core State Variables ---
  int userLevel = 1;
  double baseHashrate = 548.2; // Batmobile V3 Baseline
  double compoundingInjection = 11.0; // +11.0 TH/s per level
  
  // Countdown Timer State (66-Day Mining Cycle Simulation/Countdown)
  late Timer _countdownTimer;
  Duration _timeLeft = const Duration(days: 66);

  // Real-time System Log Streams
  final List<String> _systemLogs = [
    "> INITIALIZING GOTHAM POWER MARKETS...",
    "> CONNECTED TO WHITE-LABEL CLOUD POOLS...",
    "> BLOCK DATA VERIFIED SUCCESSFUL. SET YOUR HEART ABLAZE."
  ];
  final ScrollController _logScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Start the countdown ticker (ticks down every second)
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft.inSeconds > 0) {
        setState(() {
          _timeLeft = _timeLeft - const Duration(seconds: 1);
        });
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer.cancel();
    _logScrollController.dispose();
    super.dispose();
  }

  // --- Compounding Modifier Calculation ---
  double get currentTotalHashrate {
    // Every level up achieved *after* level 1 adds compounding speed
    return baseHashrate + ((userLevel - 1) * compoundingInjection);
  }

  void _handleLevelUp() {
    setState(() {
      userLevel++;
      // Push dynamic verified message to the footer log when user levels up
      _systemLogs.add("> SYSTEM LEVEL UP: COMPOUNDING +11.0 TH/s INJECTED SUCCESSFULLY.");
    });
    // Auto-scroll footer log to the bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_logScrollController.hasClients) {
        _logScrollController.animateTo(
          _logScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // Helper format for the 66-day countdown string
  String _formatDuration(Duration d) {
    int days = d.inDays;
    int hours = d.inHours.remainder(24);
    int minutes = d.inMinutes.remainder(60);
    int seconds = d.inSeconds.remainder(60);
    return "${days}d ${hours}h ${minutes}m ${seconds}s";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appTheme: AppBarTheme(backgroundColor: Colors.transparent, elevation: 0),
      appBar: AppBar(
        title: const Text('GOTHAM POWER PLATFORM', style: TextStyle(letterSpacing: 1.5, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Main Content Area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Machine Card (Batmobile V3 Visual Frame)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF16161A),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white10, width: 1),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "MACHINE STATUS: ACTIVE",
                          style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, letterSpacing: 1),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Batmobile V3",
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 20),
                        // Total Hashrate Display (Updates automatically on Level Up)
                        Text(
                          "${currentTotalHashrate.toStringAsFixed(1)} TH/s",
                          style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.amberAccent),
                        ),
                        const Text("CURRENT EFFECTIVE HASHRATE", style: TextStyle(color: Colors.white38, fontSize: 12)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  // Countdown Clock Component
                  const Text("MINING CYCLE TIME REMAINING", style: TextStyle(color: Colors.white60, letterSpacing: 1)),
                  const SizedBox(height: 5),
                  Text(
                    _formatDuration(_timeLeft),
                    style: const TextStyle(fontSize: 24, fontFamily: 'Courier', fontWeight: FontWeight.bold, color: Colors.white70),
                  ),
                  const SizedBox(height: 40),

                  // Interactive Level Up trigger to verify compounding logic works
                  ElevatedButton(
                    onPressed: _handleLevelUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE50914),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: Text("SIMULATE LEVEL UP (LVL $userLevel -> ${userLevel + 1})"),
                  ),
                ],
              ),
            ),
          ),

          // Real-time Scrolling Footer Log Framework
          Container(
            height: 120,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.black,
              border: Border(top: BorderSide(color: Colors.white10, width: 1)),
            ),
            padding: const EdgeInsets.all(12),
            child: ListView.builder(
              controller: _logScrollController,
              itemCount: _systemLogs.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Text(
                    _systemLogs[index],
                    style: const TextStyle(
                      color: Color(0xFF00FF66), // Cyber-green log text
                      fontFamily: 'Courier',
                      fontSize: 12,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
