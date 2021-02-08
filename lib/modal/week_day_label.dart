import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget WeekDay(String day, bool status) {
  return Container(
    alignment: Alignment.center,
    height: 25,
    width: 25,
    decoration: BoxDecoration(
        color: status ? Colors.blueAccent :Colors.grey[300],
        borderRadius: BorderRadius.circular(100)
    ),
    child: Text(
      day,
      style: GoogleFonts.nunito(
          textStyle: TextStyle(
              color: status ? Colors.white : Colors.black,
              fontSize: 12
          )
      ),
    ),
  );
}