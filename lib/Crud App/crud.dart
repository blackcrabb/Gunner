import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      home:  new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String myText = null;

  StreamSubscription<DocumentSnapshot> subscription;

  final DocumentReference documentReference = Firestore.instance.document("myData/dummy");

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn googleSignIn = new GoogleSignIn();

  Future<FirebaseUser> _signIn() async {
  GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  GoogleSignInAuthentication gSA = await googleSignInAccount.authentication;

final AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: gSA.idToken,
      accessToken: gSA.accessToken,
    );
    final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    print("User Name : ${user.displayName}");
    return user;
  }

  void _signOut() {
    googleSignIn.signOut();
    print("User Signed Out");
  }

  void _add(){
    Map<String,String> data = <String,String>{
      "name" : "Niyati Sharma",
      "desc" : "Trying to do something"
    };

    documentReference.setData(data).whenComplete((){
      print("Document Added");
    }).catchError((e)=> print(e));
    
  }

  void _delete(){
    documentReference.delete().whenComplete((){
      print("Deleted Succesfully");
      setState(() { 
      });
    }).catchError((e) => print(e));
  }

  void _update(){

    Map<String,String> data = <String,String>{
      "name" : "Niyati Sharma updated",
      "desc" : "Flutter Developer"
    };

    documentReference.updateData(data).whenComplete((){
      print("Document Updated");
    }).catchError((e)=> print(e));
    
  }

  void _fetch(){
    documentReference.get().then((datasnapshot){
      if(datasnapshot.exists){
        setState(() {
          myText = datasnapshot.data['desc'];
        });
      }
    });
  }

  @override
  void initState(){
    super.initState();
    subscription= documentReference.snapshots().listen((datasnapshot){
      if(datasnapshot.exists){
        setState(() {
          myText = datasnapshot.data['desc'];
        });
      }
    });
  }

  @override
  void dispose(){
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("FireBase Demo"),
      ),
      body: new Padding(
        padding: const EdgeInsets.all(20.0),
        child: new Column(
          mainAxisAlignment : MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new RaisedButton(
              onPressed: ()=> _signIn()
              .then((FirebaseUser user)=>print(user)).catchError((e) => print(e)
              ),
              child: new Text("Sign In"),
              color: Colors.amber,
            ),
            new Padding(
              padding: const EdgeInsets.all(20.0),
            ),
            new RaisedButton(
              onPressed: ()=> _signOut(),
              child: new Text("Sign Out"),
              color: Colors.cyan,
              ),
              new Padding(
              padding: const EdgeInsets.all(20.0),
            ),
            new RaisedButton(
              onPressed: ()=> _add(),
              child: new Text("Add"),
              color: Colors.teal
              ),
              new Padding(
              padding: const EdgeInsets.all(20.0),
            ),
            new RaisedButton(
              onPressed: ()=> _update(),
              child: new Text("Update"),
              color: Colors.lightGreen,
              ),
              new Padding(
              padding: const EdgeInsets.all(20.0),
            ),
            new RaisedButton(
              onPressed: ()=> _delete(),
              child: new Text("Delete"),
              color: Colors.pinkAccent,
              ),
              new Padding(
              padding: const EdgeInsets.all(20.0),
            ),
            new RaisedButton(
              onPressed: ()=> _fetch(),
              child: new Text("Fetch"),
              color: Colors.indigo,
              ),
               new Padding(
              padding: const EdgeInsets.all(20.0),
            ),
              myText == null ? new Container() : 
              new Text(myText,style: new TextStyle(fontSize: 20.0),)
          ],
        ),
        ),
    );
  }
}

