import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:eng_for_you/ad_helper.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'error.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;

import 'home.dart';


class Searchwf extends StatefulWidget {
  const Searchwf({Key? key}) : super(key: key);

  @override
  _SearchwfState createState() => _SearchwfState();
}

class _SearchwfState extends State<Searchwf> {
  @override

  /*
  String InterstitialId="";
  bool showInter=false;

  _getAdId() async{
    var result=await http.get(Uri.https("raw.githubusercontent.com", "kosithu-kw/eng4u_data/master/ads.json"));
    var jsonData=await jsonDecode(result.body);
    //print(jsonData['int']);

    if(jsonData['showInter']=="true"){
     // print(jsonData['testInter']);
        setState(() {
          InterstitialId=jsonData['int'];
          showInter=true;
        });
        if(!_isInterstitialAdReady){
            _loadInterstitialAd();
          }

      }else{
        setState(() {
          showInter=false;
        });
      }

  }

   */


  // TODO: Add _interstitialAd
  InterstitialAd? _interstitialAd;

  // TODO: Add _isInterstitialAdReady
  bool _isInterstitialAdReady = false;

  // TODO: Implement _loadInterstitialAd()
  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          this._interstitialAd = ad;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: HomeApp()));
            },
          );

          _isInterstitialAdReady = true;
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
          _isInterstitialAdReady = false;
        },
      ),
    );
  }



  checkConnection() async{
    try {
      final result = await InternetAddress.lookup('raw.githubusercontent.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // Navigator.pushNamed(context, '/search');
      }
    } on SocketException catch (_) {
      Navigator.pushNamed(context, '/error');
    }
  }


  Future<List<Word>> _getALlWord(String text) async {
    var result=await DefaultCacheManager().getSingleFile("https://raw.githubusercontent.com/kosithu-kw/eng4u_data/master/wordform.json");
    var file=await result.readAsString();
    var jsonData=jsonDecode(file);

    List<Word> words = [];

    for (var w in jsonData) {
      if(w['eng_v1'].toLowerCase().contains(text.toLowerCase()) || w['eng_v2'].toLowerCase().contains(text.toLowerCase()) || w['eng_v3'].toLowerCase().contains(text.toLowerCase()) || w['eng_ving'].toLowerCase().contains(text.toLowerCase()) || w['mm'].toLowerCase().contains(text.toLowerCase())){
        words.add(Word(w['eng_v1'], w['eng_v2'], w['eng_v3'], w['eng_ving'], w['mm']));
      }

    }
    return words;
  }

  @override
  void initState() {
    if(!_isInterstitialAdReady){
      _loadInterstitialAd();
    }
    // TODO: implement initState

  }
  @override
  void dispose() {
    // TODO: implement dispose
    _interstitialAd?.dispose();

    super.dispose();
  }

  final String _title="VERB FORM";
  final String _subTitle="English - မြန်မာ နှစ်ဘာသာဖြင့်ရှာနိုင်သည်";


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        return await Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: HomeApp()));
      },
     child: MaterialApp(
        routes: {
          '/error' : (context) => ErrorApp(),
        },
        home: Scaffold(
            appBar: AppBar(
              centerTitle: true,

              title: Text(_title),
              bottom: PreferredSize(
                child: Text(_subTitle, style: TextStyle( color: Colors.white70),),
                preferredSize: Size.fromHeight(20),
              ),

            ),
            floatingActionButton: FloatingActionButton(
              onPressed: (){
                if(_isInterstitialAdReady){
                  _interstitialAd?.show();
                }else{
                  Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: HomeApp()));
                }
              },
              child: Icon(Icons.home),
            ),

            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                child: SearchBar(
                  onSearch:(t)=> _getALlWord(t),
                  loader: Center(
                    child: Text("ရှာနေသည်..."),
                  ),
                  minimumChars: 1,

                  emptyWidget: Container(
                    padding: EdgeInsets.all(10),
                   child: Center(
                      child: Text("သင်ရှာသောစာလုံးပေါင်းမရှိသေးပါ၊ မကြာမီတွင် Server ဘက်မှစာလုံးပေါင်းအသစ်များ Update ပြုလုပ်ပေးပါမည်။"),
                    ),
                  ),
                  hintText: "ရှာမည်",
                  onItemFound: (Word word, int i){
                    return Container(
                        child: Card(
                          child: ListTile(
                            title: Column(
                              children: [
                                Container(
                                  child: Text("${word.mm}", style: TextStyle(fontWeight: FontWeight.bold),),
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      // padding: EdgeInsets.only(right: 10),
                                        child: Column(
                                          children: [
                                            Text("V1", style: TextStyle(fontSize: 12),),
                                            Text("${word.eng_v1}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
                                          ],
                                        )

                                    ),
                                    Container(
                                        child: Column(
                                          children: [
                                            Text("V2", style: TextStyle(fontSize: 12),),
                                            Text("${word.eng_v2}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
                                          ],
                                        )
                                    ),
                                    Container(
                                        child: Column(
                                          children: [
                                            Text("V3", style: TextStyle(fontSize: 12),),
                                            Text("${word.eng_v3}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                                          ],
                                        )
                                    ),
                                    Container(
                                        child: Column(
                                          children: [
                                            Text("V ing", style: TextStyle(fontSize: 12),),
                                            Text("${word.eng_ving}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
                                          ],
                                        )
                                    )
                                  ],
                                )
                              ],
                            ),
                          )
                        )
                    );
                  },

                ),
              ),
            )
        )
     )
    );
  }
}

class Word {
  String eng_v1, eng_v2, eng_v3, eng_ving, mm;
  Word(this.eng_v1, this.eng_v2, this.eng_v3, this.eng_ving, this.mm);
}