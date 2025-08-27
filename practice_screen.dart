import 'package:flutter/material.dart';
import 'package:trachtenberg_math/helpers/trachtenberg_rules.dart';

class PracticeScreen extends StatefulWidget {
  final int rule;
  final int number;

  const PracticeScreen({super.key, required this.rule, required this.number});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  int _currentStep = 0;
  List<String> _solutionSteps = [];
  int _currentDigitIndex = 0;
  int? _userDigitInput;
  bool _showSolution = false;
  late int _result;

  @override
  void initState() {
    super.initState();
    _result = widget.number * widget.rule;
    _generateSolutionSteps();
  }

  void _generateSolutionSteps() {
    final ruleData = TrachtenbergRules.getRuleData(widget.rule);
    final example = ruleData['example'] as Map<String, dynamic>;
    final numberDigits = widget.number.toString().split('').reversed.toList();
    final resultDigits = _result.toString().split('');
    
    _solutionSteps = [];
    
    switch (widget.rule) {
      case 2:
        for (int i = 0; i < numberDigits.length; i++) {
          _solutionSteps.add("Double ${numberDigits[i]} = ${int.parse(numberDigits[i]) * 2}");
        }
        break;
      case 11:
        _solutionSteps.add("First digit: ${resultDigits[0]}");
        _solutionSteps.add("Add digits: ${numberDigits[1]} + ${numberDigits[0]} = ${int.parse(numberDigits[1]) + int.parse(numberDigits[0])}");
        _solutionSteps.add("Last digit: ${resultDigits[2]}");
        break;
      default:
        _solutionSteps.addAll(example['steps'] as List<String>);
    }
  }

  void _checkDigit() async {
  
  
  if (_userDigitInput == correctDigit) {
    await SoundService.playSuccess();
    // ... rest of code ...
  } else {
    await SoundService.playFailure();
    // ... show error ...
  }
}
    
    
    final resultDigits = _result.toString().split('');
    final correctDigit = int.parse(resultDigits[_currentDigitIndex]);
    
    if (_userDigitInput == correctDigit) {
      setState(() {
        _currentDigitIndex++;
        _userDigitInput = null;
        if (_currentDigitIndex >= resultDigits.length) {
          // Completed all digits
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Well Done!'),
              content: const Text('You solved it correctly!'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Continue'),
                ),
              ],
            ),
          );
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Try again!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final resultDigits = _result.toString().split('');
    
    return Scaffold(
      appBar: AppBar(title: Text('Practice: ${widget.number} × ${widget.rule}')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Solve: ${widget.number} × ${widget.rule}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            
            // Digit-by-digit input
            Wrap(
              spacing: 10,
              children: List.generate(resultDigits.length, (index) {
                return Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    color: index < _currentDigitIndex ? Colors.green[100] : null,
                  ),
                  child: Center(
                    child: index < _currentDigitIndex
                      ? Text(resultDigits[index], style: const TextStyle(fontSize: 24))
                      : index == _currentDigitIndex
                        ? _userDigitInput != null
                          ? Text('$_userDigitInput', style: const TextStyle(fontSize: 24))
                          : const Text('?', style: TextStyle(fontSize: 24))
                        : null,
                  ),
                );
              }),
            ),
            
            const SizedBox(height: 30),
            
            // Digit input pad
            NumberPad(
              currentValue: _userDigitInput ?? 0,
              onChanged: (value) => setState(() => _userDigitInput = value),
            ),
            
            const SizedBox(height: 20),
            
            ElevatedButton(
              onPressed: _userDigitInput != null ? _checkDigit : null,
              child: const Text('Check Digit'),
            ),
            
            const SizedBox(height: 40),
            
            // Solution steps
            ExpansionTile(
              title: const Text('Show Solution Steps'),
              onExpansionChanged: (expanded) => setState(() => _showSolution = expanded),
              children: [
                ..._solutionSteps.map((step) => ListTile(
                  leading: const Icon(Icons.arrow_right),
                  title: Text(step),
                )).toList(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}