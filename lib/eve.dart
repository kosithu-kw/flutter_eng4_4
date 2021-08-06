import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:eng_for_you/home.dart';
import 'package:eng_for_you/readme.dart';
import 'package:eng_for_you/search.dart';
import 'package:eng_for_you/search_eve.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'search.dart';
import 'error.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:page_transition/page_transition.dart';


class Eve extends StatefulWidget {
  const Eve({Key? key}) : super(key: key);

  @override
  _EveState createState() => _EveState();
}

class _EveState extends State<Eve> {
  final String _title="English For Everyday";
  final String _subTitle="နေ့စဉ်သုံးအင်္ဂလိပ်စကား";

  _fetchData() async{
    var result=await DefaultCacheManager().getSingleFile("https://raw.githubusercontent.com/kosithu-kw/eng4u_data/master/eve.json");
    var file=await result.readAsString();
    var jsonData=jsonDecode(file);
    return jsonData;
  }

  bool _isUpdate=false;

  _updateData() async{
    await DefaultCacheManager().emptyCache().then((value){
      setState(() {
        _isUpdate=true;

      });
      Timer(Duration(seconds: 3), () {
        setState(() {
          _isUpdate=false;
        });
      });
    });
  }

  @override
  void initState() {



    super.initState();
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
                leading: IconButton(onPressed: (){
                  _updateData();
                },
                  icon: Icon(Icons.cloud_download),
                ),
                centerTitle: true,
                title: Column(
                  children: [
                    Text(_title),
                    SizedBox(height: 10,),
                    Text(_subTitle, style: TextStyle( color: Colors.white70, fontSize: 14),),
                  ],

                ),
                toolbarHeight: 80,
                actions: [

                  IconButton(
                      onPressed: (){
                        Navigator.push(context, PageTransition(type: PageTransitionType.leftToRight, child: SearchEve()));
                      },
                      icon: Icon(Icons.search_outlined)
                  )
                ],
              ),
              /*
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

               */
              floatingActionButton: FloatingActionButton(
                onPressed: (){
                  Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: HomeApp()));

                },
                child: Icon(Icons.home),
              ),
              body: Container(
                child: FutureBuilder(
                  future: _isUpdate ? _fetchData() : _fetchData(),
                  builder: (context, AsyncSnapshot s){

                    if(_isUpdate)
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 120, right: 120),
                              child: LinearProgressIndicator(),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 20),
                              child: Text("Updating data from server..."),
                            )
                          ],
                        ),
                      );


                    if(s.hasData){

                      return ListView.builder(
                          itemCount: s.data.length,
                          itemBuilder: (context, i){
                            return Card(
                              child: ListTile(
                                title: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(right: 10),
                                          child: Text("${s.data[i]['eng']}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                                        ),
                                        Container(
                                          child: Text("${s.data[i]['mm']}"),
                                        )
                                      ],
                                    )

                                )
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
        )
    );
  }
}
