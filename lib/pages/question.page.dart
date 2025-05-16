import 'package:flutter/material.dart';
import 'package:wwbm/services/quiz_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key});

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  List questions = [];
  int currentIndex = 0;
  bool lifelineUsed = false;
  bool viewUsed = false;
  bool jokeUsed = false;
  bool gameOver = false;
  String prizeMessage = '';

  bool questionAnswered = false;

  List<String> prizeLevels = [];

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    try {
      final response = await http.get(Uri.parse(QuizService.finalQuizUrl));
      final data = json.decode(response.body);
      setState(() {
        questions = data['results'];
        prizeLevels = List.generate(
          questions.length,
              (index) {
            const fullLevels = [
              '\$1 000 000', '\$500 000', '\$250 000', '\$125 000',
              '\$64 000', '\$32 000', '\$16 000', '\$8 000',
              '\$4 000', '\$2 000', '\$1 000', '\$500',
              '\$300', '\$200', '\$100'
            ];
            return fullLevels[fullLevels.length - questions.length + index];
          },
        );
      });
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void useLifeline(String type) {
    setState(() {
      if (type == 'lifeline') lifelineUsed = true;
      if (type == 'view') viewUsed = true;
      if (type == 'joke') jokeUsed = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$type used!')),
    );
  }

  void checkAnswer(String selectedAnswer) {
    if (questionAnswered || gameOver) return;

    final correctAnswer = questions[currentIndex]['correct_answer'];

    setState(() {
      questionAnswered = true;

      if (selectedAnswer == correctAnswer) {
        if (currentIndex < questions.length - 1) {
          currentIndex++;
          questionAnswered = false;
        } else {
          prizeMessage = 'Congratulations! You won \$1 000 000!';
        }
      } else {
        gameOver = true;
        prizeMessage = 'Game Over! You won ${prizeLevels[prizeLevels.length - 1 - currentIndex]}';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final levelsCount = prizeLevels.length;

    return Scaffold(
      backgroundColor: Colors.blue[900],
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: const Text('Who Wants to Be a Millionaire'),
        centerTitle: true,
      ),
      body: questions.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.only(top: 20.0), // add some top padding under app bar
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,  // align to top
          children: [
            // Question + Answers on left
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue[800],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        questions[currentIndex]['question'],
                        style: const TextStyle(fontSize: 22, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ..._buildAnswers(),
                    if (gameOver || prizeMessage.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Text(
                        prizeMessage,
                        style: const TextStyle(color: Colors.white, fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            // Prize ladder on right
            Container(
              width: 130,
              height: 500,
              color: Colors.blue[900],
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                reverse: true,
                itemCount: levelsCount,
                itemBuilder: (context, index) {
                  final prizeText = prizeLevels[index];
                  final isActive = levelsCount - 1 - index == currentIndex;
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: isActive ? Colors.amber[700] : Colors.blue[800],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: isActive ? Colors.black : Colors.transparent, width: 1.5),
                    ),
                    child: Text(
                      '${levelsCount - index}. $prizeText',
                      style: TextStyle(
                        color: isActive ? Colors.black : Colors.white,
                        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomAppBar(
        color: Colors.blue[900],
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.people),
                color: lifelineUsed ? Colors.grey : Colors.amber,
                onPressed: lifelineUsed ? null : () => useLifeline('lifeline'),
                tooltip: 'Friend Help',
              ),
              IconButton(
                icon: const Icon(Icons.phone),
                color: viewUsed ? Colors.grey : Colors.amber,
                onPressed: viewUsed ? null : () => useLifeline('view'),
                tooltip: 'Phone Call',
              ),
              IconButton(
                icon: const Icon(Icons.support_agent),
                color: jokeUsed ? Colors.grey : Colors.amber,
                onPressed: jokeUsed ? null : () => useLifeline('joke'),
                tooltip: 'Help from Others',
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildAnswers() {
    List allAnswers = [...questions[currentIndex]['incorrect_answers']];
    allAnswers.insert(
      (questions[currentIndex]['correct_answer'] as String).hashCode % (allAnswers.length + 1),
      questions[currentIndex]['correct_answer'],
    );

    return List.generate(
      allAnswers.length,
          (index) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.all(16),
          ),
          onPressed: gameOver ? null : () => checkAnswer(allAnswers[index]),
          child: Text(allAnswers[index]),
        ),
      ),
    );
  }
}
