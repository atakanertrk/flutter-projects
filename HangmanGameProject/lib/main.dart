import 'package:flutter/material.dart';
import 'read_examples_from_xml_file.dart';
import 'keyboard_character_model.dart';

void main()=>runApp(MaterialApp(
  home: Home(),
));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}
class _HomeState extends State<Home> {
  _HomeState();
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title:Text('Hangman')),
        body:SingleChildScrollView(child: Container(child: MainPage())),
      );
  }
}


class MainPage extends StatefulWidget {
  const MainPage();
  @override
  _MainPageState createState() => _MainPageState();
}
class _MainPageState extends State<MainPage> {

  // Dile bağımlı arayüz yazıları
  String previous;
  String next;
  String mistakes;
  String failMessage;

  int _level = 0; // level 0 means game is not started yet
  int _mistakeLevel = 0;
  String _question = '';
  String _answer = '';
  String _pressedKey = '';
  String _status = '';
  String _showAnswer = "";
  String _language = "EN";
  var charactersTR = ["a","b","c","ç","d","e","f","g","ğ","h","ı","i","j","k","l","m","n","o","ö","p","r","s","ş","t","u","ü","v","y","z"];
  var charactersEN = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"];
  var characters = [];
  List<String> _guessedCharacters = new List<String>();


  addToGuessedCharacters(String char){
    _guessedCharacters.add(char);
    print(_guessedCharacters);
  }
  LoadLevel(var context, int level, String status) async {
    if(_language == "TR"){
      setState(() {
        mistakes = "hatalar";
        next = "sonraki";
        previous = "önceki";
        failMessage = "leveli geçemediniz";
        characters = charactersTR;
      });
    }
    else{
      setState(() {
        mistakes = "mistakes";
        next = "next";
        previous = "previous";
        failMessage = "you failed at level";
        characters = charactersEN;
      });
    }
    var example = await GetSpecifiedExample(context,level,_language);
    setState(() {
      _question = example.question;
      _answer = example.answer;
      _level = level;
      _pressedKey = '';
      _guessedCharacters = [];
      _mistakeLevel = 0;
      _status = status;
    });
    if(_language == "TR"){
       setState(() {
         _showAnswer = "cevabı göster";
       });
    }
    else{
      setState(() {
        _showAnswer = "see the answer";
      });
    }
  }
  ChangeLanguage(String lang){
    if(lang == "TR"){
      setState(() {
        _language = "TR";
      });
    }
    else{
      setState(() {
        _language = "EN";
      });
    }
    LoadLevel(context, 1, "");
  }
  PressedKey(String key){
    if(!_answer.contains(key)){
      setState(() {
        _mistakeLevel += 1;
      });
    }
    if(_mistakeLevel > 5){
      print("failed");
      LoadLevel(context, _level,failMessage+_level.toString());
    }
    setState(() {
      _pressedKey = key;
    });
    print(key);
  }

  String remainingString = "";
  remainingWordsControl(var context){
    remainingString = "";
    for(int i = 0; i<_answer.toString().length; i++){
      if(_guessedCharacters.contains(_answer[i])){
        remainingString += _answer[i];
      }
      else{
        if(_answer[i] == " "){
          remainingString += " ";
        }
        else{
          remainingString += "_";
        }
      }
    }
    if(!remainingString.contains("_")){
      LoadLevel(context,_level+1,"");
    }
  }

  @override
  Widget build(BuildContext context) {
      if(_level == 0){
        LoadLevel(context,1,"");
      }
      remainingWordsControl(context);
      return  Container(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FlatButton(
                    color: Colors.blue.withOpacity(0.3),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
                    onPressed: (){
                      ChangeLanguage("TR");
                    },
                    child: Text("TR"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FlatButton(
                    color: Colors.blue.withOpacity(0.3),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
                    onPressed: (){
                      ChangeLanguage("EN");
                    },
                    child: Text("EN"),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(4,25,4,10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('LEVEL : ${_level}',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  color: Colors.green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0)),
                  onPressed: (){
                    LoadLevel(context, _level-1,"");
                  },
                  child: Text(previous),
                ),
                FlatButton(
                  color: Colors.green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0)),
                  onPressed: (){
                    LoadLevel(context, _level+1,"");
                  },
                  child: Text(next),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('${_status}',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,backgroundColor: Colors.redAccent.withOpacity(0.5))),
              ],
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(4,40,4,4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image(image:AssetImage('assets/mistakes/${_mistakeLevel}.png')),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('${mistakes} : ${_mistakeLevel}',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  color: Colors.orangeAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
                  onPressed: (){
                    setState(() {
                      _showAnswer = _answer;
                    });
                  },
                  child: Text(_showAnswer),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('${_question}',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                    )
                ),
              ],
            ),
            Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4,20,4,20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                            child: Text(remainingString,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40,backgroundColor: Colors.green.withOpacity(0.5),letterSpacing: 15.0))
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Wrap(
                children: characters.map((e) =>
                    Character(e, PressedKey,addToGuessedCharacters,_guessedCharacters),
                ).toList()
            ),

          ],
        ),
      );
    }
  }



