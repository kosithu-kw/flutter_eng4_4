import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'error.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'ad_helper.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart';


class SearchApp extends StatefulWidget {
  const SearchApp({Key? key}) : super(key: key);

  @override
  _SearchAppState createState() => _SearchAppState();
}

class _SearchAppState extends State<SearchApp> {
  @override

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
              Navigator.pop(context);
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
    var result=await DefaultCacheManager().getSingleFile("https://raw.githubusercontent.com/kosithu-kw/eng4u_data/master/list.json");
    var file=await result.readAsString();
    var jsonData=jsonDecode(file);

    List<Word> words = [];

    for (var w in jsonData) {
      if(w['eng'].toLowerCase().contains(text.toLowerCase()) || w['mm'].toLowerCase().contains(text.toLowerCase())){
        words.add(Word(w['eng'], w['mm']));
      }

    }
    return words;
  }

  @override
  void initState() {
    // TODO: implement initState
    //Timer(Duration(seconds: 3), () => checkConnection());
    if (!_isInterstitialAdReady) {
      _loadInterstitialAd();
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _interstitialAd?.dispose();

    super.dispose();
  }

  final String _title="English - မြန်မာစာ";
  final String _subTitle="ဖြင့်ရှာဖွေရန်";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        routes: {
          '/error' : (context) => ErrorApp(),
        },
        home: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              leading: IconButton(
                onPressed: (){
                  if (_isInterstitialAdReady) {
                    _interstitialAd?.show();
                  } else {
                    Navigator.pop(context);
                  }

                },
                icon: Icon(Icons.arrow_back),
              ),
              title: Text(_title),
              bottom: PreferredSize(
                child: Text(_subTitle, style: TextStyle( color: Colors.white70),),
                preferredSize: Size.fromHeight(20),
              ),

            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: SearchBar(
                  onSearch:(t)=> _getALlWord(t),
                  loader: Center(
                    child: Text("ရှာဖွေနေသည်..."),
                  ),
                  minimumChars: 1,

                  emptyWidget: Container(
                    padding: EdgeInsets.all(10),
                   child: Center(
                      child: Text("သင်ရှာသောစာလုံးပေါင်းမရှိသေးပါ၊ မကြာမီတွင် Server ဘက်မှစာလုံးပေါင်းအသစ်များ Update ပြုလုပ်ပေးပါမည်။"),
                    ),
                  ),
                  hintText: "ရှာဖွေရန်",
                  onItemFound: (Word word, int i){
                    return Container(
                        child: Card(
                          child: ListTile(
                            title: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Icon(Icons.library_books_sharp, size: 16,),
                                ),
                                Container(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Text("${word.eng}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                                ),
                                Container(
                                  child: Text("${word.mm}"),
                                )
                              ],
                            ),
                          ),
                        )
                    );
                  },

                ),
              ),
            )
        )
    );
  }
}

class Word {
  String eng, mm;
  Word(this.eng, this.mm);
}