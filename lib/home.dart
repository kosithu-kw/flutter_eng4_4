import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:eng_for_you/ad_helper.dart';
import 'package:eng_for_you/eve.dart';
import 'package:eng_for_you/readme.dart';
import 'package:eng_for_you/spelling.dart';
import 'package:eng_for_you/wordform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;


void main(){
  runApp(HomeApp());
}

class HomeApp extends StatefulWidget {
  const HomeApp({Key? key}) : super(key: key);

  @override
  _HomeAppState createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  final String _title="Eng 4 U";
  final String _subTitle="သင့်အတွက်အင်္ဂလိပ်စာ";

  /*
  String bannerID="";
  bool showBanner=false;
  _getAdId() async{
    var result=await http.get(Uri.https("raw.githubusercontent.com", "kosithu-kw/eng4u_data/master/ads.json"));
    var jsonData=await jsonDecode(result.body);
    //print(jsonData['int']);

    if(jsonData['showBanner']=="true"){
      // print(jsonData['testInter']);
      setState(() {
        bannerID=jsonData['banner'];
        showBanner=true;
      });
     _callBanner();

    }else{
      setState(() {
        showBanner=false;
      });
    }
}
   */



  // TODO: Add _bannerAd
  late BannerAd _bannerAd;

  // TODO: Add _isBannerAdReady
  bool _isBannerAdReady = false;

  _callBanner(){
    // TODO: Initialize _bannerAd
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );

    _bannerAd.load();
  }

  int _spelling=0;
  int _verbform=0;
  int _eve=0;

  _fetchSpelling() async{
    var result=await DefaultCacheManager().getSingleFile("https://raw.githubusercontent.com/kosithu-kw/eng4u_data/master/list.json");
    var file=await result.readAsString();
    var j=jsonDecode(file);
    setState(() {
      _spelling=j.length;
    });
  }
  _fetchVerbform() async{
    var result=await DefaultCacheManager().getSingleFile("https://raw.githubusercontent.com/kosithu-kw/eng4u_data/master/wordform.json");
    var file=await result.readAsString();
    var j=jsonDecode(file);
    setState(() {
      _verbform=j.length;
    });
  }
  _fetchEve() async{
    var result=await DefaultCacheManager().getSingleFile("https://raw.githubusercontent.com/kosithu-kw/eng4u_data/master/eve.json");
    var file=await result.readAsString();
    var j=jsonDecode(file);
    setState(() {
      _eve=j.length;
    });
  }

 @override
  void initState() {

    if(!_isBannerAdReady){
      _callBanner();
    }
    _fetchSpelling();
    _fetchVerbform();
    _fetchEve();

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _bannerAd.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        return await exit(0);
      },
     child: MaterialApp(
        title: _title,
        home: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(_title),
            bottom: PreferredSize(
              child: Text(_subTitle, style: TextStyle( color: Colors.white70),),
              preferredSize: Size.fromHeight(20),
            ),

          ),
          drawer: Drawer(
            child: ListView(
              children: [
                ListTile(
                  title: Text("App Version"),
                  subtitle: Text("1.0.0"),
                  leading: Icon(Icons.settings_accessibility),

                ),
                /*
                ListTile(
                  title: Text("Share App"),
                  leading: Icon(Icons.share),
                  onTap: (){
                    Share.share("https://play.google.com/store/apps/details?id=com.goldenmawlamyine.eng_for_you");
                  },
                ),

                 */
                ListTile(
                  title: Text("Read Me"),
                  leading: Icon(Icons.read_more),
                  onTap: (){
                    Navigator.push(context, PageTransition(type: PageTransitionType.leftToRight, child: ReadmeApp()));
                  },
                )
              ],
            ),
          ),
          body: SafeArea(
            child: Stack(
              children: [

                Container(
                    decoration: _isBannerAdReady ? BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: 70,
                                color: Colors.white70
                            )
                        )
                    ): null,
                  child: ListView(
                    children: [
                      Container(
                          padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                          child: InkWell(
                            onTap: (){
                              Navigator.pushReplacement(context, PageTransition(child: Spelling(), type: PageTransitionType.rightToLeft));
                            },
                            child: Card(
                              child: Center(
                                  child: Row(
                                    children: [
                                      SizedBox(width: 20,),
                                      Container(
                                        padding: EdgeInsets.all(20),
                                        child: Icon(Icons.spellcheck, size: 40,),
                                      ),

                                      Container(
                                        padding: EdgeInsets.all(20),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("SPELLINGS", style: TextStyle(color: Colors.amber[800], fontWeight: FontWeight.bold, fontSize: 18),),
                                            SizedBox(height: 10,),
                                            Text("English - မြန်မာ"),
                                            Text("စာလုံးရေ - ${_spelling}", style: TextStyle(color: Colors.grey),)
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                              ),
                            ),
                          )
                      ),
                      Container(
                          padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                          child: InkWell(
                            onTap: (){
                              Navigator.pushReplacement(context, PageTransition(child: Wordform(), type: PageTransitionType.rightToLeft));
                            },
                            child: Card(
                              child: Center(
                                  child: Row(
                                    children: [
                                      SizedBox(width: 20,),
                                      Container(
                                        padding: EdgeInsets.all(20),
                                        child: Icon(Icons.library_add_check_outlined, size: 40,),
                                      ),

                                      Container(
                                        padding: EdgeInsets.all(20),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("VERB FORM", style: TextStyle(color: Colors.amber[800], fontWeight: FontWeight.bold, fontSize: 18),),
                                            SizedBox(height: 10,),
                                            Text("English - မြန်မာ"),
                                            Text("စာလုံးရေ - ${_verbform}", style: TextStyle(color: Colors.grey),)

                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                              ),
                            ),
                          )
                      ),
                      Container(
                          padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                          child: InkWell(
                            onTap: (){
                              Navigator.pushReplacement(context, PageTransition(child: Eve(), type: PageTransitionType.rightToLeft));
                            },
                            child: Card(
                              child: Center(
                                  child: Row(
                                    children: [
                                      SizedBox(width: 20,),
                                      Container(
                                        padding: EdgeInsets.all(20),
                                        child: Icon(Icons.supervisor_account, size: 40,),
                                      ),

                                      Container(
                                        padding: EdgeInsets.all(20),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("English For Everyday", style: TextStyle(color: Colors.amber[800], fontWeight: FontWeight.bold, fontSize: 18),),
                                            SizedBox(height: 10,),
                                            Text("နေ့စဉ်သုံးအင်္ဂလိပ်စကား"),
                                            Text("စာလုံးရေ - ${_eve}", style: TextStyle(color: Colors.grey),)

                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                              ),
                            ),
                          )
                      ),

                    ],
                  ),
                ),

                if (_isBannerAdReady)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: _bannerAd.size.width.toDouble(),
                      height: _bannerAd.size.height.toDouble(),
                      child: AdWidget(ad: _bannerAd),
                    ),
                  ),
              ],
            ),
          )
        )
     )
    );
  }
}
