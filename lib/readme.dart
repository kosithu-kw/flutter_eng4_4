import 'dart:convert';
import 'package:eng_for_you/home.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';



class ReadmeApp extends StatefulWidget {
  const ReadmeApp({Key? key}) : super(key: key);

  @override
  _ReadmeAppState createState() => _ReadmeAppState();
}

class _ReadmeAppState extends State<ReadmeApp> {
  final String _title="Eng 4 U";
  final String _subTitle="သင့်အတွက်အင်္ဂလိပ်စာ";
  final String _readMeBody="Eng 4 U ကိုပထမဦးဆုံးအကြိမ်အသုံးပြုခြင်းအတွက် Internet Connection ဖွင့်ထားရန်လိုအပ်ပါသည်၊ လိုအပ်ပါက VPN များချိတ်ဆက်အသုံးပြုရပါမည်။နောက်ပိုင်းအသုံးပြုခြင်းအတွက်  Internet Connection ဖွင့်ထားရန်မလိုအပ်တော့ပါ။English နှင့် မြန်မာ စကားလုံးများကို Server ဘက်မှ အမြဲတမ်း Update လုပ်နေပါမည်၊ စကားလုံးအသစ်များအတွက် အင်တာနက်ဖွင့်ပြီး အသုံးပြုလျှင် Server မှ စကားလုံးများ ဖုန်းထဲတွင် အလိုလျှောက်ရောက်ရှိလာမှာဖြစ်ပါတယ်၊ စကားလုံးများရှာဖွေခြင်းအတွက် English ဖြင့်သော်လည်းကောင်း မြန်မာစာဖြင့်သော်လည်းကောင်း အသုံးပြုပြီး ရှာဖွေနိုင်ပါသည်။ Server မှ  data အသစ်များကိုရယူရန်အတွက် Search Icon ဘေးနားမှ Update Icon ကိုနှိပ်ပြီး ရယူနိုင်ပါသည်။";



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        return await  Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: HomeApp()));
    },
      child: MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(_title),
          leading: IconButton(
            onPressed: (){
              Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: HomeApp()));
            },
            icon: Icon(Icons.arrow_back),
          ),
          bottom: PreferredSize(
            child: Text(_subTitle, style: TextStyle( color: Colors.white70),),
            preferredSize: Size.fromHeight(20),
          ),

        ),

        body: Container(
            padding: EdgeInsets.only(left: 20, right: 20, top: 10),
            child: Text(_readMeBody, textAlign: TextAlign.justify,)
        ),

      ),
      )
    );
  }
}
