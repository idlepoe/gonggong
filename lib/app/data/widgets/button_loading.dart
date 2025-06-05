import 'package:flutter/material.dart';

Widget ButtonLoading(){
  return SizedBox(
    width: 20,
    height: 20,
    child: CircularProgressIndicator(
      strokeWidth: 2,
      color: Colors.white,
      strokeCap: StrokeCap.round,
    ),
  );
}