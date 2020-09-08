import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class predictEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class onPress extends predictEvent{
var area;
var bedrooms;
var bathrooms;
var location;
onPress(this.area,this.bedrooms,this.bathrooms,this.location);
}
class initial extends predictEvent{

}

class predictState extends Equatable{
  @override
  List<Object> get props =>[];
}

class notPressed extends predictState{

}

class returnData extends predictState{
var price;
returnData(this.price);
}

class predictionBloc extends Bloc<predictEvent,predictState>{
  @override
  // TODO: implement initialState
  predictState get initialState =>notPressed();

  @override
  Stream<predictState> mapEventToState(predictEvent event) async*{
if(event is onPress){
  var data = await http.Client().post('http://127.0.0.1:5000/predict_home_price', body: {
    'total_sqft':event.area,
    'location':event.location,
    'bhk':event.bedrooms,
    'bath':event.bathrooms
  });

final jsonDecoded1234=json.decode(data.body);
yield returnData(jsonDecoded1234);

}else{
  yield notPressed();
}
  }
}