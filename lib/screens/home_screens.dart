import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:assnake/widgets/high_score_tile.dart';
import 'package:assnake/widgets/snake_pixel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/black_pixel.dart';
import '../widgets/food_pixels.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

enum snakeDirections { UP, DOWN, LEFT, RIGHT }

class _HomePageState extends State<HomePage> {
// grid dimensions
  int rowSize = 10;
  int totalNumberOfSquares = 100;
  int currentScore = 0;
  bool gameHasStarted = false;
  final _nameController = TextEditingController();
// snake position
  List<int> snakePos = [
    0,
    1,
    2,
  ];

  // highscore list
  List<String> highscore_DocIds = [];
  late final Future? letsGetDocIds;
  @override
  void initState() {
    letsGetDocIds = getDocId();
    super.initState();
  }

  Future getDocId() async {
    return FirebaseFirestore.instance
        .collection("highscores")
        .orderBy("score", descending: true)
        .limit(20)
        .get()
        .then(
          (value) => value.docs.forEach(
            (element) {
              highscore_DocIds.add(element.reference.id);
            },
          ),
        );
  }

  // SNAKE DIRECTION IS INITIALLY TO THE RIGHT
  var currentDirection = snakeDirections.RIGHT;

// food position
  int foodPos = 55;

// start the game!
  void startGame() {
    gameHasStarted = true;
    Timer.periodic(
      const Duration(milliseconds: 200),
      (timer) {
        setState(() {
          // keep moving the snake
          moveSnake();

          // check if the game is over
          if (gameOver()) {
            timer.cancel();

            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return AlertDialog(
                    title: const Center(child: Text('Game over!🥺🥺')),
                    content: Column(
                      children: [
                        Text('Tour score is: $currentScore'),
                        TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                              hintText: 'Enter a Nickname'),
                        )
                      ],
                    ),
                    actions: [
                      MaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                          submitScore();
                          newGame();
                        },
                        color: Colors.pink,
                        child: const Text('Submit'),
                      )
                    ],
                  );
                });
          }
        });
      },
    );
  }

  void submitScore() {
    // get access to the collection
    var db = FirebaseFirestore.instance;
    // add data to firebase
    db.collection('highscores').add({
      "name": _nameController.text,
      "score": currentScore,
    });
  }

  Future newGame() async {
    highscore_DocIds = [];
    await getDocId();
    setState(() {
      snakePos = [
        0,
        1,
        2,
      ];
      _nameController.text = '';
      foodPos = 55;
      currentDirection = snakeDirections.RIGHT;
      gameHasStarted = false;
      currentScore = 0;
    });
  }

  void eatFood() {
    currentScore++;
    // making sure the new food is not where the snake is
    while (snakePos.contains(foodPos)) {
      foodPos = Random().nextInt(totalNumberOfSquares);
    }
  }

  void moveSnake() {
    switch (currentDirection) {
      case snakeDirections.RIGHT:
        {
          // if snake is at the right wall , need to readjust
          if (snakePos.last % rowSize == 9) {
            snakePos.add(snakePos.last + 1 - rowSize);
          } else {
            snakePos.add(snakePos.last + 1);
          }
        }
        break;
      case snakeDirections.LEFT:
        {
          // if snake is at the left wall , need to readjust
          if (snakePos.last % rowSize == 0) {
            snakePos.add(snakePos.last - 1 + rowSize);
          } else {
            // add a new head
            snakePos.add(snakePos.last - 1);
          }
        }
        break;
      case snakeDirections.UP:
        {
          // if snake is at the upper wall , need to readjust
          if (snakePos.last < rowSize) {
            snakePos.add(snakePos.last - rowSize + totalNumberOfSquares);
          } else {
            // add a new head
            snakePos.add(snakePos.last - rowSize);
          }
        }
        break;
      case snakeDirections.DOWN:
        {
          // if snake is at the right wall , need to readjust
          if (snakePos.last + rowSize > totalNumberOfSquares) {
            snakePos.add(snakePos.last + rowSize - totalNumberOfSquares);
          } else {
            // add a new head
            snakePos.add(snakePos.last + rowSize);
          }
        }
        break;
    }

    // snake is eating food
    if (snakePos.last == foodPos) {
      eatFood();
    } else {
      // remove the tail
      snakePos.removeAt(0);
    }
  }

  bool gameOver() {
    // the game is over when snake runs into itself
    // this occurs when there is a duplicate position in the snake list
    List<int> bodySnake = snakePos.sublist(0, snakePos.length - 1);
    if (bodySnake.contains(snakePos.last)) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: RawKeyboardListener(
        focusNode: FocusNode(),
        autofocus: true,
        onKey: (event) {
          if (event.isKeyPressed(LogicalKeyboardKey.arrowUp) &&
              currentDirection != snakeDirections.DOWN) {
            currentDirection = snakeDirections.UP;
          }
          if (event.isKeyPressed(LogicalKeyboardKey.arrowDown) &&
              currentDirection != snakeDirections.UP) {
            currentDirection = snakeDirections.DOWN;
          }
          if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft) &&
              currentDirection != snakeDirections.RIGHT) {
            currentDirection = snakeDirections.LEFT;
          }
          if (event.isKeyPressed(LogicalKeyboardKey.arrowRight) &&
              currentDirection != snakeDirections.LEFT) {
            currentDirection = snakeDirections.RIGHT;
          }
        },
        child: Center(
          child: SizedBox(
            width: screenWidth > 380 ? 380 : screenWidth,
            child: Column(
              children: [
                // high scores
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // user current score
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Current Score',
                            ),
                            Text(
                              currentScore.toString(),
                              style: const TextStyle(fontSize: 36),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: gameHasStarted
                            ? Container()
                            : ListView.builder(
                                itemCount: highscore_DocIds.length,
                                itemBuilder: ((context, index) {
                                  return HighScoreTile(
                                      documentId: highscore_DocIds[index],
                                      index: index);
                                }),
                              ),
                      ),
                    ],
                  ),
                ),

                // game grid
                Expanded(
                  flex: 4,
                  child: GestureDetector(
                    onVerticalDragUpdate: (details) {
                      if (details.delta.dy > 0 &&
                          currentDirection != snakeDirections.UP) {
                        currentDirection = snakeDirections.DOWN;
                      } else if (details.delta.dy < 0 &&
                          currentDirection != snakeDirections.DOWN) {
                        currentDirection = snakeDirections.UP;
                      }
                    },
                    onHorizontalDragUpdate: (details) {
                      if (details.delta.dx > 0 &&
                          currentDirection != snakeDirections.LEFT) {
                        currentDirection = snakeDirections.RIGHT;
                      } else if (details.delta.dx < 0 &&
                          currentDirection != snakeDirections.RIGHT) {
                        currentDirection = snakeDirections.LEFT;
                      }
                    },
                    child: GridView.builder(
                      itemCount: totalNumberOfSquares,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: rowSize,
                      ),
                      itemBuilder: (context, index) {
                        if (snakePos.contains(index)) {
                          return const SnakePixel();
                        } else if (foodPos == index) {
                          return const FoodPixel();
                        } else {
                          return const BlankPixel();
                        }
                      },
                    ),
                  ),
                ),

                // play button
                Expanded(
                  flex: 1,
                  child: Container(
                    child: Center(
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                          side: BorderSide.none,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        color: gameHasStarted ? Colors.grey : Colors.pink,
                        onPressed: gameHasStarted ? () {} : startGame,
                        child: const Text('PLAY'),
                      ),
                    ),
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
