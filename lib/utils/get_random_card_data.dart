import 'dart:math';

import 'package:flutter/material.dart';

import '../components/card_template.dart';
import 'suits.dart';

class CardData {
  final Widget cardWidget;
  final int value;

  CardData({required this.cardWidget, required this.value});
}

CardData getRandomCardData(List<CardData> allCards) {
  var random = Random();
  int index = random.nextInt(allCards.length);
  CardData card = allCards[index];
  allCards.removeAt(index);
  return card;
}

List<CardData> generateAllCards() {
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

  List<CardData> allCards = [];

  for (var number in numbers) {
    for (var suit in suits) {
      int value;
      if (number == 'A') {
        value = 1; // or 11 depending on your game rules
      } else if (number == 'J' || number == 'Q' || number == 'K') {
        value = 10;
      } else {
        value = int.parse(number);
      }

      Widget cardWidget = CardTemplate(
        color: (suit == heart || suit == diamond) ? Colors.red : Colors.black,
        number: number,
        suit: suit(),
      );

      allCards.add(CardData(cardWidget: cardWidget, value: value));
    }
  }

  return allCards;
}
