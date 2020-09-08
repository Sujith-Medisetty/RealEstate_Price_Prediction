import 'package:flutter/material.dart';
import 'package:houseprediction/predictionBloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  Future<Album> futureAlbum;
  var predictedPrice;
  var capture;
  double capture1;
 predictionBloc bloc1=predictionBloc();
  List<dynamic> list1=[];
  @override
  void initState() {
    super.initState();

    futureAlbum = fetchAlbum();
  }


  String dropdownValue="1st block jayanagar";
  TextEditingController area = TextEditingController();

  TextEditingController bedrooms = TextEditingController();

  TextEditingController bathrooms = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(60),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child:  FutureBuilder<Album>(
        future:futureAlbum,
        builder:(context,snapshot){
          if(snapshot.hasData){
            final jsonDecoded123=snapshot.data.locations;
            list1=jsonDecoded123;
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                      child:Column(
                        children: [
                          Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width/1.7,
                                child: TextField(
                                  controller: area,
                                  decoration: InputDecoration(
                                      hintText: 'Area (Sqfeet)'
                                  ),
                                ),
                              ),
                              SizedBox(height: 60,),
                              Container(
                                width: MediaQuery.of(context).size.width/1.7,
                                child: TextField(
                                  controller: bedrooms,
                                  decoration: InputDecoration(
                                      hintText: 'Bed Rooms'
                                  ),
                                ),
                              ),
                              SizedBox(height: 60,),
                              Container(
                                width: MediaQuery.of(context).size.width/1.7,
                                child: TextField(
                                  controller: bathrooms,
                                  decoration: InputDecoration(
                                      hintText: 'Bath Rooms'
                                  ),
                                ),
                              ),
                              SizedBox(height: 60,),
                              Container(
                                  width: MediaQuery.of(context).size.width/1.7,
                                  child:Container(
                                    child:  DropdownButton<String>(
                                      value: dropdownValue,
                                      underline: Container(
                                          height: 2,
                                          color: Colors.white30
                                      ),
                                      onChanged: (String newValue) {
                                        setState(() {
                                          dropdownValue = newValue;
                                        });
                                      },

                                      items: list1
                                          .map<DropdownMenuItem<String>>((dynamic value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Row(children: [ Icon(Icons.location_on),Text(" "+value)]),
                                        );
                                      }).toList(),
                                    ),
                                  )
                              ),
                              SizedBox(height: 60,),
                              MaterialButton(

                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                  child: Text('Estimate Price'),
                                  color: Colors.pink,
                                  elevation: 30.0 ,
                                  splashColor: Colors.white,

                                  onPressed: (){
                                    setState(() {
                                      var area1=area.text;
                                      var bedrooms1=bedrooms.text;
                                      var bathrooms1=bathrooms.text;
                                      var dropdownValues1=dropdownValue;
                                      bloc1.add(onPress(area1,bedrooms1,bathrooms1,dropdownValues1));
                                    });


                                  }),
                              BlocBuilder(
                              bloc: bloc1,
                              builder: (context,state){
                                if(state is returnData){
                                 var text1=state.price;
                                 text1=text1['estimated_price'];
                                 capture=text1;
                                 bloc1.add(initial());
                                 capture1 = double.parse((capture).toStringAsFixed(0));
                                return  Container(child: Text(""),margin: EdgeInsets.all(20),);
                                }
                                else{
                                  if(capture==null){
                                    return Container(child: Text(""),margin: EdgeInsets.all(20),);
                                  }
                                  return  Container(child: Text("Amount required to buy a new house is ₹ "+capture1.toString()+"00000 ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30,color: Colors.white70),),margin: EdgeInsets.all(20),);
                                }
                               }
                              ),

                            ],
                          )
                        ],
                      )
                  ),
                )
              ],
            );
          }else{
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("LOADING...",style: TextStyle(fontWeight:FontWeight.bold,fontSize: 30),),
                        SizedBox(height: 30,),
                        CircularProgressIndicator()
                      ],
                    )
                ),
              ),
            );
          }

        },

      ),
    );
  }

  Future<Album> fetchAlbum() async {
    final response = await http.get('http://127.0.0.1:5000/get_location_names');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Album.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }


}



class Album {
final locations;

  Album({this.locations});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      locations:json['locations']
    );
  }
}



