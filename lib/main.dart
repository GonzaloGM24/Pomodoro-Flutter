import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent, // para hacer la barra de estado transparente
    ));

    return MaterialApp(
      title: 'Temporizador y Cronómetro',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: MyHomePage(title: 'Temporizador y Cronómetro'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _workTime = 2100; // 35 minutos en segundos
  int _restTime = 300; // 5 minutos en segundos
  bool _isRunning = false;
  bool _isPaused = false;
  int _elapsedTime = 0;
  int _totalElapsedTime = 0;
  Timer? _timer;
  bool _isInWorkMode = true;
  int _completedCycles = 0;
  AudioCache _audioCache = AudioCache();

  void _startTimer() {
    _isRunning = true;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_isPaused) {
          _timer?.cancel();
        } else if (_elapsedTime < _workTime) {
          _elapsedTime++;
          _totalElapsedTime++;
        } else {
          _elapsedTime++;
          _totalElapsedTime++;
          if (_elapsedTime - _workTime == 1) {
            _audioCache.play('bell.mp3');
          }
          if (_elapsedTime - _workTime == _restTime) {
            _elapsedTime = 0;
            _isInWorkMode = false;
            _completedCycles++;
            _audioCache.play('bell.mp3');
          }
        }
      });
    });
  }

  void _pauseTimer() {
    _isPaused = true;
  }

  void _resumeTimer() {
    _isPaused = false;
    _startTimer();
  }

  String _formatTime1(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    String minutesStr = minutes < 10 ? '0$minutes' : minutes.toString();
    String secondsStr =
        remainingSeconds < 10 ? '0$remainingSeconds' : remainingSeconds.toString();
    return '$minutesStr:$secondsStr';
  }

  String _formatTime2(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;
    String hoursStr = hours < 10 ? '0$hours' : hours.toString();
    String minutesStr = minutes < 10 ? '0$minutes' : minutes.toString();
    String secondsStr = remainingSeconds < 10 ? '0$remainingSeconds' : remainingSeconds.toString();
    return '$hoursStr:$minutesStr:$secondsStr';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Temporizador:',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              _elapsedTime < _workTime
                  ? _formatTime1(_workTime - _elapsedTime)
                  : _formatTime1(_restTime - (_elapsedTime - _workTime) % _restTime),
              style: TextStyle(fontSize: 60),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _isRunning ? null : _startTimer,
                  child: Text('Iniciar'),
                ),
                ElevatedButton(
                  onPressed: !_isRunning ? null : _isPaused ? _resumeTimer : _pauseTimer,
                  child: Text(_isPaused ? 'Reanudar' : 'Pausar'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Cronómetro:',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              _formatTime2(_totalElapsedTime),
              style: TextStyle(fontSize: 60),
            ),
          ],
        ),
      ),
    );
  }
}
