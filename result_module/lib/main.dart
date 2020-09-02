import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:result_module/res/color.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Result',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const platform = const MethodChannel('com.souvikbiswas.tipsy/result');

  String splitAmount = '';
  int personCount = 0;
  int percent = 0;

  Future<void> _receiveFromHost(MethodCall call) async {
    var jData;

    try {
      print(call.method);

      if (call.method == "getCalculatedResult") {
        final String data = call.arguments;
        print(call.arguments);
        jData = await jsonDecode(data);
      }
    } on PlatformException catch (error) {
      print(error);
    }

    setState(() {
      splitAmount = jData['amount'];
      personCount = jData['count'];
      percent = jData['percent'];
    });
  }

  @override
  void initState() {
    platform.setMethodCallHandler(_receiveFromHost);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                height: screenHeight * 0.3,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      'Total per person',
                      style: TextStyle(fontSize: 28),
                    ),
                    SizedBox(height: 20),
                    Text(
                      splitAmount,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: CustomColor.primaryDark,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  color: CustomColor.primaryLight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            'Split between $personCount people with $percent% tip',
                            style:
                                TextStyle(fontSize: 24, color: Colors.black54),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: double.maxFinite,
                          child: RaisedButton(
                            onPressed: () {
                              SystemNavigator.pop();
                            },
                            color: CustomColor.primaryDark,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'RECALCULATE',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              // Text(splitAmount),
              // Text(personCount.toString()),
              // Text(percent.toString())
            ],
          ),
        ),
      ),
    );
  }
}
