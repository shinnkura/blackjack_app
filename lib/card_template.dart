import 'package:flutter/material.dart';

class CardTemplate extends StatelessWidget {
  // final suit;
  // final color;
  // final number;

  final Widget suit;
  final Color color;
  final String number;

  const CardTemplate({
    super.key,
    required this.suit,
    required this.color,
    required this.number,
  });
  // CardTemplate({
  //   this.suit = const Icon(Icons.favorite), // デフォルト値としてアイコンを設定
  //   this.color = Colors.black, // デフォルト値として黒色を設定
  //   this.number = '1', // デフォルト値として'0'を設定
  // });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: EdgeInsets.all(5),
          color: Colors.white,
          height: 150,
          width: 100,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      number,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
                suit,
                Transform.rotate(
                  angle: 3.14,
                  child: Row(
                    children: [
                      Text(
                        number,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
