import 'package:flutter/material.dart';

class Valid extends StatelessWidget {
// class Valid extends StatefulWidget {
//   _Valid createState() => _Valid();
// }

// class _Valid extends State<Valid> {

  Valid({this.username});
  final String username;

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
                  height: MediaQuery.of(context).size.height / 2,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xff2CCFA8), Color(0xff27A1F2)])),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    left: 30, top: MediaQuery.of(context).size.height / 2),
                width: 275,
                height: 96,
                // color: Colors.black,
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
                              color: Color(0xFF0099FF)),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Material(
                        type: MaterialType.transparency,
                        child: Text(
                          "$username",
                          style: TextStyle(
                              fontFamily: 'Segoe UI',
                              fontSize: 36.0,
                              color: Color(0xFF0099FF)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    left: 30, top: MediaQuery.of(context).size.height * 3 / 4),
                width: 250,
                height: 50,
                // color: Colors.black,
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Material(
                        type: MaterialType.transparency,
                        child: Text(
                          "Bukan Kamu?",
                          style: TextStyle(
                              fontFamily: 'Helvetica',
                              fontSize: 24.0,
                              color: Color(0xFF0099FF)),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Material(
                        type: MaterialType.transparency,
                        child: Text(
                          "Ketuk keluar jika bukan $username",
                          style: TextStyle(
                              fontFamily: 'Helvetica',
                              fontSize: 14.0,
                              color: Color(0xFF0099FF)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(bottom: 60, left: 30, right: 30),
                  height: 40,
                  // color: Colors.black,
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width * 2 / 5,
                        margin: EdgeInsets.only(right: 11.0),
                        // alignment: Alignment.centerLeft,
                        child: FlatButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          child: Text(
                            "Keluar",
                            style: TextStyle(
                                fontFamily: 'Helvetica',
                                fontSize: 16.0,
                                color: Color(0xFF0099FF)),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              side: BorderSide(
                                  color: Color(0xFF27A3EE), width: 2)),
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width * 2 / 5,
                        // alignment: Alignment.centerRight,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Color(0xff2CCFA8), Color(0xff27A1F2)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight),
                            borderRadius: BorderRadius.circular(5)),
                        child: FlatButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/home');
                          },
                          child: Text(
                            "Lanjut",
                            style: TextStyle(
                                fontFamily: 'Helvetica',
                                fontSize: 16.0,
                                color: Color(0xFFFFFFFF)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        )
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
