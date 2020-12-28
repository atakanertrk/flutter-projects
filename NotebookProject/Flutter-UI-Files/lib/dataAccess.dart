import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Notes{
  final int noteId;
  final String note;
  Notes(this.note,this.noteId);

  Notes.fromJson(Map<String, dynamic> json)
      : noteId = json['id'],
        note = json['note'];

  Map<String, dynamic> toJson() =>
      {
        'id': noteId,
        'note': note,
      };

}
Future<void> DeleteNote(String userName, String password, int noteId) async {
  HttpClient client = new HttpClient();
  client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
  Map data = {
    'name': userName,
    'password':password,
    'noteId':noteId
  };
  String url = 'https://notebookapi.webde.biz.tr/api/notebook/deletenote';

  HttpClientRequest request = await client.postUrl(Uri.parse(url));
  request.headers.set('content-type', 'application/json');
  request.add(utf8.encode(json.encode(data)));
  HttpClientResponse response = await request.close();

  if(response.statusCode == 200){
    print('deleted');
  }
  else{
    print('failed');
  }
}
Future<List<Notes>> GetUserNotes(String userName, String password) async {

  HttpClient client = new HttpClient();
  client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
  Map data = {
    'name': userName,
    'password':password
  };
  String url = 'https://notebookapi.webde.biz.tr/api/notebook/getusernotes';

  HttpClientRequest request = await client.postUrl(Uri.parse(url));
  request.headers.set('content-type', 'application/json');
  request.add(utf8.encode(json.encode(data)));
  HttpClientResponse response = await request.close();

  var result = new StringBuffer();
  await for (var contents in response.transform(Utf8Decoder())) {
    result.write(contents);
  }

  print(result.toString());
  // List<Notes> notes = jsonDecode(result.toString());

  List<Notes> notes = (json.decode(result.toString()) as List).map((i) =>
      Notes.fromJson(i)).toList();

  return notes;
}
Future<void> AddNote(String note, String userName, String password) async {

  HttpClient client = new HttpClient();
  client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
  Map data = {
    'note':note,
    'name': userName,
    'password':password
  };
  String url = 'https://notebookapi.webde.biz.tr/api/notebook/addnote';

  HttpClientRequest request = await client.postUrl(Uri.parse(url));
  request.headers.set('content-type', 'application/json');
  request.add(utf8.encode(json.encode(data)));
  HttpClientResponse response = await request.close();

  if(response.statusCode == 200){
    print('added');
  }
  else{
    print('failed');
  }
}


Future<bool> validate(String userName, String password) async {
  HttpClient client = new HttpClient();
  client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
  Map data = {
    'name': userName,
    'password':password
  };
  String url = 'https://notebookapi.webde.biz.tr/api/notebook/isuservalid';

  HttpClientRequest request = await client.postUrl(Uri.parse(url));
  request.headers.set('content-type', 'application/json');
  request.add(utf8.encode(json.encode(data)));
  HttpClientResponse response = await request.close();

    if(response.statusCode == 200){
      return true;
    }else{
      return false;
    }
}

Future<bool> create(String userName, String password) async {
  HttpClient client = new HttpClient();
  client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
  Map data = {
    'name': userName,
    'password':password
  };
  String url = 'https://notebookapi.webde.biz.tr/api/notebook/InsertUser';

  HttpClientRequest request = await client.postUrl(Uri.parse(url));
  request.headers.set('content-type', 'application/json');
  request.add(utf8.encode(json.encode(data)));
  HttpClientResponse response = await request.close();

  if(response.statusCode == 200){
    return true;
  }
  return false;
}