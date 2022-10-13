import 'package:flutter/material.dart';
import 'package:new_notepad/config.dart';
import 'package:new_notepad/main.dart';
import 'package:new_notepad/mynote.dart';
import 'package:new_notepad/one.dart';
import 'package:sqflite/sqflite.dart';

class two extends StatefulWidget {
  Database database;
  String method;
  mynote? m;

  two(this.database, this.method, [this.m]);

  @override
  State<two> createState() => _twoState();
}

class _twoState extends State<two> {
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  int val = 0;
  List colorlist = [
    Color(0xff6dd5ed),
    Color(0xff753a88),
    Color(0xffcc2b5e),
    Color(0xff753a88),
    Color(0xff2B32B2),
    Color(0xffA5CC82)
  ];

  String temp="";

  bool gradient = false;
  Color c = Colors.black;

  @override
  void initState() {
    if (widget.method == "update") {
      print(widget.m);
      t1.text = widget.m!.title!;
      t2.text = widget.m!.content!;
    }
  }

  Future<bool> _onWillPop() async {
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) {
        return Container();
      },
    ));
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          appBar: AppBar(
            flexibleSpace: Image(
              image: AssetImage(temp),
              fit: BoxFit.cover,
            ),
            title: TextField(
              controller: t1,
              style: TextStyle(color: c),
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
            ),
            actions: [
              IconButton(
                  onPressed: () async {
                    String a = t1.text;
                    String b = t2.text;
                    if (widget.method == "insert") {
                      await widget.database.transaction((txn) async {
                        int id1 = await txn.rawInsert(
                            'INSERT INTO note(id, title, content,theme) VALUES(null, "$a","$b","$temp")');
                        print('inserted1: $id1');
                        if (id1 >= 1) {
                          Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context) {
                              return one();
                            },
                          ));
                        }
                      });
                    } else {
                      await widget.database.transaction((txn) async {
                        String q =
                            "update note set title='$a',content='$b',theme='$temp' where id=${widget.m!.id!}";
                        int id1 = await txn.rawUpdate(q);
                        print('update no of row:$id1');
                        if (id1 == 1) {
                          Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context) {
                              return one();
                            },
                          ));
                        }
                      });
                    }
                  },
                  icon: Icon(Icons.save)),
              PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                      onTap: () async {
                        await widget.database.transaction((txn) async {
                          String q =
                              "update note set pin=1 where id=${widget.m!.id!}";
                          int id1 = await txn.rawUpdate(q);
                          print('update no of row:$id1');
                          if (id1 == 1) {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(
                              builder: (context) {
                                return one();
                              },
                            ));
                          }
                        });
                      },
                      child: ListTile(
                        title: Text("Pin"),
                        leading: Icon(Icons.filter_alt_off),
                      )),
                  PopupMenuItem(
                      child: ListTile(
                    title: Text("Share"),
                    leading: Icon(Icons.share),
                  )),
                  PopupMenuItem(
                      child: ListTile(
                    title: Text("Themes"),
                    leading: Icon(Icons.copy_all),
                  )),
                  PopupMenuItem(
                      child: ListTile(
                    title: Text("Reminder"),
                    leading: Icon(Icons.add_alert_rounded),
                  )),
                  PopupMenuItem(
                      onTap: () {
                        print("hello");
                        Future.delayed(Duration(seconds: 0),() {
                          return showDialog(
                            barrierColor: Colors.transparent,
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                title: Text("delete todo"),
                                content: Text("Are you sure Delete"),
                                actions: [
                                  TextButton(onPressed: () async {
                                  int count = await widget.database.rawDelete(
                                      'DELETE FROM ${config.table} WHERE ${config.col1} =${widget.m!.id!}');
                                  if(count==1)
                                  {
                                    Navigator.pushReplacement(context, MaterialPageRoute(
                                      builder: (context) {
                                        return one();
                                      },
                                    ));
                                  }
                                }, child: Text("Yes")),
                                  TextButton(onPressed: () {
                                    Navigator.pop(context);
                                  }, child: Text("No"))
                                ],
                              );
                            },
                          );
                        },);
                      },
                      child: ListTile(
                        title: Text("delete"),
                        leading: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ))
                ],
              )
            ],
          ),
          body: Container(
            height: double.infinity,
            width: double.infinity,
            child: TextField(controller: t2,style: TextStyle(color: c),
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(temp),
              )
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            onTap: (value) {
              setState(() {
                val = value;
              });
            },
            selectedItemColor: Colors.blue,
            showUnselectedLabels: true,
            showSelectedLabels: true,
            unselectedItemColor: Colors.black,
            currentIndex: val,
            items: [
              BottomNavigationBarItem(label: "color", icon: IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    builder: (context) {
                      return Container(
                        height: 300,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: config.img.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  temp = config.img[index];
                                });
                                Navigator.pop(context);
                              },
                              child: UnconstrainedBox(
                                child: Container(
                                  width: 100,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(config.img[index]),
                                      fit: BoxFit.fill,
                                    )
                                  ),
                                ),
                              ),
                            );
                          },
                          // gridDelegate:
                          // SliverGridDelegateWithFixedCrossAxisCount(
                          //   crossAxisSpacing: 5,
                          //   crossAxisCount: 2,
                          //   mainAxisSpacing: 5,
                          //   childAspectRatio: 2.5,
                          // ),
                        ),
                      );
                    },
                    context: context,
                  );
                },
                icon: Icon(Icons.color_lens_outlined),
              )),
              BottomNavigationBarItem(
                  icon: Icon(Icons.format_bold), label: "bold"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.format_italic), label: "italic"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.format_underline), label: "underline"),
              BottomNavigationBarItem(
                  label: "font color",
                  icon: IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        builder: (context) {
                          return Container(
                            height: 100,
                            child: GridView.builder(
                              itemCount: colorlist.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    print(colorlist[index]);
                                    setState(() {
                                      gradient = false;
                                      c = colorlist[index];
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    color: colorlist[index],
                                  ),
                                );
                              },
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisSpacing: 5,
                                crossAxisCount: 5,
                                mainAxisSpacing: 5,
                                childAspectRatio: 2,
                              ),
                            ),
                          );
                        },
                        context: context,
                      );
                    },
                    icon: Icon(Icons.font_download),
                  )),
              BottomNavigationBarItem(
                  icon: Icon(Icons.format_color_text_sharp),
                  label: "textcolor"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.format_size), label: "size"),
            ],
          ),
        ));
  }
}
