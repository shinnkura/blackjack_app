import 'dart:math';

import 'package:flutter/material.dart';

import '../components/card_template.dart';
import 'suits.dart';

class CardData {
  final Widget cardWidget;
  final int value;

  CardData({required this.cardWidget, required this.value});
}

CardData getRandomCardData() {
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

  var random = Random();
  String randomNum = numbers[random.nextInt(numbers.length)];
  var randomSuit = suits[random.nextInt(suits.length)];

  int value;
  if (randomNum == 'A') {
    value = 1; // or 11 depending on your game rules
  } else if (randomNum == 'J' || randomNum == 'Q' || randomNum == 'K') {
    value = 10;
  } else {
    value = int.parse(randomNum);
  }

  Widget cardWidget = CardTemplate(
    color: (randomSuit == heart || randomSuit == diamond)
        ? Colors.red
        : Colors.black,
    number: randomNum,
    suit: randomSuit(),
  );

  return CardData(cardWidget: cardWidget, value: value);
}
