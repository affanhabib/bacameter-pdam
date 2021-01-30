import 'package:flutter/material.dart';

class MyWave extends StatefulWidget {
  _MyWave createState() => _MyWave();
}

class _MyWave extends State<MyWave> {
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
                // width: MediaQuery.of(context).size.width,
                // height: MediaQuery.of(context).size.height,
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
                    margin: EdgeInsets.only(top: 44, left: 30, right: 150),
                    child: Material(
                      type: MaterialType.transparency,
                      child: Text(
                        "Lupa Password?",
                        style: TextStyle(
                            fontFamily: 'Segoe UI',
                            fontSize: 36.0,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                      child: Image.asset(
                        'assets/Untitled-2.png',
                        // fit: BoxFit.contain,
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.height * 0.5,
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                bottom: 125,
                left: 30,
                right: 65,
                child: Material(
                  type: MaterialType.transparency,
                  child: Text(
                    "Datangi Petugas kami di Kantor PDAM Tirta Taman Sari Kota Madiun untuk mengubah password",
                    style: TextStyle(
                        fontFamily: 'Helvetica',
                        fontSize: 16.0,
                        color: Color(0xFF6E6C6C)),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(bottom: 60, left: 30, right: 30),
                  // width: MediaQuery.of(context).size.width * 300 / 360,
                  width: MediaQuery.of(context).size.width - 60,
                  child: FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "OK",
                      style: TextStyle(
                          fontFamily: 'Helvetica',
                          fontSize: 16.0,
                          color: Color(0xFF0099FF)),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: BorderSide(color: Color(0xFF27A3EE), width: 2)),
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
