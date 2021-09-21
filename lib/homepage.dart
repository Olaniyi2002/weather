import 'dart:convert';

import"package:flutter/material.dart";
import 'package:http/http.dart' as http;

    class HomePage extends StatefulWidget {
      const HomePage({Key key}) : super(key: key);
    
      @override
      _HomePageState createState() => _HomePageState();
    }



    class _HomePageState extends State<HomePage> {

      var temp, cal, num1;
      String cloud="";
      var wind,humid, feel;
      var icon="";
      var press;


      Future getWeather() async{
        http.Response response =await http.get("https://api.openweathermap.org/data/2.5/weather?q=Boston&units=imperial&appid=210c2f9f36016aebc154a84c906f31f1");
        var results= jsonDecode(response.body);
        setState(() {
          this.cloud=results["weather"][0]["description"];
          this.wind=results["wind"]["speed"];
          this.humid=results['main']["humidity"];
          this.press= results['main']['pressure'];
          this.feel=results['main']["feels_like"];
          this.temp=results['main']["temp"];
         this.icon = "http://openweathermap.org/img/w/" + results["weather"][0]["icon"] +".png";

         cal= (temp-32)*5/9;
         num1 = double.parse((cal).toStringAsFixed(1));
        });
      }

      @override
      void initState(){
        super.initState();
        this.getWeather();

      }

      Widget build(BuildContext context) {
        return Scaffold(
          backgroundColor: Colors.lightBlue[100],
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.menu),
                      Text("Weather", style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),),
                      Icon(Icons.notifications_none),
                    ],),
                ),
                Text("Boston, USA",
                  style: TextStyle(fontSize: 15, color: Colors.black26),),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.network(icon,scale: 0.2,),

                      Text(cloud.toUpperCase(),style: TextStyle(fontSize: 20, color: Colors.black),),
                      Text(num1 != null
                          ? num1.toString() + "\u2103"
                          : "loading...",
                        style: TextStyle(fontSize: 40, color: Colors.black),),
                      Container(
                        height: 100,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                box("Wind","N "+wind.toString()+" mph"),
                                box("Humidity",humid.toString()+"\u2105"),
                                box("Feels Like",feel.toString()+"\u2103"),
                                box("Pressure",press.toString()+" pas")

                              ],
                            ),

                          ],
                        ),
                      ),

                    ],),
                )
              ],
            ),
          ),
        );
      }

      Padding box(String text,String sub,){
       return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(height:100 ,width: 100,
            child: Center(child: Padding(
              padding: const EdgeInsets.only(top:30.0),
              child: Column(
                children: [
                  Text(text),
                  Text(sub)
                ],
              ),
            )),
            decoration: BoxDecoration(
            color: Colors.white,

            border: Border.all(width: 0,color: Colors.white),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                spreadRadius: 3,
                blurRadius:3,
                offset: Offset(0, 2),
              )
            ]
          ),),
        );
      }
    }
    