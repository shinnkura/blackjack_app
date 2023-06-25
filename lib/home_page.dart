import 'package:blackjack_app/components/card.dart';
import 'package:blackjack_app/components/card_template.dart';
import 'package:blackjack_app/utils/suits.dart';
import 'package:flutter/material.dart';

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
      ..addStatusListener((status) {
        _animationStatus = status;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[900],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CardTemplate(
                  color: Colors.red,
                  number: 'J',
                  suit: heart(),
                ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CardTemplate(
                  color: Colors.red,
                  number: '3',
                  suit: diamond(),
                ),
                CardTemplate(
                  color: Colors.black,
                  number: 'K',
                  suit: spade(),
                ),
                getFlippingCard("A", diamond(), Colors.red),
              ],
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
            ? CardTemplate(
                color: color,
                number: number,
                suit: suit,
              )
            : CardBack(),
        // : CardTemplate(
        //     color: color,
        //     number: number,
        //     suit: suit,
        //   ),
      ),
    );
  }
}
