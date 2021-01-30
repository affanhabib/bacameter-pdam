import 'dart:io';
import 'dart:convert';
import 'package:bacameter/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
// import 'package:path/path.dart' as path;
import 'package:geolocator/geolocator.dart';

class UploadMeterModel extends StatefulWidget {
  _UploadMeter createState() => _UploadMeter();
  UploadMeterModel(
      {this.nosam,
      this.nama,
      this.alamat,
      this.tarif,
      this.wilayah,
      this.jalan,
      this.stan});

  final String nosam;
  final String nama;
  final String alamat;
  final String tarif;
  final String wilayah;
  final String jalan;
  final String stan;
}

class _UploadMeter extends State<UploadMeterModel> {
  File imageFile;
  var tanggal = DateFormat.yMMMM().format(DateTime.now());
  var stanskrg = new TextEditingController();
  int pakai = 0;
  String _valCatatan;
  List<dynamic> _catatan = List();
  bool isUploaded;

  void cekUpload() async {
    final response = await http
        .post("http://36.91.95.245:8084/bacameter_api/cekupload.php", body: {
      "nosambungan": widget.nosam,
      "bulan": DateTime.now().month,
      "tahun": DateTime.now().year
    });

    var dataupload = json.decode(response.body);

    setState(() {
      isUploaded = (dataupload.length == 0);
    });
  }

  void getCatatan() async {
    final response =
        await http.get("http://36.91.95.245:8084/bacameter_api/getCatatan.php");

    var listdata = json.decode(response.body);

    setState(() {
      _catatan = listdata;
    });
  }

  @override
  void initState() {
    super.initState();
    getCatatan();
    cekUpload();
  }

  _openGallary(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = picture;
    });
    Navigator.of(context).pop();
  }

  _openCamera(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      imageFile = picture;
    });
    Navigator.of(context).pop();
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Pilih Foto"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text("Galeri"),
                    onTap: () {
                      _openGallary(context);
                    },
                  ),
                  Padding(padding: EdgeInsets.all(8.0)),
                  GestureDetector(
                    child: Text("Kamera"),
                    onTap: () {
                      _openCamera(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _decideImageView() {
    if (imageFile == null) {
      return Text("Tidak ada foto yang dipilih");
    } else {
      return Image.file(imageFile,
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.height * 0.5
          // width: 200,
          // height: 200,
          );
    }
  }

  void _cekangka() async {
    int angkalalu = int.parse(widget.stan);
    int angkaskrg = int.parse(stanskrg.text);

    if (angkaskrg < 0) {
      setState(() {
        angkaskrg = 0;
      });
    }

    (angkaskrg != null)
        ? setState(() {
            pakai = angkaskrg - angkalalu;
          })
        : setState(() {
            pakai = 0;
          });
  }

  Widget _pakai() {
    _cekangka();
    return Text("$pakai");
  }

  Future isDataNotExist(stanskrg, _valCatatan, imageFile) async {
    return (stanskrg && _valCatatan && imageFile);
  }

  Future upload(File imageFile) async {
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var uri = Uri.parse('http://36.91.95.245:8084/bacameter_api/upload.php');

    String date = DateFormat.y().format(DateTime.now());
    String bulan = DateFormat.M().format(DateTime.now());
    String nosam = widget.nosam;
    // String namaFile = '$date$bulan-$nosam.jpg';
    String namaFile = '';
    String month = '';

    if (int.parse(bulan) < 10) {
      setState(() {
        month = '0$bulan';
        namaFile = '$date$month-$nosam.jpg';
      });
    } else {
      namaFile = '$date$month-$nosam.jpg';
    }

    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    var request = new http.MultipartRequest("POST", uri);

    // var multipartfile = new http.MultipartFile("image", stream, length,
    //     filename: path.basename(imageFile.path));
    var multipartfile =
        new http.MultipartFile("image", stream, length, filename: namaFile);
    request.fields['bulan'] = month;
    request.fields['tahun'] = date;
    request.fields['nosambungan'] = widget.nosam;
    request.fields['tglbaca'] = DateTime.now().toString();
    request.fields['idtarif'] = widget.tarif;
    request.fields['idwilayah'] = widget.wilayah;
    request.fields['idjalan'] = widget.jalan;
    request.fields['stan'] = stanskrg.text;
    request.fields['pakai'] = pakai.toString();
    request.fields['idcatatan'] = _valCatatan;
    request.fields['lat'] = position.latitude.toString();
    request.fields['lon'] = position.longitude.toString();
    request.fields['stanlalu'] = widget.stan;
    request.files.add(multipartfile);

    var response = await request.send();

    if (response.statusCode == 200) {
      print("Sukses");
      print(stanskrg.text);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Berhasil!"),
              content: SingleChildScrollView(
                  child: Text("Telah berhasil upload foto")),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, "/home");
                    },
                    child: Text("OK"))
              ],
            );
          });
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Upload gagal!"),
              content: SingleChildScrollView(child: Text("Coba lagi nanti")),
            );
          });
      print("gagal");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Foto Stand Meter"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xff2CCFA8), Color(0xff27A1F2)])),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 3 / 4,
                  height: 50,
                  padding: EdgeInsets.only(
                    left: 30,
                  ),
                  // color: Colors.black,
                  child: Text(
                    "$tanggal",
                    style: TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: 24.0,
                        color: Color(0xFF0099FF)),
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                      height: 30,
                      padding: EdgeInsets.only(left: 30, top: 5),
                      child: Text("No Sambung"),
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width * 2 / 3,
                        height: 30,
                        padding: EdgeInsets.only(right: 30, bottom: 5),
                        child: Row(
                          children: <Widget>[Text(": "), Text(widget.nosam)],
                        ))
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                      height: 30,
                      padding: EdgeInsets.only(left: 30, top: 5),
                      child: Text("Nama"),
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width * 2 / 3,
                        height: 30,
                        padding: EdgeInsets.only(right: 30, bottom: 5),
                        child: Row(
                          children: <Widget>[Text(": "), Text(widget.nama)],
                        ))
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                      height: 30,
                      padding: EdgeInsets.only(left: 30, top: 5),
                      child: Text("Alamat"),
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width * 2 / 3,
                        height: 30,
                        padding: EdgeInsets.only(right: 30, bottom: 5),
                        child: Row(
                          children: <Widget>[Text(": "), Text(widget.alamat)],
                        ))
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                      height: 30,
                      padding: EdgeInsets.only(left: 30, top: 5),
                      child: Text("Tarif/Jalan"),
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width * 2 / 3,
                        height: 30,
                        padding: EdgeInsets.only(right: 30, bottom: 5),
                        child: Row(
                          children: <Widget>[
                            Text(": "),
                            Text(widget.tarif),
                            Text("/"),
                            Text(widget.wilayah),
                            Text("-"),
                            Text(widget.jalan)
                          ],
                        ))
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                      height: 30,
                      padding: EdgeInsets.only(left: 30, top: 5),
                      child: Text("Stan Lalu"),
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width * 2 / 3,
                        height: 30,
                        padding: EdgeInsets.only(right: 30, bottom: 5),
                        child: Row(
                          children: <Widget>[Text(": "), Text(widget.stan)],
                        ))
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                      height: 30,
                      padding: EdgeInsets.only(left: 30, top: 5),
                      child: Text("Stan"),
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width * 2 / 3,
                        height: 30,
                        padding: EdgeInsets.only(right: 30, top: 5),
                        child: Row(
                          children: <Widget>[
                            Text(": "),
                            Container(
                              width: MediaQuery.of(context).size.width / 4,
                              height: 10,
                              padding: EdgeInsets.only(right: 30, bottom: 5),
                              child: Material(
                                type: MaterialType.transparency,
                                child: Form(
                                    child: TextFormField(
                                  controller: stanskrg,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    WhitelistingTextInputFormatter.digitsOnly
                                  ],
                                  style: TextStyle(fontSize: 14),
                                )),
                              ),
                            )
                          ],
                        ))
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                      height: 30,
                      padding: EdgeInsets.only(left: 30, top: 5),
                      child: Text("Pakai"),
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width * 2 / 3,
                        height: 30,
                        padding: EdgeInsets.only(right: 30, bottom: 5),
                        child: Row(
                          children: <Widget>[Text(": "), _pakai()],
                        ))
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                      height: 30,
                      padding: EdgeInsets.only(left: 30, top: 5),
                      child: Text("Catatan"),
                    ),
                    Container(
                        // width: MediaQuery.of(context).size.width * 2 / 3,
                        width: 240,
                        height: 40,
                        padding: EdgeInsets.only(bottom: 5),
                        child: Row(
                          children: <Widget>[
                            // Text(": "),
                            DropdownButton(
                                hint: Text("Pilih Catatan"),
                                value: _valCatatan,
                                items: _catatan.map((item) {
                                  return DropdownMenuItem(
                                    child: Text(item['keterangan']),
                                    value: item['keterangan'],
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _valCatatan = value;
                                  });
                                })
                          ],
                        )),
                  ],
                ),
              ],
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                      height: 210,
                      width: MediaQuery.of(context).size.width,
                      child: Align(
                        alignment: Alignment.center,
                        child: _decideImageView(),
                      )),
                  Container(
                    width: MediaQuery.of(context).size.width - 60,
                    child: FlatButton(
                      onPressed: () {
                        _showChoiceDialog(context);
                      },
                      child: Icon(
                        Icons.photo_camera,
                        color: Color(0xFF27A3EE),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: BorderSide(color: Color(0xFF27A3EE), width: 1)),
                    ),
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(left: 30, right: 30),
                width: MediaQuery.of(context).size.width - 60,
                child: FlatButton(
                  onPressed: () {
                    int tanggalawalupload = 3;
                    int tanggalakhirupload = 21;
                    if (tanggalawalupload < DateTime.now().day &&
                        DateTime.now().day < tanggalakhirupload) {
                      if (isDataNotExist(
                              stanskrg.text, _valCatatan, imageFile) ==
                          null) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Perhatian!"),
                                content: SingleChildScrollView(
                                    child: Text(
                                        "Harap mengisi data dengan benar")),
                              );
                            });
                      } else {
                        if (!isUploaded) {
                          upload(imageFile);
                        } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Perhatian!"),
                                  content: SingleChildScrollView(
                                      child:
                                          Text("Telah melakukan upload foto")),
                                  actions: <Widget>[
                                    FlatButton(
                                        onPressed: () {
                                          Navigator.pushReplacementNamed(
                                              context, "/home");
                                        },
                                        child: Text("OK"))
                                  ],
                                );
                              });
                        }
                      }
                    } else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Perhatian!"),
                              content: SingleChildScrollView(
                                  child: Text(
                                      "Telah melebihi batas waktu upload foto")),
                            );
                          });
                    }
                  },
                  child: Text(
                    "Upload",
                    style: TextStyle(
                        fontFamily: 'Helvetica',
                        fontSize: 16.0,
                        color: Color(0xFF27A3EE)),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: BorderSide(color: Color(0xFF27A3EE), width: 1)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
