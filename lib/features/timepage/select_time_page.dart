import 'package:flutter/material.dart';
import 'package:quizz_app_flutter/features/quiz/quiz_page.dart';

class SelectTimePage extends StatefulWidget {
  const SelectTimePage({super.key});

  @override
  State<SelectTimePage> createState() => _SelectTimePageState();
}

class _SelectTimePageState extends State<SelectTimePage> {
  int _selectedTime = 30; // Tempo inicial selecionado

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
            GestureDetector(
              onTap: () => setState(() => _selectedTime = 30),
              child: _buildTimerOption("30s", _selectedTime == 30),
            ),
            GestureDetector(
              onTap: () => setState(() => _selectedTime = 60),
              child: _buildTimerOption("60s", _selectedTime == 60),
            ),
            GestureDetector(
              onTap: () => setState(() => _selectedTime = 180),
              child: _buildTimerOption("3m", _selectedTime == 180),
            ),
            GestureDetector(
              onTap: () => setState(() => _selectedTime = 300),
              child: _buildTimerOption("5m", _selectedTime == 300),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizPage(timer: _selectedTime),
                  ),
                );
              },
              child: const Text("Continuar"),
            ),
          ],
        ),
      ),
    );
  }

  // Método para construir a opção de tempo
  Widget _buildTimerOption(String label, bool isSelected) {
    return Container(
      width: 150,
      height: 50,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isSelected ? Colors.lightBlue.shade300 : Colors.lightBlue.shade100,
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(label, style: const TextStyle(fontSize: 20)),
      ),
    );
  }
}
