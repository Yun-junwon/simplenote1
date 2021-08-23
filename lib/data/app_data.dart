import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simplenote_1/models/note_model.dart';

class AppData extends GetxController {
  String? password;

  List<NoteModel> _notes = [];
  List<NoteModel> get notes => _notes;
  set notes(List<NoteModel> notes) {
    _notes = notes;
    update();
  }

  List<NoteModel> getTodos() {
    return _notes.where((element) {
      if (element.isTodoNote == true) {
        return true;
      } else {
        return false;
      }
    }).toList();
  }

  String newNote({required bool isTodoNote}) {
    var id = DateTime.now().toString();
    NoteModel note = NoteModel(
      id: id,
      isTodoNote: isTodoNote,
      dateCreated: DateTime.now(),
    );
    _notes.add(note);
    update();

    return id;
  }

  deleteNote(String id) {
    _notes.removeWhere((element) => element.id == id);
    update();
  }

  NoteModel getNote(String id) {
    return _notes.singleWhere((element) => element.id == id);
  }

  updateNote(String id, String title, String content) {
    NoteModel note = getNote(id);
    note.title = title;
    note.content = content;
    update();
  }

  newTodo(String noteId) {
    TodoItem todos = TodoItem(
      todoController: TextEditingController(text: ''),
      isChecked: false,
      content: '',
    );
    getNote(noteId).todoItems.add(todos);
    print(getNote(noteId).todoItems.length);
    update();
  }

  // deleteTodo(String noteId) {
  //   getNote(noteId).todoItems.removeWhere((element) => element. == noteId);
  //   update();
  // }

  updateLockState(String id, bool value) {
    NoteModel note = getNote(id);
    note.isLocked = value;
    update();
  }
}
