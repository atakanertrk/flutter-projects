
import 'package:flutter/material.dart';

class Character extends StatefulWidget {
  final _pressTheKey;
  final _key;
  final _addToGuesseds;
  final _guessedCharacters;
  const Character(this._key,this._pressTheKey,this._addToGuesseds,this._guessedCharacters);
  @override
  _CharacterState createState() => _CharacterState();
}
class _CharacterState extends State<Character> {
  int counter = 0;
  @override
  Widget build(BuildContext context) {
    if(widget._guessedCharacters.contains(widget._key)){
      return Padding(
        padding: const EdgeInsets.all(2.0),
        child: FlatButton(
          color: Colors.black12,
          onPressed:null,
          child: Text(widget._key),
        ),
      );
    }
    else{
      return Padding(
        padding: const EdgeInsets.all(2.0),
        child: FlatButton(
          color: Colors.black12,
          onPressed:(){
            widget._addToGuesseds(widget._key);
            widget._pressTheKey(widget._key);
          },
          child: Text(widget._key),
        ),
      );
    }
  }
}
