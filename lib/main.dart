import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'header_content.dart';
import 'list_jadwal.dart';
import 'model/ResponseJadwal.dart';

// dap baru ngerti gww/ itu salah karena package model beserta isinya gw copy bukan dari json/ok// ajarin gw cara dapetin jsonnya daff

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jadwal Sholat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomeScreen(),
    );
  }
}

class MyHomeScreen extends StatefulWidget {
  @override
  _MyHomeScreenState createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  TextEditingController _locationController = TextEditingController();

  Future<ResponseJadwal> getJadwal({String location}) async {
    String url = 'https://api.pray.zone/v2/times/today.json?city=$location&school=9';
    final response = await http.get(url);
    final jsonResponse = json.decode(response.body);

    return ResponseJadwal.fromJsonMap(jsonResponse);
  }

  @override
  void initState() {
    if (_locationController.text.isEmpty || _locationController.text == null){
      _locationController.text = 'Depok';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var header = Stack(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.width - 120,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0)),
              boxShadow: [
                BoxShadow(
                  blurRadius: 6,
                  offset: Offset(0.0, 2.0),
                  color: Colors.black26,
                ),
              ],
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                    'https://i.pinimg.com/originals/f6/4a/36/f64a368af3e8fd29a1b6285f3915c7d4.jpg'),
              )),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Tooltip(
                message: 'Ubah Lokasi',
                child: IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.location_on),
                    onPressed: () {
                      _showDialogLocation(context);
                    }),
              ),
            ],
          ),
        ),
        FutureBuilder(
          future: getJadwal(location: _locationController.text.toLowerCase().toString()),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return HeaderContent (snapshot.data);
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Data tidak tersedia',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              );
            }

            return Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              ),
            );
          },
        )
      ],
    );
    final body = Expanded(
      child: FutureBuilder(
          future: getJadwal(
              location: _locationController.text.toLowerCase().toString()),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListJadwal(snapshot.data);
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return Center(child: Text('Data tidak tersedia'));
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
    return Scaffold(
      body: Column(
        children: <Widget>[header, body],
      ),
    );
  }

  _showDialogLocation(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Ubah Lokasi'),
            content: TextField(
              controller: _locationController,
              decoration: InputDecoration(hintText: 'Lokasi'),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Batal')),
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context, () {
                      setState(() {
                        getJadwal(
                            location: _locationController.text
                                .toLowerCase()
                                .toString());
                      });
                    });
                  },
                  child: Text('Ok')
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
          );
        });
  }
}
