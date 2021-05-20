import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:login_flutter/pages/AdminPage.dart';
import 'package:login_flutter/pages/MemberPage.dart';
import 'package:login_flutter/pages/happi_info.dart';
import 'package:login_flutter/pages/register.dart';
import 'package:toast/toast.dart';

void main() {
  runApp(MyApp());
}

// เอาไว้รับค่า username ที่ logged in เข้ามา แล้วส่งค่าไปต่อ
String username;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login PHP My Admin',
      home: MyHomePage(),
      routes: <String, WidgetBuilder>{
        // สร้าง route เพื่อกำหนดค่าไปยัง page ต่างๆ
        '/AdminPage': (BuildContext context) => AdminPage(
              // ส่ง username ไปด้วย
              username: username,
            ),
        '/MemberPage': (BuildContext context) => MemberPage(
              // ส่ง username ไปด้วย
              username: username,
            ),
        '/MyHomePage': (BuildContext context) => MyHomePage(),
        '/RegisterPage': (BuildContext context) => RegisterPage(),
        '/Happi_Info': (BuildContext context) => HappiInfoPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController user = new TextEditingController();
  TextEditingController pass = new TextEditingController();

  String msg = "";

  bool _isHidden = true;

  Future<List> _login() async {
    final response = await http.post(
        "http://s61322420115.cs.ubru.ac.th/happinometer/login.php",
        body: {
          "username": user.text,
          "password": pass.text,
        });

    var dataUser = json.decode(response.body);

    if (dataUser.length == 0) {
      // เช็คว่ามีข้อมูลส่งมาหรือไม่
      setState(() {
        //msg = "Login failed";
        FocusScope.of(context).unfocus();
        Toast.show("เข้าสู่ระบบไม่สำเร็จ", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
      });
    } else {
      // เช็คว่า เป็น admin หรือ member ธรรมดา
      // เช็คจาก ฟิลด์ level ใน my_store.admin
      if (dataUser[0]['level'] == 'admin') {
        // pushReplacementNamed จะไม่สามารถกดปุ่มย้อนกลับได้ จนประทั่ง Logout
        Navigator.pushReplacementNamed(context, '/AdminPage');
        //print('welcome admin');
      } else if (dataUser[0]['level'] == 'member') {
        // pushReplacementNamed จะไม่สามารถกดปุ่มย้อนกลับได้ จนประทั่ง Logout
        Navigator.pushReplacementNamed(context, '/MemberPage');
        //print('welcome member');
      }

      setState(() {
        username = dataUser[0]['username'];
      });
    }

    return dataUser;
  }

  void _togglePassword() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Happinometer')),
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
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 25),
                GestureDetector(
                  onTap: () {
                    if (user.text.isEmpty || pass.text.isEmpty) {
                      setState(() {
                        FocusScope.of(context).unfocus();
                        Toast.show("กรุณากรอกข้อมูลให้ครบด้วยครับ", context,
                            duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                      });
                    } else {
                      _login();
                    }
                  },
                  child: Container(
                    width: 200,
                    height: 50,
                    child: Center(
                      child: Text(
                        'เข้าสู่ระบบ',
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('คุณมีบัญชีใช้งานแล้วหรือยัง?'),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => RegisterPage()));
                      },
                      child: Text(
                        'สมัครใช้งาน',
                        style: TextStyle(color: Colors.blue[900]),
                      ),
                    ),
                  ],
                ),
                Text(
                  msg,
                  style: TextStyle(fontSize: 20, color: Colors.red),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
