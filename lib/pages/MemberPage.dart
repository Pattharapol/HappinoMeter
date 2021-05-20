import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:login_flutter/pages/happi_info.dart';
import 'package:toast/toast.dart';

class MemberPage extends StatefulWidget {
  // สร้าง Constuctor มารับค่า username ที่จะส่งมา
  MemberPage({this.username});

  final String username;

  @override
  _MemberPageState createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {
  int _score = 0;
  String _reason = "";

  void _increment() {
    setState(() {
      _score++;
      if (_score >= 2) {
        _score = 2;
      }
    });
  }

  void _decrement() {
    setState(() {
      _score--;
      if (_score <= -2) {
        _score = -2;
      }
    });
  }

  Future _showMyDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ยืนยันการบันทึก'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(
                    'คุณ ${widget.username} ต้องการบันทึกคะแนนความสุข ใช่หรือไม่'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('ยืนยัน'),
              onPressed: () {
                _save();
                // print('คะแนนความสุข $_score เหตุผล $_reason');
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future _save() async {
    final response = await http.post(
        "http://s61322420115.cs.ubru.ac.th/happinometer/savescore.php",
        body: {
          "username": widget.username.toString(),
          "score": _score.toString(),
          "reason": _reason.toString(),
        });

    var data = json.decode(response.body);

    if (data == "success") {
      // เช็คว่ามีข้อมูลส่งมาหรือไม่
      setState(() {
        Toast.show("บันทึกสำเร็จ", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.pushReplacementNamed(context, '/Happi_Info');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('มาลงคะแนนความสุขกันเถอะ'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () =>
                // log out แล้วกลับไปหน้า login
                Navigator.pushReplacementNamed(context, '/MyHomePage'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Text(
                  'สวัสดีคุณ ${widget.username}',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    'โปรแกรมนี้ทำขึ้นเพื่อการทดลอง\n เก็บคะแนนความสุขของเจ้าหน้าที่\nโรงพยาบาลโพธิ์ศรีสุวรรณเท่านั้น',
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Card(
                    elevation: 5,
                    margin: EdgeInsets.all(5),
                    child: Container(
                      height: 50,
                      width: 150,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                              onTap: () => _decrement(),
                              child: Icon(Icons.arrow_back_ios_outlined)),
                          Text(
                            '$_score',
                            style: TextStyle(fontSize: 40),
                          ),
                          GestureDetector(
                            onTap: () => _increment(),
                            child: Icon(Icons.arrow_forward_ios_outlined),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _reason = 'การเงิน';
                              _showMyDialog();
                            });
                          },
                          child: _clipRRectWidget(
                              'assets/images/book.png', 'การเงิน'),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _reason = 'สุขภาพ';
                              _showMyDialog();
                            });
                          },
                          child: _clipRRectWidget(
                              'assets/images/book.png', 'สุขภาพ'),
                        ),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                _reason = 'ครอบครัว';
                                _showMyDialog();
                              });
                            },
                            child: _clipRRectWidget(
                                'assets/images/book.png', 'ครอบครัว')),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                _reason = 'ความรัก';
                                _showMyDialog();
                              });
                            },
                            child: _clipRRectWidget(
                                'assets/images/book.png', 'ความรัก')),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                _reason = 'อาหาร';
                                _showMyDialog();
                              });
                            },
                            child: _clipRRectWidget(
                                'assets/images/book.png', 'อาหาร')),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                _reason = 'น้ำใจ';
                                _showMyDialog();
                              });
                            },
                            child: _clipRRectWidget(
                                'assets/images/book.png', 'น้ำใจ')),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                _reason = 'สังคม';
                                _showMyDialog();
                              });
                            },
                            child: _clipRRectWidget(
                                'assets/images/book.png', 'สังคม')),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                _reason = 'งาน';
                                _showMyDialog();
                              });
                            },
                            child: _clipRRectWidget(
                                'assets/images/book.png', 'งาน')),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                _reason = 'ผ่อนคลาย';
                                _showMyDialog();
                              });
                            },
                            child: _clipRRectWidget(
                                'assets/images/book.png', 'ผ่อนคลาย')),
                      ],
                    ),
                  ),
                ),

                // RaisedButton(
                //   child: Text('Log out'),
                //   onPressed: () =>
                //       // log out แล้วกลับไปหน้า login
                //       Navigator.pushReplacementNamed(context, '/MyHomePage'),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _clipRRectWidget(String image, String _reasonText) {
  return ClipRRect(
    // borderRadius: BorderRadius.circular(20),
    child: Column(
      children: [
        Container(
          width: 50,
          height: 50,
          // color: Colors.red[100],
          child: Image.asset(
            image,
            fit: BoxFit.cover,
          ),
        ),
        Text(_reasonText),
      ],
    ),
  );
}
