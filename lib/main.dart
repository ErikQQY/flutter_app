import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tex/flutter_tex.dart';

import 'number.dart';
import 'operator.dart';
import 'result.dart';

void main() =>  runApp(new MyApp()); //运行app


//Stateless即是状态不需要改变，其没有要管理的内部
//主对象APP
class MyApp extends StatelessWidget{
  //程序重写
  @override
  //我的理解：显示字符串BuildContext
  Widget build(BuildContext context){
    //返回一个Cupertino型的app，当然，还有。。。。。。。
    return CupertinoApp(
      //设定相应的参数，title标题，debugShowCheckModeBanner->设定为false，app的相应主界面home即为CalculatorPage，(用户界面)这个即是后面要构造的主对象！！！！！

      title:"Flutter Calculator",
      debugShowCheckedModeBanner: false,
      home: CalculatorPage(),
    );
  }


  // @override
  // void initState(){
  //   super.initState();
  //   SystemChrome.setPreferredOrientations([
  //     DeviceOrientation.landscapeRight,
  //     DeviceOrientation.landscapeLeft,
  //   ]);
  // }
}

//接下来即是创建用户界面对象-》是可以改变状态的widget
class CalculatorPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => CalculatorState();
}

class CalculatorState extends State<StatefulWidget>{
  List<Result> results=[];
  String currentDisplay='0';
////////////////////////////////////////////////////////////////////////////////////
//创建按下数字键和按下操作符键的函数

  onResultButtonPressed(display){
    if(results.length>0){
      var result=results[results.length-1];
      if(display=='='){
        result.result=result.oper.calculate(
          double.parse(result.firstNum),double.parse(result.secondNum));
      }else if(display=='C'){
        results.removeLast();
      }
    }
    pickCurrentDisplay();
  }

  //操作键按下
  onOperatorButtonPressed(Operator oper){
    if(results.length>0){
      var result=results[results.length-1];
      if(result.result!=null){
        var newRes=Result();
        newRes.firstNum=currentDisplay;
        newRes.oper=oper;
        results.add(newRes);

      }else if(result.firstNum !=null){
        result.oper=oper;
      }
    }
    pickCurrentDisplay();
  }

  //数字按键按下
  onNumberButtonPressed(Number number){
    var result=results.length>0?results[results.length-1]:Result();
    if(result.firstNum==null||result.oper==null){
      result.firstNum=number.apply(currentDisplay);
    }else if(result.result==null){
      if(result.secondNum==null){
        currentDisplay='0';
      }
      result.secondNum=number.apply(currentDisplay);
    }else{
      var newRes=Result();
      currentDisplay='0';
      newRes.firstNum=number.apply(currentDisplay);
      results.add(newRes);
    }
    if(results.length==0){
      results.add(result);
    }
    pickCurrentDisplay();
  }

  pickCurrentDisplay(){
    this.setState(() {
      var display='0';
      results.removeWhere((item) => item.firstNum==null && item.oper==null && item.secondNum==null);
      if(results.length>0){
        var result=results[results.length-1];
        if(result.result!=null){
          display=format(result.result);
        }else if(result.secondNum!=null&&result.oper!=null){
          display=result.secondNum;
        }else if(result.firstNum!=null){
          display=result.firstNum;
        }
      }
      currentDisplay=display;
    });
  }

  String format(num number){
    if(number==number.toInt()){
      return number.toInt().toString();
    }
    return number.toString();
  }

  @override
  Widget build(BuildContext context){
    return CupertinoPageScaffold(
      child: Container(
        color: Colors.grey[100],
        child: Column(
          children: <Widget>[

            Expanded(
              key: Key('Current_Display'),
              flex: 2,
              child: FractionallySizedBox(
                widthFactor: 1.0,
                heightFactor: 1.0,
                child: Container(
                  color: Colors.lightBlue[300],
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(16.0),
                  child: ResultDisplay(result:currentDisplay),
                ),
              ),
            ),

            Expanded(
              key:Key('History_Display'),
              child: FractionallySizedBox(
                widthFactor: 1.0,
                heightFactor: 1.0,
                child: Container(
                  color: Colors.black54,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    children:results.reversed.map((result){
                      return HistoryBlock(result:result);
                    }).toList()),
                )),
              flex:1
            ),
            Expanded(
              key:Key('Number_Button_Line_1'),
              child: NumberButtonLine(
                array:[
                  NormalNumber('1'),
                  NormalNumber('2'),
                  NormalNumber('3')
                ],
                onPress:onNumberButtonPressed,
              ),
              flex:1
            ),

            Expanded(
                key:Key('Number_Button_Line_2'),
                child: NumberButtonLine(
                  array:[
                    NormalNumber('4'),
                    NormalNumber('5'),
                    NormalNumber('6')
                  ],
                  onPress:onNumberButtonPressed,
                ),
                flex:1
            ),

            Expanded(
                key:Key('Number_Button_Line_3'),
                child: NumberButtonLine(
                  array:[
                    NormalNumber('7'),
                    NormalNumber('8'),
                    NormalNumber('9')
                  ],
                  onPress:onNumberButtonPressed,
                ),
                flex:1
            ),

            Expanded(
                key:Key('Number_Button_Line_4'),
              child: NumberButtonLine(
                array:[SymbolNumber(),NormalNumber('0'),DecimalNumber()],
                onPress: onNumberButtonPressed,
              ),
              flex:1
            ),

            Expanded(
                key: Key('Operator_Group'),
                child: OperatorGroup(onOperatorButtonPressed),
                flex: 1),

            Expanded(
                key: Key('Result_Button_Area'),
                child: Row(
                  children: <Widget>[
                    ResultButton(
                      display: 'C',
                      color: Colors.red,
                      onPress: onResultButtonPressed,
                    ),
                    ResultButton(
                        display: '=',
                        color: Colors.green,
                        onPress: onResultButtonPressed),
                  ],
                ),
                flex: 1)

          ],
        )),
    );
  }







}





