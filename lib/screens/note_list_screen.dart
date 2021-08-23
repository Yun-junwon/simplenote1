import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:simplenote_1/data/app_data.dart';
import 'package:simplenote_1/models/note_model.dart';
import 'text_note_screen.dart';
import 'todo_note_screen.dart';
import 'package:google_fonts/google_fonts.dart';

enum MenuGenerators { textNote, todolistNote }

class NoteListScreen extends StatefulWidget {
  @override
  _NoteListScreenState createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  MenuGenerators? _generator = MenuGenerators.textNote;
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppData>(
      builder: (appData) {
        return Scaffold(
          appBar: _noteListAppBar(),
          body: _noteListBuilder(appData),
          floatingActionButton: _noteListFloatingBtn(appData),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          backgroundColor: const Color(0xFFF0F0F0),
        );
      },
    );
  }

  FloatingActionButton _noteListFloatingBtn(AppData appData) {
    return FloatingActionButton(
        child: Icon(
          Icons.add,
        ),
        backgroundColor: Color(0xFF008438),
        onPressed: () {
          Get.dialog(
            StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0)),
                  title: Text(
                    ' 메모 생성하기 ',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15.0, color: Color(0xff008438)),
                  ),
                  content: SizedBox(
                    height: 193.0,
                    width: 204.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _listNote(setState),
                        _listTodo(setState),
                        SizedBox(height: 30.0),
                        _selectedNote(appData),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        });
  }

  SizedBox _selectedNote(AppData appData) {
    return SizedBox(
      width: 114.0,
      height: 30.0,
      child: ElevatedButton(
        child: Text(
          ' 확인 ',
        ),
        onPressed: () {
          if (_generator == MenuGenerators.textNote) {
            var id = appData.newNote(isTodoNote: false);
            Get.off(TextNoteScreen(id: id));
          } else if (_generator == MenuGenerators.todolistNote) {
            var id = appData.newNote(isTodoNote: true);
            Get.off(TodoNoteScreen(id: id));
          }
        },
        style: ElevatedButton.styleFrom(
          primary: Color(0xff108438),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
      ),
    );
  }

  ListTile _listTodo(StateSetter setState) {
    return ListTile(
      title: const Text(' to do list 노트 '),
      leading: Radio<MenuGenerators>(
        value: MenuGenerators.todolistNote,
        groupValue: _generator,
        onChanged: (MenuGenerators? value) {
          setState(() {
            _generator = value;
          });
        },
      ),
    );
  }

  ListTile _listNote(StateSetter setState) {
    return ListTile(
      title: Text(
        ' 텍스트 노트 ',
      ),
      leading: Radio<MenuGenerators>(
        value: MenuGenerators.textNote,
        groupValue: _generator,
        onChanged: (MenuGenerators? value) {
          setState(() {
            _generator = value;
          });
        },
      ),
    );
  }

  Container _noteListBuilder(AppData appData) {
    return Container(
      color: Colors.white,
      child: ListView.builder(
        itemBuilder: (context, index) {
          String title = appData.notes.elementAt(index).title ?? '';
          String content = appData.notes.elementAt(index).content ?? '';
          String id = appData.notes.elementAt(index).id;
          bool isTodoNote = appData.notes.elementAt(index).isTodoNote;
          String date = DateFormat('yy.MM.dd').format(DateTime.now());
          bool isLocked = appData.getNote(id).isLocked;
          return InkWell(
            onTap: () {
              if (!isTodoNote && !isLocked) {
                Get.to(TextNoteScreen(id: id));
              } else if (!isTodoNote && isLocked) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(builder:
                          (BuildContext context, StateSetter setState) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          title: Text(
                            '비밀번호',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color(0xFF008438), fontSize: 18),
                          ),
                          content: TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFF008438)))),
                            maxLength: 4,
                            autofocus: true,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                          ),
                          actions: [
                            TextButton(
                                onPressed: () => Get.back(),
                                child: Text(
                                  '취소',
                                  style: TextStyle(color: Color(0xFF008438)),
                                )),
                            TextButton(
                              onPressed: () {
                                if (_passwordController.text ==
                                    appData.password) {
                                  Get.to(TextNoteScreen(id: id));
                                } else {
                                  Get.back();
                                }
                              },
                              child: Text(
                                '확인',
                                style: TextStyle(color: Color(0xFF008438)),
                              ),
                            ),
                          ],
                        );
                      });
                    });
              } else if (isTodoNote && !isLocked) {
                Get.to(TodoNoteScreen(id: id));
              } else if (isTodoNote && isLocked) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(builder:
                          (BuildContext context, StateSetter setState) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          title: Text('비밀번호'),
                          content: TextField(
                            controller: _passwordController,
                            obscureText: true,
                            maxLength: 4,
                            autofocus: true,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                          ),
                          actions: [
                            TextButton(
                                onPressed: () => Get.back(), child: Text('취소')),
                            TextButton(
                              onPressed: () {
                                if (_passwordController.text ==
                                    appData.password) {
                                  Get.to(TodoNoteScreen(id: id));
                                } else {
                                  Get.back();
                                }
                              },
                              child: Text('확인'),
                            ),
                          ],
                        );
                      });
                    });
              }
            },
            onLongPress: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      title: Text(
                        '확 인',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 20.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      content: Text(
                        '삭제 하시겠습니까?',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 15.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: Text(
                              ' 취 소 ',
                              style: TextStyle(color: Colors.green),
                            )),
                        TextButton(
                            onPressed: () {
                              appData.deleteNote(id);
                              Get.back();
                            },
                            child: Text(
                              ' 삭 제 ',
                              style: TextStyle(color: Colors.green),
                            )),
                      ],
                    );
                  });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                height: 80,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  color: appData.getNote(id).isLocked == true
                      ? Colors.lightGreenAccent
                      : Colors.green[100],
                  child: Center(
                    child: appData.getNote(id).isLocked == false
                        ? ListTile(
                            title: appData.getNote(id).isLocked == false
                                ? Text('$title')
                                : null,
                            subtitle: appData.getNote(id).isLocked == false
                                ? Text(
                                    '$content',
                                    maxLines: 1,
                                  )
                                : null,
                            trailing: Text('$date'),
                          )
                        : Container(
                            child: Icon(Icons.lock_outline),
                          ),
                  ),
                ),
              ),
            ),
          );
        },
        itemCount: appData.notes.length,
      ),
    );
  }

  AppBar _noteListAppBar() {
    return AppBar(
      centerTitle: true,
      automaticallyImplyLeading: false,
      iconTheme: IconThemeData(color: Colors.green),
      title: Text(
        ' 메모 ',
        style: TextStyle(
            fontSize: 14.0, color: Colors.green, fontWeight: FontWeight.bold
            //letterSpacing: 19.0,
            ),
      ),
      elevation: 0.0,
      //centerTitle: true,
      backgroundColor: Colors.white,
    );
  }
}
