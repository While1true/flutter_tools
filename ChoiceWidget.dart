
import 'package:flutter/material.dart';

typedef _SelectedWidgetBuilder(BuildContext context,dynamic action);

class ChoiceWidget extends StatefulWidget{
  _SelectedWidgetBuilder builder;
  Key key;
  ChoiceWidget(@required this.key,@required this.builder):super(key:key);
  @override
  State<StatefulWidget> createState()=>ChoiceWidgetState();

}
class ChoiceWidgetState extends State<ChoiceWidget>{
  dynamic action;
  @override
  Widget build(BuildContext context) =>widget.builder(context,action);

  void changeState(action){
    this.action=action;
    if(mounted){
      setState(() {

      });
    }
  }

}
