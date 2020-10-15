import 'package:flutter/material.dart';
import 'package:jadwalsolat/model/ResponseJadwal.dart';
import 'package:jadwalsolat/text_style.dart';



class ListJadwal extends StatelessWidget {
  ResponseJadwal data;
  ListJadwal(this.data);
  Widget containerWaltu(String waktu, String jam) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Container(
        padding: EdgeInsets.all(16.0),
        height: 70.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5.0)],
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Color(0xff808080), Color(0xff3fada8)])),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(waktu, style: styleListText),
            Text(jam, style: styleListText)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        containerWaltu(
            'Subuh',
            data.results.datetime[0].times.Fajr.toUpperCase()),
        containerWaltu(
            'Dzuhur',
            data.results.datetime[0].times.Dhuhr.toUpperCase()),
        containerWaltu(
            'Ashar',
            data.results.datetime[0].times.Asr.toUpperCase()),
        containerWaltu(
            'Magrib',
            data.results.datetime[0].times.Maghrib.toUpperCase()),
        containerWaltu(
            'Isya',
            data.results.datetime[0].times.Isha.toUpperCase()),
      ],
    );
  }
}