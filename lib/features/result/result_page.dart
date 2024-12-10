import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final int correctCount;
  final int wrongCount;

  const ResultPage({
    super.key,
    required this.correctCount,
    required this.wrongCount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Resultados"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Quiz Finalizado!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              "Acertos: $correctCount",
              style: const TextStyle(fontSize: 20, color: Colors.green),
            ),
            const SizedBox(height: 10),
            Text(
              "Erros: $wrongCount",
              style: const TextStyle(fontSize: 20, color: Colors.red),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Voltar ao Início"),
            ),
          ],
        ),
      ),
    );
  }
}
