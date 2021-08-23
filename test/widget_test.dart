// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:simplenote_1/main.dart';
import 'package:simplenote_1/models/note_model.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    List<NoteModel> _notesForTest = [
      NoteModel(id: '1', isTodoNote: true, dateCreated: DateTime.now()),
      NoteModel(id: '2', isTodoNote: true, dateCreated: DateTime.now()),
      NoteModel(id: '3', isTodoNote: false, dateCreated: DateTime.now()),
    ];

    List<NoteModel> _h1 =
        _notesForTest.where((element) => element.isTodoNote).toList();
    List<NoteModel> _h2 =
        _notesForTest.where((element) => element.id == '2').toList();

    print(_h1);
    print(_h2);
  });
}
