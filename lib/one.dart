import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:new_notepad/mynote.dart';
import 'package:new_notepad/two.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'config.dart';

class one extends StatefulWidget {
  @override
  State<one> createState() => _oneState();
}

class _oneState extends State<one> {
  Database? database;
  List list = [];

  creatdb() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');
    database = await openDatabase(
        onUpgrade: (db, oldVersion, newVersion) async {
          {
            if (newVersion == 2) {
              await db
                  .execute('alter TABLE note add column pin integer default 0');
            }
            if (newVersion == 3) {
              await db.execute(
                  'alter TABLE note add column theme text default "photo/w1.jpg"');
            }
          }
          ;
        },
        path,
        version: 3,
        onCreate: (Database db, int version) async {
          await db.execute(
              'CREATE TABLE note(id INTEGER PRIMARY KEY ,title TEXT,content TEXT)');
        });
    list = await database!.rawQuery("select * from note ORDER BY pin desc");
    setState(() {});
  }

  @override
  void initState() {
    creatdb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "SUPER NOTE",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                  onTap: () {},
                  child: ListTile(
                    title: Text(
                      "view by grid",
                    ),
                    leading: Icon(
                      Icons.grid_view,
                      color: Colors.black,
                    ),
                  )),
              PopupMenuItem(
                  onTap: () {},
                  child: ListTile(
                    title: Text(
                      "Color&background",
                    ),
                    leading: Icon(
                      Icons.backup_table,
                      color: Colors.black,
                    ),
                  )),
              PopupMenuItem(
                  onTap: () {},
                  child: ListTile(
                    title: Text(
                      "trash",
                    ),
                    leading: Icon(
                      Icons.delete,
                      color: Colors.black,
                    ),
                  )),
              PopupMenuItem(
                  onTap: () {},
                  child: ListTile(
                    title: Text(
                      "settings",
                    ),
                    leading: Icon(
                      Icons.settings,
                      color: Colors.black,
                    ),
                  ))
            ],
          )
        ],
      ),
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> m = list[index];
          mynote my = mynote.fromJson(m);
          print(m);
          return OpenContainer(
            openBuilder: (context, action) {
              return two(database!, "update", my);
            },
            closedBuilder: (context, action) {
              return Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("${m['theme']}"),
                  fit: BoxFit.fill,
                )),
                child: ListTile(
                  title: Text("${m['${config.col2}']}"),
                  subtitle: Text("${m['content']}"),
                ),
              );
            },
            transitionDuration: Duration(seconds: 1),
          );
        },
      ),
      floatingActionButton: OpenContainer(
        transitionDuration: Duration(seconds: 1),
        openBuilder: (context, action) {
          return two(database!, "insert");
        },
        closedBuilder: (context, action) {
          return FloatingActionButton(
            backgroundColor: Color(0xD6E7E551),
            onPressed: null,
            child: Icon(Icons.add),
          );
        },
      ),
    );
  }
}
