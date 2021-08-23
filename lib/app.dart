import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simplenote_1/screens/note_list_screen.dart';
import 'data/app_data.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.put(AppData());

    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NoteListScreen(),
    );
  }
}
