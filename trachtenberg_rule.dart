class TrachtenbergRules {
  static Map<String, dynamic> getRuleData(int rule) {
    return _rules[rule] ?? _rules[2]!;
  }

  static int? multiplyByRule(int number, int rule) {
    switch (rule) {
      case 2: return _multiplyBy2(number);
      case 3: return _multiplyBy3(number);
      case 4: return _multiplyBy4(number);
      case 5: return _multiplyBy5(number);
      case 6: return _multiplyBy6(number);
      case 7: return _multiplyBy7(number);
      case 8: return _multiplyBy8(number);
      case 9: return _multiplyBy9(number);
      case 10: return number * 10;
      case 11: return _multiplyBy11(number);
      case 12: return _multiplyBy12(number);
      default: return number * rule;
    }
  }

  // Rule-specific multiplication algorithms
  static int _multiplyBy2(int number) {
    return number * 2;
  }

  static int _multiplyBy3(int number) {
    // Simplified Trachtenberg method
    final digits = number.toString().split('').map(int.parse).toList();
    int result = 0;
    int carry = 0;
    
    for (int i = digits.length - 1; i >= 0; i--) {
      int temp = digits[i] * 3 + carry;
      carry = temp ~/ 10;
      result = result * 10 + (temp % 10);
    }
    
    if (carry > 0) result = carry * pow(10, digits.length).toInt() + result;
    return result;
  }

  static int _multiplyBy4(int number) {
    return number * 4;
  }

  static int _multiplyBy5(int number) {
    return number * 5;
  }

  static int _multiplyBy6(int number) {
    // Half neighbor method
    final digits = number.toString().split('').map(int.parse).toList();
    int result = 0;
    int carry = 0;
    
    for (int i = digits.length - 1; i >= 0; i--) {
      int neighbor = i < digits.length - 1 ? digits[i + 1] : 0;
      int temp = digits[i] * 6 + (neighbor ~/ 2) + carry;
      carry = temp ~/ 10;
      result = result * 10 + (temp % 10);
    }
    
    if (carry > 0) result = carry * pow(10, digits.length).toInt() + result;
    return result;
  }

  static int _multiplyBy7(int number) {
    return number * 7;
  }

  static int _multiplyBy8(int number) {
    return number * 8;
  }

  static int _multiplyBy9(int number) {
    return number * 9;
  }

  static int _multiplyBy11(int number) {
    // Only works for 2-digit numbers in this simplified version
    if (number < 10 || number > 99) return number * 11;
    
    final tens = number ~/ 10;
    final units = number % 10;
    final sum = tens + units;
    
    if (sum < 10) {
      return tens * 100 + sum * 10 + units;
    } else {
      return (tens + 1) * 100 + (sum - 10) * 10 + units;
    }
  }

  static int _multiplyBy12(int number) {
    return number * 12;
  }

  static final Map<int, Map<String, dynamic>> _rules = {
    2: {
      'description': 'To multiply any number by 2, double each digit from right to left. '
          'If doubling results in a two-digit number, carry over to the next digit.',
      'example': {
        'number': 1234,
        'result': 2468,
        'steps': [
          'Start from the right: 4 × 2 = 8',
          'Next digit: 3 × 2 = 6',
          'Next digit: 2 × 2 = 4',
          'Leftmost digit: 1 × 2 = 2',
          'Final answer: 2468'
        ]
      }
    },
    3: {
      'description': 'For multiplication by 3: Take each digit, multiply by 3, '
          'then add half of the neighbor (dropping fractions) plus carry if any.',
      'example': {
        'number': 456,
        'result': 1368,
        'steps': [
          'Start from right: 6 × 3 = 18 (write 8, carry 1)',
          'Next digit: (5 × 3) + (6 ÷ 2) + 1 = 15 + 3 + 1 = 19 (write 9, carry 1)',
          'Leftmost digit: (4 × 3) + (5 ÷ 2) + 1 = 12 + 2 + 1 = 15 (write 15)',
          'Final answer: 1368'
        ]
      }
    },
    4: {
      'description': 'To multiply by 4, double the number twice. Alternatively, '
          'use the rule: for each digit, take half of the neighbor (to the right) '
          'and add carry if any, then if the current digit is odd, add 5.',
      'example': {
        'number': 123,
        'result': 492,
        'steps': [
          'Start from right: 3 (no neighbor) -> 3×4=12 (write 2, carry 1)',
          'Next: 2×4=8 + carry 1 = 9',
          'Next: 1×4=4 -> 4 (write 4)',
          'Final answer: 492'
        ]
      }
    },
    5: {
      'description': 'To multiply by 5, take half of the neighbor (to the right), '
          'then add 5 if the current digit is odd. Ignore fractions when taking half.',
      'example': {
        'number': 42,
        'result': 210,
        'steps': [
          'Start from right: 2 (no neighbor) -> 0 (half of nothing) + 5? (2 is even) = 0',
          'Next: 4 -> half of neighbor (2) = 1, + 5? (4 even) = 1',
          'Add first digit: half of 4 = 2',
          'Final answer: 210'
        ]
      }
    },
    6: {
      'description': 'For ×6: Add to each digit half of the neighbor (to the right), '
          'plus 5 if the digit is odd. Add the number itself if there\'s a carry.',
      'example': {
        'number': 62,
        'result': 372,
        'steps': [
          'Start from right: 2 -> half of nothing = 0, 2 is even → 0',
          'Next: 6 -> half of neighbor (2) = 1, 6 is even → 1',
          'Add: 6 (original digit) = 6 + 1 = 7',
          'Final answer: 372? (Actual 372)'
        ]
      }
    },
    7: {
      'description': 'For ×7: Double the digit and add half the neighbor. '
          'Add 5 if the digit is odd. Subtract 10 if needed and carry accordingly.',
      'example': {
        'number': 13,
        'result': 91,
        'steps': [
          'Start from right: 3 → 3×2 = 6, half of nothing = 0, 3 is odd → +5 = 11 (write 1, carry 1)',
          'Next: 1 → 1×2 = 2, half of neighbor (3) = 1, 1 is odd → +5 = 8 + carry 1 = 9',
          'Final answer: 91'
        ]
      }
    },
    8: {
      'description': 'For ×8: Triple the digit and add the neighbor. '
          'Adjust for carry and odd/even rules.',
      'example': {
        'number': 52,
        'result': 416,
        'steps': [
          'Start from right: 2 → 2×3 = 6, no neighbor = 6 (write 6)',
          'Next: 5 → 5×3 = 15, neighbor (2) = 2 → 17 (write 7, carry 1)',
          'Add carry: 1 → 1 (write 1)',
          'Final answer: 416'
        ]
      }
    },
    9: {
      'description': 'For ×9: Subtract the digit from 10, then add the neighbor. '
          'Add 1 to the left digit if needed.',
      'example': {
        'number': 78,
        'result': 702,
        'steps': [
          'Start from right: 8 → 10 - 8 = 2, no neighbor = 2',
          'Next: 7 → 10 - 7 = 3, neighbor (8) = 8 → 11 (write 1, carry 1)',
          'Add carry: 7 - 1 = 6? (Better method: 7×9 = 63 + carry)',
          'Final answer: 702? (Actual 702)'
        ]
      }
    },
    10: {
      'description': 'To multiply by 10, simply add a zero to the end of the number.',
      'example': {
        'number': 42,
        'result': 420,
        'steps': [
          'Add a zero to the end: 42 → 420'
        ]
      }
    },
    11: {
      'description': 'For 11× any two-digit number: Add the digits and place '
          'the sum between them (carry over if needed).',
      'example': {
        'number': 35,
        'result': 385,
        'steps': [
          'Write first digit: 3',
          'Add digits: 3 + 5 = 8',
          'Write last digit: 5',
          'Final answer: 385'
        ]
      }
    },
    12: {
      'description': 'To multiply by 12, first multiply by 10 and then add double the number. '
          'Alternatively, use the rule: for each digit, double the digit and add the neighbor (to the right), '
          'then add carry if any.',
      'example': {
        'number': 34,
        'result': 408,
        'steps': [
          'Start from right: 4×12=48 (write 8, carry 4)',
          'Next: 3×12=36 + carry 4 = 40 (write 40)',
          'Final answer: 408'
        ]
      }
    },
  };
}