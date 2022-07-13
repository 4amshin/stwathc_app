import 'dart:async';
import 'package:flutter/material.dart';
import 'package:stopwathc/constant/color.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int seconds = 0, minutes = 0, hours = 0;
  String dgSeconds = '00', dgMinutes = '00', dgHours = '00';
  Timer? timer;
  bool isStarted = false;
  List laps = [];

  void stop() {
    timer!.cancel();
    setState(() {
      isStarted = false;
    });
  }

  void reset() {
    timer!.cancel();
    setState(() {
      seconds = 0;
      minutes = 0;
      hours = 0;

      dgSeconds = '00';
      dgMinutes = '00';
      dgHours = '00';

      isStarted = false;
    });
  }

  void addLaps() {
    String lap = '$dgHours:$dgMinutes:$dgSeconds';
    setState(() {
      laps.add(lap);
    });
  }

  void start() {
    isStarted = true;
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        int localSeconds = seconds + 1;
        int localMinutes = minutes;
        int localHours = hours;

        if (localSeconds > 59) {
          if (localMinutes > 59) {
            localHours++;
            localMinutes = 0;
          } else {
            localMinutes++;
            localSeconds = 0;
          }
        }
        setState(() {
          seconds = localSeconds;
          minutes = localMinutes;
          hours = localHours;
          dgSeconds = (seconds >= 10) ? '$seconds' : '0$seconds';
          dgMinutes = (minutes >= 10) ? '$minutes' : '0$minutes';
          dgHours = (hours >= 10) ? '$hours' : '0$hours';
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: densBlue,
      appBar: _appBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '$dgHours:$dgMinutes:$dgSeconds',
                style: const TextStyle(
                  fontSize: 60,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 400,
                decoration: BoxDecoration(
                  color: minerBlue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView.builder(
                  itemCount: laps.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Lap n-${index + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '${laps[index]}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _outlineButton(
                      onPressed: () {
                        (!isStarted) ? start() : stop();
                      },
                      text: (!isStarted) ? 'Start' : 'Pause',
                      bgColor: densBlue,
                      txColor: neonBlue,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      addLaps();
                    },
                    icon: const Icon(Icons.flag),
                    color: Colors.white,
                  ),
                  Expanded(
                    child: _outlineButton(
                      onPressed: () {
                        reset();
                      },
                      text: 'Reset',
                      bgColor: neonBlue,
                      txColor: densBlue,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _appBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 1,
      title: const Text('Stopwatch'),
      centerTitle: true,
    );
  }

  _outlineButton({
    required String text,
    required Color bgColor,
    required Color txColor,
    required Function()? onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: bgColor,
        side: BorderSide(
          width: 2,
          color: neonBlue,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 15, color: txColor),
      ),
    );
  }
}
