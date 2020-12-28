import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dataAccess.dart';

// notes
// localhost => https://10.0.2.2:5001

// data access code

// end of data access code

void main()=>runApp(MaterialApp(
  home: Home(),
));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}
class _HomeState extends State<Home> {
  bool isLogedIn = false;
  String _userName;
  String _password;
  String result = 'login';
  _HomeState();

  Future<void> ValidateUserInformation(String userName, String password) async{
    bool validateResult = await validate(userName,password);
    if(validateResult == true){
      setState(() {
        isLogedIn=true;
        result='welcome';
      });
    }
    else{
      setState(() {
        isLogedIn=false;
        result='login failed !';
      });
    }
  }
  login(String userName, String password) async {
    await ValidateUserInformation(userName,password);
    _userName = userName;
    _password = password;
  }
  createAcc(String userName, String password) async {
    if(await create(userName,password)){
      _userName = userName;
      _password = password;
      ValidateUserInformation(userName,password);
    }
    else{
      setState(() {
        result = 'Create Filed !';
      });
    }
  }
  logOut(){
    setState(() {
      isLogedIn = false;
      result = 'login';
      _userName = ' ';
      _password = ' ';
    });
  }

  @override
  Widget build(BuildContext context) {
    if(isLogedIn){
      return Scaffold(
        appBar: AppBar(title:Text(result)),
        body:SingleChildScrollView(child: Container(child: UserPage(logOut,_userName,_password))),
      );
    }
    else{
      return Scaffold(
        appBar: AppBar(title:Text(result)),
        body: SingleChildScrollView(child: Container(child: LoginForm(login,createAcc)),),
      );
    }
  }
}

class LoginForm extends StatefulWidget {
  final loginFunc;
  final createAccFunc;
  const LoginForm(this.loginFunc,this.createAccFunc);
  @override
  _LoginFormState createState() => _LoginFormState();
}
class _LoginFormState extends State<LoginForm> {
  String _userName;
  String _password;
  String internet = '.';
  @override



  Widget build(BuildContext context) {
    return  Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(5.0,80.0,20.0,0.0),
            child: Row(
              children: <Widget>[
                Expanded(child: Text('UserName'),flex:1),
                Expanded(
                  flex:3,
                  child: TextField(
                    onChanged: (text){
                      _userName = text;
                    },
                  ),
                ),
              ],
            ),
          ),Padding(
            padding: const EdgeInsets.fromLTRB(5.0,80.0,20.0,0.0),
            child: Row(
              children: <Widget>[
                Expanded(child: Text('Password'),flex:1),
                Expanded(
                  flex:3,
                  child: TextField(
                    obscureText: true,
                    onChanged: (text){
                      _password = text;
                    },
                    obscuringCharacter: "*",
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: FlatButton(
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
                  onPressed: (){ widget.loginFunc(_userName,_password);  },
                  child: Text('login'),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text('or create account with above following information'),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: FlatButton(
                  color: Colors.redAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
                  onPressed: (){ widget.createAccFunc(_userName,_password);  },
                  child: Text('create'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class UserPage extends StatefulWidget {
  final logOut;
  final _userName;
  final _password;
  const UserPage(this.logOut,this._userName,this._password);
  @override
  _UserPageState createState() => _UserPageState();
}
class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: Text('welcome ${widget._userName}'),
            ),
            Expanded(
              flex:2,
              child: FlatButton(
                color: Colors.redAccent,
                onPressed: (){ widget.logOut();  },
                child: Text('logout'),
              ),
            ),
          ],
        ),
        NotesSection(widget._userName,widget._password),
        // NoteAddForm(widget._userName,widget._password),
      ],
    );
  }
}

class NotesSection extends StatefulWidget {
  final _userName;
  final _password;

  const NotesSection(this._userName,this._password);
  @override
  _NotesSectionState createState() => _NotesSectionState();
}
class _NotesSectionState extends State<NotesSection> {
  bool areNotesLoaded = false;
  List<Notes> userNotesList;
  String _note = 'empty';
  void loadNotes()async{
    userNotesList = await GetUserNotes(widget._userName,widget._password);
    setState(() {
      areNotesLoaded = true;
    });
  }

  var noteFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if(areNotesLoaded == false){
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(child: Container(),flex: 2,),
              Expanded(
                flex:3,
                child:FlatButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
                  color: Colors.blue,
                  child: Text('get my notes',),
                  onPressed: () async {
                    loadNotes();
                  },
                ),
              ),
              Expanded(child: Container(),flex: 2,),
            ],
          ),
        ],
      );
    }else{
      return Container(
        color: Colors.green[100],
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5.0,30.0,0.5,20.0),
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: userNotesList.map((e) =>
                        Row(
                          children: <Widget>[
                            Container(
                                padding: EdgeInsets.all(10.0),
                                width: MediaQuery.of(context).size.width * 80 / 100,
                                child: Text(e.note)
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 15 / 100,
                              child: FloatingActionButton(
                                onPressed: ()async { await DeleteNote(widget._userName,widget._password,e.noteId); loadNotes(); },
                                child: Text('Delete'),
                              ),
                            ),
                          ],
                        )
                    ).toList(),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5.0,50.0,5.0,30.0),
                    child: Container(
                      color: Colors.blue[100],
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width * 80 / 100,
                                child: TextField(
                                  decoration: InputDecoration(
                                    labelText: 'write your note here',
                                  ),
                                  controller: noteFieldController,
                                  onChanged: (text){
                                    _note= text;
                                  },
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 15 / 100,
                                child: FloatingActionButton(
                                  child: Text('add'),
                                  onPressed: ()async{
                                    await AddNote(_note,widget._userName,widget._password);
                                    loadNotes();
                                    noteFieldController.clear();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }
}




