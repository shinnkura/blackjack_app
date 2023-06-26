import 'package:blackjack_app/components/card.dart';
import 'package:blackjack_app/components/card_template.dart';
import 'package:blackjack_app/utils/suits.dart';
import 'package:flutter/material.dart';

import 'utils/get_random_card.dart';

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

  List<Widget> hand = [];

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

    hand.add(getRandomCard());
    hand.add(getRandomCard());
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
              // デッキボタンが押されたときに新しいカードを手札に追加します。
              var newCard = getRandomCard();
              setState(() {
                hand.add(newCard);
              });
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
              // ボタンが押されたときの処理をここに書きます。
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
                      return hand[index];
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
