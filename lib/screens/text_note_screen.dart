import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:simplenote_1/data/app_data.dart';
import 'package:simplenote_1/models/note_model.dart';
import 'package:simplenote_1/screens/note_list_screen.dart';

class TextNoteScreen extends StatefulWidget {
  final String id;
  final bool isSwitched = false;

  const TextNoteScreen({Key? key, required this.id}) : super(key: key);

  @override
  _TextNoteScreenState createState() => _TextNoteScreenState();
}

class _TextNoteScreenState extends State<TextNoteScreen> {
  String currentNum = '';
  bool isCheck = false;
  bool isColored = false;
  bool password = false;
  //bool isLock = false;
  var datedCreated = DateFormat('yy.MM.dd').format(DateTime.now());
  AppData appData = Get.find();

  FocusNode input1 = FocusNode();
  FocusNode input2 = FocusNode();
  FocusNode input3 = FocusNode();
  FocusNode input4 = FocusNode();

  TextEditingController _firstNum = TextEditingController();
  TextEditingController _secondNum = TextEditingController();
  TextEditingController _thirdNum = TextEditingController();
  TextEditingController _fourthNum = TextEditingController();

  TextEditingController? _titleController;
  TextEditingController? _contentController;

  @override
  void initState() {
    String initialTitle = appData.getNote(widget.id).title ?? '';
    String initialContent = appData.getNote(widget.id).content ?? '';
    _titleController = TextEditingController(text: initialTitle);
    _contentController = TextEditingController(text: initialContent);
    super.initState();
  }

  @override
  void dispose() {
    _titleController?.dispose();
    _contentController?.dispose();
    _firstNum.dispose();
    _secondNum.dispose();
    _thirdNum.dispose();
    _fourthNum.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      builder: (AppData appData) => Scaffold(
        backgroundColor: const Color(0XFFFFFFFF),
        appBar: _textNoteAppBar(),
        body: _textNoteField(),
        bottomNavigationBar: _textNoteNavBot(),
      ),
    );
  }

  BottomAppBar _textNoteNavBot() {
    return BottomAppBar(
      color: Colors.white,
      child: Row(
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
                : AssetImage('assets/group144x2.png'),
            color: Color(0xFF008438),
          ),
        ],
      ),
    );
  }

  Padding _textNoteField() {
    return Padding(
      padding:
          EdgeInsets.only(left: 20.0, bottom: 30.0, right: 10.0, top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(datedCreated),
          SizedBox(
            height: 15.0,
          ),
          TextField(
            controller: _titleController,
            keyboardType: TextInputType.text,
            maxLines: 1,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: ' 제목 ',
            ),
            onChanged: (value) {
              NoteModel note = appData.getNote(widget.id);
              note.title = value;
            },
          ),
          TextField(
            controller: _contentController,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: ' 내용 ',
            ),
            onChanged: (value) {
              NoteModel note = appData.getNote(widget.id);
              note.content = value;
            },
          ),
        ],
      ),
    );
  }

  AppBar _textNoteAppBar() {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.green),
      elevation: 0.0,
      backgroundColor: Colors.white,
      centerTitle: true,
      title: Text(
        ' 메모 ',
        style: TextStyle(
          color: Color(0xff108438),
          fontSize: 18.0,
        ),
      ),
      actions: [
        TextButton(
          child: Text(
            '완료',
            style: TextStyle(
              color: Color(0xff108438),
              fontSize: 16.0,
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
