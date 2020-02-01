import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static AudioCache player = AudioCache();
  var img1 = 'asset/dice1.png';
  var img2 = 'asset/dice1.png';

  String startText = 'Start';
  bool isStart = true;
  int time1 = 10, time2 = 10;
  int p1Chances = 10;
  int p1Score = 0;
  int p2Chances = 10;
  int p2Score = 0;
  bool active1 = false, active2 = false, noWinner = true;
  Color bgc1 = Colors.blueGrey[800], bgc2 = Colors.blueGrey[800];
  Timer timer;

  restart() {
    time1 = 10; 
    time2 = 10;
    p1Chances = 10;
    p1Score = 0;
    p2Chances = 10;
    p2Score = 0;
    active1 = true; 
    active2 = false; 
    noWinner = true;
 bgc1 = Color(0xffB83227);
            bgc2 = Color(0xff0A79DF);
    img1 = 'asset/dice1.png';
    img2 = 'asset/dice1.png';    
    setTimer();
  }
  
  startClick() {
    active1 = true;
    setState(() {
      startText = '';
      isStart = false;
      img1 = 'asset/dice1.png';
      img2 = 'asset/dice2.png';
      bgc1 = Color(0xFF758AA2);
    });
    setTimer();
  }
  
  setTimer() {
    if (p1Chances == 0 && p2Chances == 0) {
      time1 = 0;
      time1 = 0;
     bgc1 = Color(0xffB83227);
            bgc2 = Color(0xff0A79DF);

      if (p1Score > p2Score) {
        img1 = 'asset/winner.jpg';
        img2 = 'asset/lose.png';
        player.play('winner.wav');
        _showResult('Player 1 is the winner.', p1Score, p2Score);
      } else if(p2Score > p1Score) {
        img2 = 'asset/winner.jpg';
        img1 = 'asset/lose.png';
        player.play('winner.wav');
        _showResult('Player 2 is the winner.', p1Score, p2Score);
      } else {
        img2 = 'asset/draw.png';
        img1 = 'asset/draw.png';
        player.play('game_over.wav');
        _showResult('Draw', p1Score, p2Score);
      }
      return;
    }
    if (active1 && time1 > 0) {
      timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
        setState(() {
          if(time1 == 0) {
            timer.cancel();
            p1Chances--;
            active1 = !active1;
            active2 = !active2;
            bgc1 = Color(0xffB83227);
            bgc2 = Color(0xff0A79DF);
            time2 = 10;
            setTimer();
          }
          else {
            if (time1 > 5) {
              player.play('timer.wav');
            } else {
              player.play('urgent_timer.wav');
            }
            time1--;
          }     
        });
      });
      
    } 
    else if (active2 && time2 > 0) {
      timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
        setState(() {
          if(time2 == 0) {
            timer.cancel();
            p2Chances--;
            active1 = !active1;
            active2 = !active2;
           bgc1 = Color(0xffB83227);
            bgc2 = Color(0xff0A79DF);
            time1 = 10;
            setTimer();
          }          
          else {
            if (time2 > 5) {
              player.play('timer.wav');
            } else {
              player.play('urgent_timer.wav');
            }
            time2--;
          }
        });
      });
    }
    else {
      timer.cancel();
    } 
  }
  player1() {
    var r = Random().nextInt(6)+1;
    if (p1Chances > 0 && active1 == true) {
      setState(() {
        img1 = 'asset/dice$r.png';
      
        p1Score += r;
        player.play('dice.wav');
        
        time1 = 0;
      });      
    } 
    
  }

  player2() {
    var r = Random().nextInt(6)+1;
    if (p2Chances > 0 && active2 == true) {
      setState(() {
        img2 = 'asset/dice$r.png';
       
        p2Score += r;
        player.play('dice.wav');
        
        time2 = 0;
      });      
    } 
   
  }
  

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dice Game',
      theme: ThemeData(
        primaryColor: Colors.blue[700]
      ),
      home: Scaffold(
        backgroundColor: Colors.blue[700],
        appBar: AppBar(
          title: Text('Dice Game'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  color: bgc1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '⏰ $time1',
                          style: TextStyle(color: Colors.white, fontSize: 25)
                      ),
                      Padding(padding: EdgeInsets.all(9)),
                      MaterialButton(
                        onPressed: player1,
                        child:  Image(
                          height:145 ,
                          width: 145,
                          image: AssetImage(img1),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Chances Left: $p1Chances',
                            style: TextStyle(color: Colors.white, fontSize: 25)
                          ),
                          Padding(padding: EdgeInsets.all(40)),
                          Text(
                            'Score: $p1Score',
                            style: TextStyle(color: Colors.white, fontSize: 25)
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: isStart,
                child: FlatButton(                
                  onPressed: startClick,
                  child: Text(
                    startText,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: bgc2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '⏰ $time2',
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                      Padding(padding: EdgeInsets.all(9)),
                      MaterialButton(
                        onPressed: player2,
                        child: Image(
                          height:145 ,
                          width: 145,
                          image: AssetImage(img2),
                        )
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Chances Left: $p2Chances',
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                          Padding(padding: EdgeInsets.all(40)),
                          Text(
                            'Score: $p2Score',
                            style: TextStyle(color: Colors.white, fontSize: 25)
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showResult(result, s1, s2) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(result, textAlign: TextAlign.center),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                result == 'Draw' ? Image(
                  image: AssetImage("asset/game.png")
                ):Image(
                  height: 100,
                  width: 100,
                image: AssetImage("asset/winner.jpg")
                ),
                Padding(padding: EdgeInsets.all(7)),
                Text('Scores', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15), textAlign: TextAlign.center),
                Padding(padding: EdgeInsets.all(2)),
                Text('Player 1 score: $s1'),
                Text('Player 2 score: $s2'),
                Padding(padding: EdgeInsets.all(10),),
                MaterialButton(
                  onPressed: () {
                    restart();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Restart',
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                  color: Colors.blue,
                ),
                MaterialButton(
                  onPressed: () {exit(0);},
                  child: Text(
                    'Quit',
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                  color: Colors.blue,
                )
              ],
            ),
          ),
          // actions: <Widget>[
          //   FlatButton(
          //     child: Text('Regret'),
          //     onPressed: () {
          //       Navigator.of(context).pop();
          //     },
          //   ),
          // ],
        );
      },
    );
  }
}