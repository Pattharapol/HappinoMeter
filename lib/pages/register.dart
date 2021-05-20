import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login_flutter/main.dart';
import 'package:toast/toast.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController user = new TextEditingController();
  TextEditingController pass = new TextEditingController();
  TextEditingController fname = new TextEditingController();
  TextEditingController lname = new TextEditingController();

  bool _isHidden = true;

  void _togglePassword() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  Future _signup() async {
    final response = await http.post(
        "http://s61322420115.cs.ubru.ac.th/happinometer/signup.php",
        body: {
          "username": user.text,
          "password": pass.text,
          "fname": fname.text,
          "lname": lname.text,
        });

    var data = json.decode(response.body);

    if (data == "error") {
      // เช็คว่ามีข้อมูลส่งมาหรือไม่
      setState(() {
        //msg = "Login failed";
        Toast.show("มีชื่อนี้แล้วในระบบ กรุณาเปลี่ยนชื่อผู้ใช้งานใหม่ด้วยครับ",
            context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

        pass.text = "";
        user.text = "";
      });
    }

    if (data == "success") {
      setState(() {
        //msg = "Login failed";
        Toast.show("ลงทะเบียนสำเร็จแล้ว กรุณาเข้าสู่ระบบ", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.pushReplacementNamed(context, '/MyHomePage');
      });
    }
  }

  Future _showMyDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ยืนยันการลงทะเบียน'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('คุณต้องการยืนยันการลงทะเบียน ใช่หรือไม่'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('ยืนยัน'),
              onPressed: () {
                _signup();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Happinometer'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 30),
                Image.asset(
                  'assets/images/book.png',
                  fit: BoxFit.cover,
                  width: 150,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: TextField(
                    controller: user,
                    decoration: InputDecoration(
                      hintText: 'username',
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: TextField(
                    controller: pass,
                    obscureText: _isHidden,
                    decoration: InputDecoration(
                        hintText: 'password',
                        suffix: InkWell(
                          onTap: _togglePassword,
                          child: Icon(Icons.visibility),
                        )),
                  ),
                ),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: TextField(
                    controller: fname,
                    decoration: InputDecoration(
                      hintText: 'first name',
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: TextField(
                    controller: lname,
                    decoration: InputDecoration(
                      hintText: 'last name',
                    ),
                  ),
                ),
                SizedBox(height: 25),
                GestureDetector(
                  onTap: () {
                    if (user.text.length < 3 || pass.text.length < 3) {
                      setState(() {
                        FocusScope.of(context).unfocus();
                        Toast.show(
                            "กรุณาใส่ username และ password ให้ยาวกว่า 3 ตัวอักษร",
                            context,
                            duration: Toast.LENGTH_LONG,
                            gravity: Toast.BOTTOM);
                      });
                    } else if (fname.text.isEmpty || lname.text.isEmpty) {
                      setState(() {
                        FocusScope.of(context).unfocus();
                        Toast.show(
                            "กรุณากรอกชื่อ และ นามสกุล ด้วยครับ", context,
                            duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                      });
                    } else {
                      _showMyDialog();
                      FocusScope.of(context).unfocus();
                    }
                  },
                  child: Container(
                    width: 250,
                    height: 50,
                    child: Center(
                      child: Text(
                        'ลงทะเบียน',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.blue,
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
