import 'dart:convert';

import 'package:bacameter/home.dart';
import 'package:bacameter/uploadmeter.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:bacameter/forgot.dart';
import 'package:bacameter/validasi.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

String username = '';
String nosam = '';
String nama = '';
String alamat = '';
String tarif = '';
String wilayah = '';
String jalan = '';
String stan = '';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: MyHomePage(title: 'Flutter Demo Home Page'),
      home: MyHomePage(),
      routes: <String, WidgetBuilder>{
        '/validasi': (BuildContext context) => new Valid(
              username: username,
            ),
        '/login': (BuildContext context) => new MyHomePage(),
        '/home': (BuildContext context) => new MyHome(
              username: username,
            ),
        '/forgot': (BuildContext context) => new MyWave(),
        '/upload': (BuildContext context) => new UploadMeterModel(
              nosam: nosam,
              nama: nama,
              alamat: alamat,
              tarif: tarif,
              wilayah: wilayah,
              jalan: jalan,
              stan: stan,
            )
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var user = new TextEditingController();
  var pass = new TextEditingController();

  String msg = '';
  bool _isHidePassword = true;

  // String generateMd5(var pass) {
  //   return md5.convert(utf8.encode(pass)).toString();
  // }

  Future<List> _datapelanggan() async {
    final responsePelanggan = await http.post(
        "http://36.91.95.245:8084/bacameter_api/getdataPelanggan.php",
        body: {"nosambungan": user.text});
    var userdata = json.decode(responsePelanggan.body);
    setState(() {
      nosam = userdata[0]['nosambungan'];
      nama = userdata[0]['nama'];
      alamat = userdata[0]['alamat'];
      tarif = userdata[0]['idtarif'];
      wilayah = userdata[0]['idwilayah'];
      jalan = userdata[0]['idjalan'];
    });
    return userdata;
  }

  Future<List> _datastan() async {
    final responseStan = await http.post(
        "http://36.91.95.245:8084/bacameter_api/getStan.php",
        body: {"nosambungan": user.text});
    var datastan = json.decode(responseStan.body);
    setState(() {
      stan = datastan[0]['stan'];
    });
    return datastan;
  }

  Future<List> _login() async {
    final response = await http.post(
        "http://36.91.95.245:8084/bacameter_api/login.php",
        body: {"nosambungan": user.text, "password": pass.text});

    var datauser = json.decode(response.body);

    if (datauser.length == 0) {
      setState(() {
        msg = 'Login gagal';
      });
    } else {
      _datastan();
      _datapelanggan();

      Navigator.pushReplacementNamed(context, '/validasi');
      setState(() {
        username = datauser[0]['username'];
      });
    }
    return datauser;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xff27A1F2), Color(0xff2CCFA8)])),
              ),
              Container(
                width: double.infinity,
                height: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height * 1 / 4,
                      width: MediaQuery.of(context).size.width * 1 / 4,
                      child: Image.asset(
                        'assets/Logo.png',
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 60,
                      height: 40,
                      child: Material(
                        type: MaterialType.transparency,
                        child: Form(
                          child: TextFormField(
                            controller: user,
                            textAlignVertical: TextAlignVertical.bottom,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Masukkan No Sambung';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'No Sambungan',
                              fillColor: Color(0xFFE8EAF3),
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                    color: Color(0xFFE8EAF3),
                                  )),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                    color: Color(0xFFE8EAF3),
                                  )),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 60,
                      margin: EdgeInsets.only(top: 20),
                      height: 40,
                      child: Material(
                        type: MaterialType.transparency,
                        child: Form(
                          child: TextFormField(
                            controller: pass,
                            textAlignVertical: TextAlignVertical.bottom,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Masukkan Password';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                hintText: 'Password',
                                fillColor: Color(0xFFE8EAF3),
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                      color: Color(0xFFE8EAF3),
                                    )),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                      color: Color(0xFFE8EAF3),
                                    )),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isHidePassword = !_isHidePassword;
                                    });
                                  },
                                  child: Icon(
                                    _isHidePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: _isHidePassword
                                        ? Colors.grey
                                        : Colors.blue,
                                  ),
                                )),
                            obscureText: _isHidePassword,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 25),
                      child: Material(
                        type: MaterialType.transparency,
                        child: Text(
                          msg,
                          style: TextStyle(
                              fontFamily: 'Helvetica',
                              fontSize: 16.0,
                              color: Colors.red),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: EdgeInsets.only(top: 60, left: 30, right: 30),
                        width: MediaQuery.of(context).size.width - 60,
                        child: FlatButton(
                          onPressed: () {
                            _login();
                          },
                          child: Text(
                            "Masuk",
                            style: TextStyle(
                                fontFamily: 'Helvetica',
                                fontSize: 16.0,
                                color: Colors.white),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              side: BorderSide(color: Colors.white, width: 1)),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/forgot');
                        },
                        child: Material(
                          type: MaterialType.transparency,
                          child: Text(
                            "Lupa Password?",
                            style: TextStyle(
                                fontFamily: 'Helvetica',
                                fontSize: 12.0,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
