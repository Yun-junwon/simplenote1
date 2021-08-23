import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:simplenote_1/data/app_data.dart';
import 'package:simplenote_1/models/note_model.dart';
import 'package:simplenote_1/screens/note_list_screen.dart';

class TodoNoteScreen extends StatefulWidget {
  final String id;

  const TodoNoteScreen({Key? key, required this.id}) : super(key: key);

  @override
  _TodoNoteScreenState createState() => _TodoNoteScreenState();
}

class _TodoNoteScreenState extends State<TodoNoteScreen> {
  bool isCheck = false;
  //late int index;
  var datedCreated = DateFormat('yy.MM.dd').format(DateTime.now());

  AppData appData = Get.find();

  TextEditingController? _titleController;
  TextEditingController? _todoController;

  FocusNode input1 = FocusNode();
  FocusNode input2 = FocusNode();
  FocusNode input3 = FocusNode();
  FocusNode input4 = FocusNode();

  TextEditingController _firstNum = TextEditingController();
  TextEditingController _secondNum = TextEditingController();
  TextEditingController _thirdNum = TextEditingController();
  TextEditingController _fourthNum = TextEditingController();

  @override
  void initState() {
    String initialTitle = appData.getNote(widget.id).title ?? '';
    String initialContent = appData.getNote(widget.id).content ?? '';

    _titleController = TextEditingController(text: initialTitle);
    _todoController = TextEditingController(text: initialContent);

    super.initState();
  }

  @override
  void dispose() {
    //_titleController?.dispose();
    //_contentController?.dispose();
    // _todoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      builder: (AppData appData) => Scaffold(
        backgroundColor: const Color(0XFFFFFFFF),
        appBar: _todoNoteAppBar(),
        bottomNavigationBar: _todoNoteBuilder(context),
        body: Padding(
          padding:
              EdgeInsets.only(left: 10.0, bottom: 10.0, right: 10.0, top: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _dateCreated(),
              _titleCreated(),
              Divider(
                thickness: 1.0,
                height: 5.0,
              ),
              _todoCreated(appData)
            ],
          ),
        ),
      ),
    );
  }

  Expanded _todoCreated(AppData appData) {
    return Expanded(
        child: ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return Dismissible(
          key: UniqueKey(),
          onDismissed: (direction) {
            setState(() {
              appData.getNote(widget.id).todoItems.removeAt(index);
            });
            //appData.deleteTodo(widget.id);
            //print(appData.getNote(widget.id).todoItems.length);
          },
          background: Container(),
          secondaryBackground: Container(
              color: Colors.redAccent,
              child: Icon(Icons.delete_outline_rounded)),
          child: CheckboxListTile(
              title: TextFormField(
                controller: appData
                    .getNote(widget.id)
                    .todoItems
                    .elementAt(index)
                    .todoController,
                decoration: InputDecoration(
                    border: UnderlineInputBorder(borderSide: BorderSide.none)),
                onChanged: (value) {
                  NoteModel note = appData.getNote(widget.id);
                  if (index == 0) note.content = value;
                },
              ),
              value: appData
                  .getNote(widget.id)
                  .todoItems
                  .elementAt(index)
                  .isChecked,
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (value) {
                setState(() {
                  appData
                      .getNote(widget.id)
                      .todoItems
                      .elementAt(index)
                      .isChecked = value ?? false;
                  appData.update();
                  print(value);
                });
              }),
        );
      },
      itemCount: appData.getNote(widget.id).todoItems.length,
    ));
  }

  Padding _titleCreated() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _titleController,
        decoration: InputDecoration(hintText: '제목', border: InputBorder.none),
        onChanged: (value) {
          NoteModel note = appData.getNote(widget.id);
          note.title = value;
        },
      ),
    );
  }

  Padding _dateCreated() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        datedCreated,
        style: TextStyle(
          fontWeight: FontWeight.w300,
          fontSize: 15.0,
        ),
      ),
    );
  }

  BottomAppBar _todoNoteBuilder(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Switch(
              value: appData.getNote(widget.id).isLocked,
              onChanged: (value) {
                setState(() {
                  if (appData.getNote(widget.id).isLocked == true) {
                    appData.updateLockState(widget.id, false);
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(builder:
                              (BuildContext context, StateSetter setState) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              title: Text('비밀번호'),
                              content: Container(
                                height: 150,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          width: 30,
                                          child: TextFormField(
                                            controller: _firstNum,
                                            autofocus: true,
                                            textAlign: TextAlign.center,
                                            obscureText: true,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              border: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0xFFD1E2C3),
                                                ),
                                              ),
                                            ),
                                            focusNode: input1,
                                            onChanged: (text) {
                                              if (text.length == 1) {
                                                input1.unfocus();
                                                FocusScope.of(context)
                                                    .requestFocus(input2);
                                              }
                                            },
                                          ),
                                        ),
                                        Container(
                                          width: 30,
                                          child: TextFormField(
                                            controller: _secondNum,
                                            textAlign: TextAlign.center,
                                            obscureText: true,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              border: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0xFFD1E2C3),
                                                ),
                                              ),
                                            ),
                                            focusNode: input2,
                                            onChanged: (text) {
                                              if (text.length == 1) {
                                                input2.unfocus();
                                                FocusScope.of(context)
                                                    .requestFocus(input3);
                                              }
                                            },
                                          ),
                                        ),
                                        Container(
                                          width: 30,
                                          child: TextFormField(
                                            controller: _thirdNum,
                                            textAlign: TextAlign.center,
                                            obscureText: true,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              border: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0xFFD1E2C3),
                                                ),
                                              ),
                                            ),
                                            focusNode: input3,
                                            onChanged: (text) {
                                              if (text.length == 1) {
                                                input3.unfocus();
                                                FocusScope.of(context)
                                                    .requestFocus(input4);
                                              }
                                            },
                                          ),
                                        ),
                                        Container(
                                          width: 30,
                                          child: TextFormField(
                                            controller: _fourthNum,
                                            textAlign: TextAlign.center,
                                            obscureText: true,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              border: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0xFFD1E2C3),
                                                ),
                                              ),
                                            ),
                                            focusNode: input4,
                                            onChanged: (text) {
                                              if (text.length == 1) {
                                                input4.unfocus();
                                                isCheck = !isCheck;
                                              }
                                            },
                                          ),
                                        ),
                                        Icon(
                                          Icons.check_circle_outline,
                                          size: 20,
                                          color: isCheck == true
                                              ? Color(0xff008438)
                                              : Color(0xFFD1E2C3),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 30),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 50,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          // appData.getNote(widget.id).isLocked = true;
                                          appData.password = _firstNum.text +
                                              _secondNum.text +
                                              _thirdNum.text +
                                              _fourthNum.text;

                                          _firstNum.text = '';
                                          _secondNum.text = '';
                                          _thirdNum.text = '';
                                          _fourthNum.text = '';

                                          if (appData
                                                  .getNote(widget.id)
                                                  .isLocked ==
                                              false) {
                                            appData.updateLockState(
                                                widget.id, true);
                                            Get.back();
                                            isCheck = !isCheck;
                                          } else
                                            Get.back();
                                        },
                                        child: Text('확 인'),
                                        style: ButtonStyle(
                                            shape: MaterialStateProperty
                                                .resolveWith((_) =>
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20))),
                                            backgroundColor: isCheck == true
                                                ? MaterialStateProperty.resolveWith(
                                                    (_) => Color(0xff008438))
                                                : MaterialStateProperty
                                                    .resolveWith((_) =>
                                                        Color(0xFFD1E2C3))),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                        });
                  }
                });
              }),
          ImageIcon(
            appData.getNote(widget.id).isLocked == true
                ? AssetImage('assets/FeatherIconSet-Feather_Security-lock.png')
                : AssetImage('assets/그룹 144.png'),
            color: Color(0xFF008438),
          ),
          Spacer(),
          IconButton(
            icon: ImageIcon(AssetImage('assets/check_circle.png')),
            color: Color(0xFF008438),
            padding: EdgeInsets.all(8.0),
            onPressed: () {
              appData.newTodo(widget.id);
              print(widget.id);
            },
          ),
        ],
      ),
    );
  }

  AppBar _todoNoteAppBar() {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.green),
      elevation: 0.0,
      backgroundColor: Colors.white,
      centerTitle: true,
      title: Text(
        ' 메모 ',
        style: TextStyle(
          color: Colors.green,
          fontSize: 14.0,
        ),
      ),
      actions: [
        TextButton(
          child: Text(
            '완료',
            style: TextStyle(
              color: Colors.green,
              fontSize: 14.0,
            ),
          ),
          onPressed: () {
            Get.to(NoteListScreen());
          },
        )
      ],
    );
  }
}
