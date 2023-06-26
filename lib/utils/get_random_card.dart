import 'dart:math';

import 'package:flutter/material.dart';

import '../components/card_template.dart';
import 'suits.dart';

Widget getRandomCard() {
  // カードの数値とスートのリストを定義します。
  List<String> numbers = [
    'A',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    'J',
    'Q',
    'K'
  ];
  List<Widget Function()> suits = [heart, diamond, club, spade];

  // ランダムな数値とスートを選択します。
  var random = Random();
  String randomNum = numbers[random.nextInt(numbers.length)];
  var randomSuit = suits[random.nextInt(suits.length)];

  // ランダムなカードを返します。
  return CardTemplate(
    color: (randomSuit == heart || randomSuit == diamond)
        ? Colors.red
        : Colors.black,
    number: randomNum,
    suit: randomSuit(),
  );
}
