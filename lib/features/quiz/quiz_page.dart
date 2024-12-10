import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class QuizPage extends StatefulWidget {
  final int timer;
  const QuizPage({super.key, required this.timer});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late int _timer;
  int _currentFlag = 0;
  List _flags = [];
  bool _isTimerRunning = true;

  @override
  void initState() {
    super.initState();
    _timer = widget.timer;
    _loadFlags();
    _startTimer();
  }

  Future<void> _loadFlags() async {
    final jsonString = await rootBundle.loadString('utils/paises.json');
    final jsonMap = jsonDecode(jsonString);

    // Acesse a lista de bandeiras na chave "paises"
    if (jsonMap is Map && jsonMap.containsKey('paises')) {
      setState(() {
        _flags = jsonMap['paises'];
      });
    } else {
      throw Exception('Erro ao carregar o JSON.');
    }
  }

  void _startTimer() {
    if (_timer > 0 && _isTimerRunning) {
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _timer--;
        });
        _startTimer();
      });
    } else if (_timer == 0) {
      _isTimerRunning = false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tempo esgotado!')),
      );
    }
  }

  void _nextFlag() {
    setState(() {
      _currentFlag = (_currentFlag + 1) % _flags.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Questionário de Bandeiras"),
      ),
      body: _flags.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Bandeira:", style: TextStyle(fontSize: 24)),
                  const SizedBox(height: 20),
                  Image.asset(
                    _flags[_currentFlag]['bandeira'], // Mostra a bandeira
                    width: 150,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _flags[_currentFlag]['nome'], // Mostra o nome do país
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Tempo restante: $_timer s",
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _nextFlag,
                    child: const Text("Próxima"),
                  ),
                ],
              ),
            ),
    );
  }
}
