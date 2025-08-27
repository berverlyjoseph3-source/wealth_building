import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trachtenberg_math/helpers/trachtenberg_rules.dart';
import 'package:trachtenberg_math/models/progress_model.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';

class RuleScreen extends StatefulWidget {
  final int rule;

  const RuleScreen({super.key, required this.rule});

  @override
  State<RuleScreen> createState() => _RuleScreenState();
}

class _RuleScreenState extends State<RuleScreen> {
  late ConfettiController _confettiController;
  int _currentStep = 0; // 0 = theory, 1 = practice, 2 = quiz
  int _score = 0;
  int _currentProblemIndex = 0;
  int _userAnswer = 0;
  int _remainingTime = 60;
  late Timer _timer;
  List<Map<String, dynamic>> _problems = [];

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _generateProblems();
    _startTimer();
  }

  void _generateProblems() {
    final random = Random();
    _problems = List.generate(10, (index) {
      final numDigits = widget.rule < 6 ? 3 : 4; // Simpler problems for lower rules
      final number = random.nextInt(pow(10, numDigits).toInt();
      final correctAnswer = number * widget.rule;
      
      return {
        'number': number,
        'correctAnswer': correctAnswer,
        'userAnswer': null,
        'answeredCorrectly': false,
      };
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() => _remainingTime--);
      } else {
        _timer.cancel();
        _completeQuiz();
      }
    });
  }

  void _checkAnswer() async {
  if (isCorrect) {
    await SoundService.playSuccess();
    // ... rest of code ...
  } else {
    await SoundService.playFailure();
  }
}

void _completeQuiz() async {
  await SoundService.playCelebration();
  // ... rest of code ...
}
  
  
  {
    final isCorrect = _userAnswer == _problems[_currentProblemIndex]['correctAnswer'];
    setState(() {
      _problems[_currentProblemIndex]['userAnswer'] = _userAnswer;
      _problems[_currentProblemIndex]['answeredCorrectly'] = isCorrect;
      
      if (isCorrect) {
        _score += 10;
      }
      
      _userAnswer = 0;
    });

    if (isCorrect && _currentProblemIndex < _problems.length - 1) {
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() => _currentProblemIndex++);
      });
    } else if (_currentProblemIndex >= _problems.length - 1) {
      _completeQuiz();
    }
  }

  void _completeQuiz() {
    _timer.cancel();
    _confettiController.play();
    
    final progress = Provider.of<ProgressTracker>(context, listen: false);
    progress.updateRuleProgress('rule_${widget.rule}', _score);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => QuizCompleteDialog(score: _score, confettiController: _confettiController),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildContent(),
          ConfettiWidget(
            confettiController: _confettiController,
            shouldLoop: false,
            blastDirectionality: BlastDirectionality.explosive,
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (_currentStep) {
      case 0:
        return _buildTheorySection();
      case 1:
        return _buildPracticeSection();
      case 2:
        return _buildQuizSection();
      default:
        return _buildTheorySection();
    }
  }

  Widget _buildTheorySection() {
    final ruleData = TrachtenbergRules.getRuleData(widget.rule);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Multiplying by ${widget.rule}',
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            ruleData['description'],
            style: const TextStyle(fontSize: 18, height: 1.5),
          ),
          const SizedBox(height: 30),
          _buildExampleCard(ruleData['example']),
          const SizedBox(height: 40),
          Center(
            child: ElevatedButton(
              onPressed: () => setState(() => _currentStep = 1),
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16)),
              child: const Text('Start Practice', style: TextStyle(fontSize: 18)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildExampleCard(Map<String, dynamic> example) {
    return Card(
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Example:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...example['steps'].map<Widget>((step) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text('• $step', style: const TextStyle(fontSize: 16)),
            )).toList(),
            const SizedBox(height: 15),
            Text(
              'Result: ${example['number']} × ${widget.rule} = ${example['result']}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPracticeSection() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Practice Section Coming Soon', style: TextStyle(fontSize: 24)),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => setState(() => _currentStep = 2),
            child: const Text('Take the Quiz'),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () => setState(() => _currentStep = 0),
            child: const Text('Review Theory Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizSection() {
    if (_problems.isEmpty) return const Center(child: CircularProgressIndicator());

    final problem = _problems[_currentProblemIndex];
    
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          LinearProgressIndicator(
            value: (_currentProblemIndex + 1) / _problems.length,
            minHeight: 10,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Time: $_remainingTime sec',
                style: TextStyle(
                  fontSize: 18,
                  color: _remainingTime < 15 ? Colors.red : Colors.black,
                  fontWeight: FontWeight.bold
                ),
              ),
              Text(
                'Score: $_score',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 40),
          Text(
            '${problem['number']} × ${widget.rule} = ?',
            style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          NumberPad(
            currentValue: _userAnswer,
            onChanged: (value) => setState(() => _userAnswer = value),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: _userAnswer > 0 ? _checkAnswer : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 18),
            ),
            child: const Text('Submit Answer', style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }
}

class NumberPad extends StatelessWidget {
  final int currentValue;
  final Function(int) onChanged;

  const NumberPad({super.key, required this.currentValue, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          currentValue == 0 ? 'Enter answer' : currentValue.toString(),
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: List.generate(10, (index) {
            final number = index == 9 ? 0 : index + 1; // 0 at the end
            return NumberButton(
              number: number,
              onPressed: () => onChanged(currentValue * 10 + number),
            );
          }),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.backspace),
              onPressed: () => onChanged(currentValue ~/ 10),
            ),
            const SizedBox(width: 20),
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () => onChanged(0),
            ),
          ],
        )
      ],
    );
  }
}

class NumberButton extends StatelessWidget {
  final int number;
  final VoidCallback onPressed;

  const NumberButton({super.key, required this.number, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Text(
          number.toString(),
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class QuizCompleteDialog extends StatelessWidget {
  final int score;
  final ConfettiController confettiController;

  const QuizCompleteDialog({super.key, required this.score, required this.confettiController});

  @override
  Widget build(BuildContext context) {
    final badge = score >= 80 
      ? 'Math Master' 
      : score >= 60 
        ? 'Quick Learner' 
        : 'Keep Practicing';
    
    return AlertDialog(
      title: const Text('Quiz Completed!', textAlign: TextAlign.center),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Your Score: $score/100',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            badge,
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold
            ),
          ),
          const SizedBox(height: 20),
          if (score >= 70) ...[
            const Icon(Icons.emoji_events, size: 50, color: Colors.amber),
            const SizedBox(height: 10),
          ]
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            confettiController.stop();
            Navigator.pop(context);
            Navigator.pop(context); // Return to dashboard
          },
          child: const Text('Back to Dashboard'),
        ),
      ],
    );
  }
}