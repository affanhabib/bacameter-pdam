import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyHome extends StatefulWidget {
  _MyHome createState() => _MyHome();

  MyHome({this.username});
  final String username;
}

class _MyHome extends State<MyHome> {
  @override
  Widget build(BuildContext context) {
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
                color: Colors.white,
              ),
              ClipPath(
                clipper: MyClipper(),
                child: Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xff2CCFA8), Color(0xff27A1F2)])),
                  child: Container(
                    width: 275,
                    height: 96,
                    margin: EdgeInsets.only(top: 44, left: 30),
                    child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Material(
                            type: MaterialType.transparency,
                            child: Text(
                              "Selamat Datang,",
                              style: TextStyle(
                                  fontFamily: 'Segoe UI',
                                  fontSize: 36.0,
                                  color: Color(0xFFFFFFFF)),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Material(
                            type: MaterialType.transparency,
                            child: Text(
                              widget.username,
                              style: TextStyle(
                                  fontFamily: 'Segoe UI',
                                  fontSize: 36.0,
                                  color: Color(0xFFFFFFFF)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: EdgeInsets.only(top: 140, left: 30, right: 30),
                  width: MediaQuery.of(context).size.width - 60,
                  height: MediaQuery.of(context).size.height * 325 / 640,
                  // color: Colors.black,
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: (MediaQuery.of(context).size.width - 60) / 2,
                        width: MediaQuery.of(context).size.width - 60,
                        // color: Colors.amberAccent,
                        child: Row(
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                Container(
                                  height: MediaQuery.of(context).size.height,
                                  width:
                                      (MediaQuery.of(context).size.width - 70) /
                                          2,
                                  child: RaisedButton(
                                    color: Colors.white,
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/upload');
                                    },
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Icon(
                                      Icons.file_upload,
                                      color: Colors.blueAccent,
                                      size: 75,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: MediaQuery.of(context).size.height,
                                  width:
                                      (MediaQuery.of(context).size.width - 70) /
                                          2,
                                  margin: EdgeInsets.only(bottom: 15),
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Material(
                                      type: MaterialType.transparency,
                                      child: Text(
                                        "Lapor Stand Meter",
                                        style: TextStyle(
                                            fontFamily: 'Helvetica',
                                            fontSize: 16.0,
                                            color: Color(0xff27A1F2)),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(bottom: 20, left: 30, right: 30),
                  width: MediaQuery.of(context).size.width - 60,
                  decoration: BoxDecoration(
                    color: Color(0xFFF92137),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: FlatButton(
                    onPressed: () {
                      // Navigator.pushReplacementNamed(context, '/login');
                      SystemNavigator.pop();
                    },
                    child: Text(
                      "Keluar",
                      style: TextStyle(
                          fontFamily: 'Helvetica',
                          fontSize: 16.0,
                          color: Color(0xFFFFFFFF)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
        size.width / 4, size.height - 100, size.width / 2, size.height - 50);
    path.quadraticBezierTo(size.width - (size.width / 4), size.height,
        size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return null;
  }
}
