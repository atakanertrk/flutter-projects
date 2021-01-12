import 'package:flutter/material.dart';

class RemainingWordsArea extends StatefulWidget {
  final _answer;
  final _guessedCharacters;
  const RemainingWordsArea(this._answer,this._guessedCharacters);
  @override
  _RemainingWordsAreaState createState() => _RemainingWordsAreaState();
}

class _RemainingWordsAreaState extends State<RemainingWordsArea> {
  String remainingString = "";
  remainingWordsControl(){
    remainingString = "";
    for(int i = 0; i<widget._answer.toString().length; i++){
      if(widget._guessedCharacters.contains(widget._answer[i])){
        remainingString += widget._answer[i];
      }
      else{
        remainingString += "_";
      }
    }
  }
  @override

  Widget build(BuildContext context) {
    remainingWordsControl();
    print(widget._answer);
    print(widget._guessedCharacters);
    return  Container(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(remainingString),
            ],
          ),
        ],
      ),
    );
  }
}