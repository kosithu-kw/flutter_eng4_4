import 'dart:convert';

import 'package:eng_for_you/search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'search.dart';
import 'error.dart';



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

  _fetchData() async{
    var result=await http.get(Uri.https("raw.githubusercontent.com", "kosithu-kw/eng4u_data/master/list.json"));
    var jsonData=jsonDecode(result.body);
    return jsonData;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: _title,
        home: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(_title),
            bottom: PreferredSize(
              child: Text(_subTitle, style: TextStyle( color: Colors.white70),),
              preferredSize: Size.fromHeight(20),
            ),
            actions: [
              IconButton(
                  onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext)=>new SearchApp()));

                  },
                  icon: Icon(Icons.search_outlined)
              )
            ],
          ),
          drawer: Drawer(
            child: ListView(
              children: [
                ListTile(
                  title: Text("App Version"),
                  subtitle: Text("1.0.0"),
                  leading: Icon(Icons.settings_accessibility),
                  onTap: (){
                    Navigator.of(context).pushNamed("/home");
                  },
                ),
                ListTile(
                  title: Text("Share App"),
                  leading: Icon(Icons.share),
                  onTap: (){
                    Share.share("https://play.google.com/store/apps/details?id=com.goldenmawlamyine.eng_for_you");
                  },
                )
              ],
            ),
          ),
          body: Container(
            child: FutureBuilder(
              future: _fetchData(),
              builder: (context, AsyncSnapshot s){
                if(s.hasData){

                  return ListView.builder(
                      itemCount: s.data.length,
                      itemBuilder: (context, i){
                        return Card(
                          child: ListTile(
                            title: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Icon(Icons.library_books_sharp, size: 16,),
                                ),
                                Container(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Text("${s.data[i]['eng']}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                                ),
                                Container(
                                  child: Text("${s.data[i]['mm']}"),
                                )
                              ],
                            ),
                          ),
                        );
                      }
                  );

                }else if(s.hasError){
                  return Center(
                      child: IconButton(
                        onPressed: (){
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => new ErrorApp()));
                        },
                        icon: Icon(Icons.refresh_outlined),
                      )
                  );
                }else{
                  return Container(
                    padding: EdgeInsets.only(left: 100, right: 100),
                    child: Center(
                      child: LinearProgressIndicator(),
                    ),
                  );
                }
              },
            ),
          ),
        )
    );
  }
}
