final cardValues = {
  'A': 1,
  '2': 2,
  '3': 3,
  '4': 4,
  '5': 5,
  '6': 6,
  '7': 7,
  '8': 8,
  '9': 9,
  '10': 10,
  'J': 10,
  'Q': 10,
  'K': 10,
};

class Card {
  final String number;

  Card({required this.number});
}

int calculateHandValue(List<Card> hand) {
  int sum = 0;
  bool hasAce = false;

  for (var card in hand) {
    sum += cardValues[card.number]!; // Use the non-null assertion operator (!)
    if (card.number == 'A') {
      hasAce = true;
    }
  }

  if (hasAce && sum <= 11) {
    // If the player has an ace and the total value of the hand is 11 or less,
    // treat the ace as 11.
    sum += 10;
  }

  return sum;
}
