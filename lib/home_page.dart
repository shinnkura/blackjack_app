import 'package:blackjack_app/components/card_back.dart';
import 'package:blackjack_app/components/card_template.dart';
import 'package:blackjack_app/utils/suits.dart';
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

  int handTotal = 0;

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

    var card1 =
        getRandomCardData(); // getRandomCard() を getRandomCardData() に変更してください。
    var card2 =
        getRandomCardData(); // getRandomCard() を getRandomCardData() に変更してください。
    handTotal += card1.value + card2.value;
    hand.add(card1);
    hand.add(card2);
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
              var newCard =
                  getRandomCardData(); // getRandomCard() を getRandomCardData() に変更してください。
              handTotal += newCard.value;
              if (handTotal > 21) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Game Over'),
                      content: Text('You busted! Your total was $handTotal'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Close'),
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
            onPressed: () {},
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                getFlippingCard("A", diamond(), Colors.red),
                CardTemplate(
                  color: Colors.black,
                  number: '10',
                  suit: club(),
                ),
              ],
            ),
            Transform.rotate(
              angle: 3.14 / 2,
              child: CardBack(),
            ),
            Center(
              child: SizedBox(
                height: 150,
                child: Align(
                  alignment: Alignment.center,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: hand.length,
                    itemBuilder: (context, index) {
                      return hand[index]
                          .cardWidget; // hand[index] を hand[index].cardWidget に変更してください。
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

  Widget getFlippingCard(var number, var suit, var color) {
    return Transform(
      alignment: FractionalOffset.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateY(3.14 * _animation.value),
      child: GestureDetector(
        onTap: () {
          if (_animationStatus == AnimationStatus.dismissed) {
            _animationController.forward();
          } else {
            _animationController.reverse();
          }
        },
        child: _animation.value <= 0.5
            ? CardBack()
            : CardTemplate(
                color: color,
                number: number,
                suit: suit,
              ),
      ),
    );
  }
}
