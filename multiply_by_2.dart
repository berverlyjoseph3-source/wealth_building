// lib/helpers/multiply_by_2.dart
List<int> multiplyBy2(List<int> number) {
  List<int> result = [];
  int carry = 0;
  
  for (int i = number.length - 1; i >= 0; i--) {
    int digit = number[i];
    int product = digit * 2 + carry;
    result.insert(0, product % 10);
    carry = product ~/ 10;
  }
  
  if (carry > 0) result.insert(0, carry);
  return result;
}

import 'dart:math';

List<int> multiplyBy2(List<int> digits) {
  List<int> result = [];
  int carry = 0;
  
  // Process from right to left
  for (int i = digits.length - 1; i >= 0; i--) {
    int digit = digits[i];
    int product = digit * 2 + carry;
    result.insert(0, product % 10);
    carry = product ~/ 10;
  }
  
  if (carry > 0) {
    result.insert(0, carry);
  }
  
  return result;
}