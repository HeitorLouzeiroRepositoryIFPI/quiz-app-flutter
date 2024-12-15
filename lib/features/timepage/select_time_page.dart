import 'package:flutter/material.dart';
import 'package:quizz_app_flutter/features/quiz/quiz_page.dart';

class SelectTimePage extends StatefulWidget {
  const SelectTimePage({super.key});

  @override
  State<SelectTimePage> createState() => _SelectTimePageState();
}

class _SelectTimePageState extends State<SelectTimePage> {
  // Opções de tempo em um mapa
  final List<Map<String, dynamic>> timeOptions = [
    {'label': '30s', 'value': 30},
    {'label': '60s', 'value': 60},
    {'label': '3m', 'value': 180},
    {'label': '5m', 'value': 300},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Selecione o Tempo"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Escolha o tempo para o questionário:",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            // Gerando opções dinamicamente
            Column(
              children: timeOptions.map((option) {
                return InkWell(
                  onTap: () {
                    // Navega para a próxima página com o tempo selecionado
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizPage(timer: option['value']),
                      ),
                    );
                  },
                  child: _buildTimerOption(option['label']),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // Método para construir a opção de tempo
  Widget _buildTimerOption(String label) {
    return Container(
      width: 150,
      height: 50,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorLight,
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
