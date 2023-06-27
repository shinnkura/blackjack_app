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

    var card1 = getRandomCardData();
    var card2 = getRandomCardData();
    handTotal += card1.value + card2.value;
    hand.add(card1);
    hand.add(card2);

    var dealerCard1 = getRandomCardData();
    var dealerCard2 = getRandomCardData();
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
              var newCard = getRandomCardData();
              handTotal += newCard.value;
              setState(() {
                hand.add(newCard);
              });
              if (handTotal > 21) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('ゲームオーバー！'),
                      content: Text('バストしました! あなたの合計は、$handTotalでした。'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('閉じる'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              } else {
                setState(() {
                  hand.add(newCard);
                });
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
                dealerTurn();
              });
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
      var newCard = getRandomCardData();
      dealerHandTotal += newCard.value;
      dealerHand.add(newCard);
    }

    if (dealerHandTotal > 21) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('おめでとう!'),
            content: Text('ディーラーがバストしました。あなたの勝ちです!'),
            actions: <Widget>[
              TextButton(
                child: Text('閉じる'),
                onPressed: () {
                  Navigator.of(context).pop();
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
            content: Text('あなたの勝ちです！ あなたはディーラーよりも良い手札した。'),
            actions: <Widget>[
              TextButton(
                child: Text('閉じる'),
                onPressed: () {
                  Navigator.of(context).pop();
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

  // Widget getFlippingCard(var number, var suit, var color) {
  //   return Transform(
  //     alignment: FractionalOffset.center,
  //     transform: Matrix4.identity()
  //       ..setEntry(3, 2, 0.001)
  //       ..rotateY(3.14 * _animation.value),
  //     child: GestureDetector(
  //       onTap: () {
  //         if (_animationStatus == AnimationStatus.dismissed) {
  //           _animationController.forward();
  //         } else {
  //           _animationController.reverse();
  //         }
  //       },
  //       child: _animation.value <= 0.5
  //           ? CardBack()
  //           : CardTemplate(
  //               color: color,
  //               number: number,
  //               suit: suit,
  //             ),
  //     ),
  //   );
  // }
}
