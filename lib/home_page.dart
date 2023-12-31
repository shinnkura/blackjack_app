import 'package:blackjack_app/components/card_back.dart';
import 'package:flutter/material.dart';

import 'utils/get_random_card_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  AnimationStatus _animationStatus = AnimationStatus.dismissed;

  List<CardData> hand = [];
  List<CardData> dealerHand = [];
  List<CardData> allCards = []; // Add this line

  int handTotal = 0;
  int dealerHandTotal = 0;

  bool isDealerTurn = false; // Add this line

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _animation = Tween(begin: 0.0, end: 1.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener(
        (status) {
          _animationStatus = status;
        },
      );

    allCards = generateAllCards();
    var card1 = getRandomCardData(allCards);
    var card2 = getRandomCardData(allCards);
    handTotal += card1.value + card2.value;
    hand.add(card1);
    hand.add(card2);

    var dealerCard1 = getRandomCardData(allCards);
    var dealerCard2 = getRandomCardData(allCards);
    dealerHandTotal += dealerCard1.value + dealerCard2.value;
    dealerHand.add(dealerCard1);
    dealerHand.add(dealerCard2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[900],
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            onPressed: () async {
              // var newCard = getRandomCardData();
              var newCard = getRandomCardData(allCards);
              handTotal += newCard.value;
              setState(() {
                hand.add(newCard);
              });
              if (handTotal > 21) {
                setState(() {
                  isDealerTurn = true;
                });
                await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('ゲームオーバー！'),
                      content: Text(
                          'バーストしました! あなたのスコアは $handTotal, ディーラーのスコアは $dealerHandTotal でした。'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('リプレイ'),
                          onPressed: () {
                            Navigator.of(context).pop();
                            resetGame();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            },
            child: Center(
              child: Text(
                'Hit',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                isDealerTurn = true;
              });
              dealerTurn();
              if (handTotal > 21) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('ゲームオーバー！'),
                      content: Text(
                          'バーストしました! あなたのスコアは $handTotal, ディーラーのスコアは $dealerHandTotal でした。'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('リプレイ'),
                          onPressed: () {
                            Navigator.of(context).pop();
                            resetGame();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            },
            backgroundColor: Colors.red,
            child: Center(
              child: Text(
                'Stay',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
              child: SizedBox(
                height: 170,
                child: Align(
                  alignment: Alignment.center,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: dealerHand.length,
                    itemBuilder: (context, index) {
                      if (index == 0 && !isDealerTurn) {
                        return CardBack();
                      } else {
                        return dealerHand[index].cardWidget;
                      }
                    },
                  ),
                ),
              ),
            ),
            Transform.rotate(
              angle: 3.14 / 2,
              child: CardBack(),
            ),
            Center(
              child: SizedBox(
                height: 170,
                child: Align(
                  alignment: Alignment.center,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: hand.length,
                    itemBuilder: (context, index) {
                      return hand[index].cardWidget;
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void dealerTurn() {
    while (dealerHandTotal < 17) {
      // var newCard = getRandomCardData();
      var newCard = getRandomCardData(allCards);
      dealerHandTotal += newCard.value;
      dealerHand.add(newCard);
    }

    if (dealerHandTotal > 21) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('おめでとう!'),
            content: Text(
                'ディーラーがバーストしました！ あなたのスコアは $handTotal, ディーラーのスコアは $dealerHandTotal でした。'),
            actions: <Widget>[
              TextButton(
                child: Text('リプレイ'),
                onPressed: () {
                  Navigator.of(context).pop();
                  resetGame();
                },
              ),
            ],
          );
        },
      );
    } else if (handTotal > dealerHandTotal) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('おめでとう!'),
            content: Text(
                'あなたの勝ちです！ あなたのスコアは $handTotal, ディーラーのスコアは $dealerHandTotal でした。'),
            actions: <Widget>[
              TextButton(
                child: Text('リプレイ'),
                onPressed: () {
                  Navigator.of(context).pop();
                  resetGame();
                },
              ),
            ],
          );
        },
      );
    } else if (dealerHandTotal > handTotal) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('ゲームオーバー！'),
            content: Text(
                'ディーラーの勝ちです！ あなたのスコアは $handTotal, ディーラーのスコアは $dealerHandTotal でした。'),
            actions: <Widget>[
              TextButton(
                child: Text('リプレイ'),
                onPressed: () {
                  Navigator.of(context).pop();
                  resetGame();
                },
              ),
            ],
          );
        },
      );
    }

    setState(() {
      // This will trigger a rebuild and show the dealer's cards
    });
  }

  void resetGame() {
    setState(() {
      hand = [];
      dealerHand = [];
      handTotal = 0;
      dealerHandTotal = 0;
      isDealerTurn = false;

      allCards = generateAllCards(); // Add this line
      var card1 = getRandomCardData(allCards);
      var card2 = getRandomCardData(allCards);
      handTotal += card1.value + card2.value;
      hand.add(card1);
      hand.add(card2);

      var dealerCard1 = getRandomCardData(allCards);
      var dealerCard2 = getRandomCardData(allCards);
      dealerHandTotal += dealerCard1.value + dealerCard2.value;
      dealerHand.add(dealerCard1);
      dealerHand.add(dealerCard2);
    });
  }
}
