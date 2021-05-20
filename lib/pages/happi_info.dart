import 'package:flutter/material.dart';

class HappiInfoPage extends StatefulWidget {
  @override
  _HappiInfoPageState createState() => _HappiInfoPageState();
}

class _HappiInfoPageState extends State<HappiInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('รายงานความสุขของเจ้าหน้าที่'),
      ),
      body: Center(
        child: Text('Hello Happi'),
      ),
    );
  }
}
