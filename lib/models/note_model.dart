import 'package:flutter/cupertino.dart';

class TodoItem {
  TextEditingController? todoController;
  String? content;
  bool isChecked;

  TodoItem({
    this.todoController,
    this.content = '',
    this.isChecked = false,
  });
}

class NoteModel {
  String id;
  bool isTodoNote;
  bool isLocked;
  bool isChecked;
  DateTime dateCreated;
  String? title;
  String? content;
  List<TodoItem> todoItems = [];

  NoteModel({
    required this.id,
    required this.isTodoNote,
    this.isLocked = false,
    this.isChecked = false,
    required this.dateCreated,
    this.title = '',
    this.content,
    // this.todoItems,
  });
}
