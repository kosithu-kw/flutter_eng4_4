import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'error.dart';



class SearchApp extends StatefulWidget {
  const SearchApp({Key? key}) : super(key: key);

  @override
  _SearchAppState createState() => _SearchAppState();
}

class _SearchAppState extends State<SearchApp> {
  @override

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
    var res=await http.get(Uri.https('raw.githubusercontent.com', "kosithu-kw/eng4u_data/master/list.json"));
    var jsonData=jsonDecode(res.body);

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
    Timer(Duration(seconds: 3), () => checkConnection());
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
                  Navigator.pop(context);
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
                  emptyWidget: Center(
                    child: Text("သင်ရှာသောအစားအစာနာမည်မတွေ့ရှိပါ"),
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