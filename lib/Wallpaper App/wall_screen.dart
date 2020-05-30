import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:startfirebase/Wallpaper%20App/full_screen.dart';

const String testDevice = '';

class WallScreen extends StatefulWidget {
  @override
  _WallScreenState createState() => _WallScreenState();
}

class _WallScreenState extends State<WallScreen> {

 // static final MobileAdTargetingInfo targetInfo = new MobileAdTargetingInfo(
 //   testDevices: <String>[testDevice],
 //   keywords: <String>['wallpapers','walls','amoled'],
 //   birthday: DateTime.now(),
 //   childDirected: true,
 // );

//  BannerAd _bannerAd;
//  InterstitialAd _interstitialAd;

  StreamSubscription<QuerySnapshot> subscription;

  List<DocumentSnapshot> wallpapersList;

  final CollectionReference collectionReference = Firestore.instance.collection("wallpaper");

// BannerAd createBannerAd(){
 //   return new BannerAd(
//      adUnitId: BannerAd.testAdUnitId,
//      size: AdSize.banner,
//      targetingInfo: targetInfo,
//       listener: (MobileAdEvent event){
//         print("Banner event : $event");
 //      }
//       );
//  }

//  InterstitialAd createInterstitialAd(){
//    return new InterstitialAd(
//      adUnitId: InterstitialAd.testAdUnitId,
//       targetingInfo: targetInfo,
//       listener: (MobileAdEvent event){
 //        print("Interstitial event : $event");
 //      }
 //      );
//  }


  @override
  void initState(){
    super.initState();
 //   FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId);
 //   _bannerAd = createBannerAd()
 //   ..load()
  //  ..show();
    subscription= collectionReference.snapshots().listen((datasnapshot){
      setState(() {
        wallpapersList = datasnapshot.documents;
      });
    });
  }

  @override
  void dispose(){
  //  _bannerAd?.dispose();
  //  _interstitialAd?.dispose();
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("Gunner"),
      ),
      body: wallpapersList != null?
      StaggeredGridView.countBuilder(
        padding: const EdgeInsets.all(8.0),
        crossAxisCount: 4,
        itemCount: wallpapersList.length,
         itemBuilder: (context,i){
           String imgPath = wallpapersList[i].data['url'];
           return Material(
             elevation: 8.0,
             borderRadius: BorderRadius.all(Radius.circular(8.0)),
             child: new InkWell(
               onDoubleTap: () {
    //             createInterstitialAd()
   //              ..load()
  //               ..show();
                 Navigator.push(context, new MaterialPageRoute(
                 builder: (context) => FullScreenImagePage(imgPath)
                 ));},
               child: new Hero(
                 tag: imgPath, 
                 child: FadeInImage(
                    image: NetworkImage(imgPath),
                    fit: BoxFit.cover,
                   placeholder: AssetImage("assets/gunner.jpg"), 
                  )
                  ),
             ),
           );
          },
          staggeredTileBuilder: (i)=> StaggeredTile.count(2, i.isEven?2:3),
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
         ): Center(
           child: CircularProgressIndicator(),
         )
    );
  }
}