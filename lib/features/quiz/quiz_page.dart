import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:quizz_app_flutter/features/result/result_page.dart';

class QuizPage extends StatefulWidget {
  final int timer;
  const QuizPage({super.key, required this.timer});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late int _timer;
  int _currentFlag = 0;
  int _correctCount = 0;
  int _wrongCount = 0;
  List _flags = [];
  List _options = [];
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

    if (jsonMap is Map && jsonMap.containsKey('paises')) {
      final paises = List<Map<String, dynamic>>.from(jsonMap['paises']);
      paises.shuffle(); // Embaralha as bandeiras para exibição randômica
      setState(() {
        _flags = paises;
        _generateOptions();
      });
    } else {
      throw Exception('Erro ao carregar o JSON.');
    }
  }

  void _generateOptions() {
    if (_flags.isNotEmpty) {
      final currentFlag = _flags[_currentFlag];
      final incorrectOptions = List<Map<String, dynamic>>.from(_flags)
        ..remove(currentFlag)
        ..shuffle();

      setState(() {
        _options = [
          currentFlag,
          ...incorrectOptions.take(3),
        ]..shuffle(); // Embaralha as opções
      });
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
      _navigateToResults();
    }
  }

  void _navigateToResults() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultPage(
          correctCount: _correctCount,
          wrongCount: _wrongCount,
        ),
      ),
    );
  }

  void _nextFlag() {
    setState(() {
      _currentFlag = (_currentFlag + 1) % _flags.length;
      _generateOptions();
    });
  }

  void _checkAnswer(Map<String, dynamic> selectedOption) {
    final correctAnswer = _flags[_currentFlag];
    if (selectedOption['nome'] == correctAnswer['nome']) {
      setState(() {
        _correctCount++;
      });
    } else {
      setState(() {
        _wrongCount++;
      });
    }
    _nextFlag();
  }

  @override
  Widget build(BuildContext context) {
    double totalAnswered = (_correctCount + _wrongCount).toDouble();
    double correctPercentage = totalAnswered > 0 ? _correctCount / totalAnswered : 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Flags Play"),
      ),
      backgroundColor: Colors.blueGrey[50], // Define a cor de fundo aqui
      body: _flags.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Desempenho:",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Barra de progresso para acertos e erros
                      Expanded(
                        child: LinearProgressIndicator(
                          value: correctPercentage,
                          minHeight: 15, // Diminuir a altura da barra de progresso
                          color: Colors.green,
                          backgroundColor: Colors.red.withAlpha((255 * 0.5).toInt()),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Ícones de acertos e erros
                      Column(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.check_circle, color: Colors.green),
                              Text(" $_correctCount", style: const TextStyle(fontSize: 16)),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.cancel, color: Colors.red),
                              Text(" $_wrongCount", style: const TextStyle(fontSize: 16)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text("Bandeira:", style: TextStyle(fontSize: 24)),
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      Image.asset(
                        _flags[_currentFlag]['bandeira'],
                        width: 120, // Reduzir a largura da imagem
                        height: 120, // Reduzir a altura da imagem
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Text(
                            "Tempo: $_timer s",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Botões de resposta
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: _options.map((option) {
                        final colorOptions = [Colors.blue, Colors.orange, Colors.green, Colors.purple];
                        final buttonColor = colorOptions[_options.indexOf(option) % colorOptions.length];

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Container(
                            alignment: Alignment.center, // Alinha os botões ao centro
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                fixedSize: const Size(300, 45), // Tamanho ajustado para 300
                                backgroundColor: buttonColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: () => _checkAnswer(option),
                              child: Text(
                                option['nome'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
