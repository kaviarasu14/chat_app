import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_flutter/peges/chatpage.dart';
import 'package:demo_flutter/service/database.dart';
import 'package:demo_flutter/peges/home.dart';
import 'package:demo_flutter/service/shared_pref.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool search = false;
  String? myName, myProfilePic, myUserName, myEmail;
  Stream? chatRoomsStream;

  getthesharedpref() async {
    myName = await sharedpreferenceHelper().getDisplayname();
    myProfilePic = await sharedpreferenceHelper().getUserPic();
    myUserName = await sharedpreferenceHelper().getUserName();
    myEmail = await sharedpreferenceHelper().getUserEmail();
    setState(() {});
  }

  ontheload() async {
    await getthesharedpref();
    chatRoomsStream = await Databasemethod().getChatRooms();
    setState(() {});
  }

  Widget ChatRoomList() {
    return StreamBuilder(
        stream: chatRoomsStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: snapshot.data.docs.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return ChatRoomListTile(
                        chatRoomId: ds.id,
                        lastMessage: ds["lastmessage"],
                        myUsername: myUserName!,
                        time: ds["lastMessageSendTs"]);
                  })
              : Center(
                  child: CircularProgressIndicator(),
                );
        });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => ontheload());
  }

  getchatRoomIdbyusername(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  var queryresultset = [];
  var tempsearchStore = [];

  initiatesearch(String value) {
    if (value.length == 0) {
      setState(() {
        queryresultset = [];
        tempsearchStore = [];
      });
    }
    setState(() {
      search = true;
    });
    var capitalizedvalue =
        value.substring(0, 1).toUpperCase() + value.substring(1);
    if (queryresultset.isEmpty && value.length == 1) {
      Databasemethod().search(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.docs.length; ++i) {
          queryresultset.add(docs.docs[i].data());
        }
      });
    } else {
      tempsearchStore = [];
      for (var element in queryresultset) {
        if (element['username'].startsWith(capitalizedvalue)) {
          setState(() {
            tempsearchStore.add(element);
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xFF553370),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
            child: Container(

                //margin: EdgeInsets.symmetric(vertical: 50.0, horizontal: 20.0),
                child: Column(children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 55, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                search
                    ? Expanded(
                        child: TextField(
                        onChanged: (value) {
                          initiatesearch(value.toUpperCase());
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "search user",
                            hintStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w500)),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500),
                      ))
                    : Text(
                        "HOME",
                        style: TextStyle(
                            color: Color(0xffc199cd),
                            fontSize: 28.0,
                            fontWeight: FontWeight.w500),
                      ),
                GestureDetector(
                  onTap: () {
                    search = true;
                    setState(() {});
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Color(0xff3a2144),
                        borderRadius: BorderRadius.circular(15)),
                    child: search
                        ? GestureDetector(
                            onTap: () {
                              search = false;
                              setState(() {});
                            },
                            child: Icon(
                              Icons.close,
                              color: Color(0xffc199cd),
                            ),
                          )
                        : Icon(
                            Icons.search,
                            color: Color(0xffc199cd),
                          ),
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
            height: search ? height / 1.19 : height / 1.15,
            width: width,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Column(
              children: [
                search
                    ? ListView(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        primary: false,
                        shrinkWrap: true,
                        children: tempsearchStore.map((element) {
                          return buildresultcart(element);
                        }).toList())
                    : ChatRoomList(),
              ],
            ),
          ),
        ]))),
      ),
    );
  }

  Widget buildresultcart(data) {
    return GestureDetector(
      onTap: () async {
        search = false;
        setState(() {});
        var chatRoomId = getchatRoomIdbyusername(myUserName!, data["username"]);
        Map<String, dynamic> chatRoomInfoMap = {
          "users": [myUserName, data["useraname"]],
        };
        await Databasemethod().creatChatRoom(chatRoomId, chatRoomInfoMap);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => chatpage(
                    name: data["Name"],
                    profileurl: data["photo"],
                    username: data["username"])));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadiusDirectional.circular(10),
          child: Container(
            padding: EdgeInsets.all(18),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: Image.network(
                      data["photo"],
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    )),
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data["Name"],
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      data["username"],
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChatRoomListTile extends StatefulWidget {
  final String lastMessage, chatRoomId, myUsername, time;
  const ChatRoomListTile(
      {required this.chatRoomId,
      required this.lastMessage,
      required this.myUsername,
      required this.time});
  @override
  State<ChatRoomListTile> createState() => _ChatRoomListTileState();
}

class _ChatRoomListTileState extends State<ChatRoomListTile> {
  String proFilePic = '', name = "", username = "", id = "";

  getthisUserInfo() async {
    username =
        widget.chatRoomId.replaceAll("_", "").replaceAll(widget.myUsername, "");
    QuerySnapshot querySnapshot =
        await Databasemethod().getUserInfo(username.toUpperCase());
    name = "${querySnapshot.docs[0]["Name"]}";
    proFilePic = "${querySnapshot.docs[0]["photo"]}";
    id = "${querySnapshot.docs[0]["Id"]}";
    setState(() {});
  }

  @override
  void initState() {
    getthisUserInfo();
    super.initState();
  }

  @override
  Widget build(data) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => chatpage(
                    name: name, profileurl: proFilePic, username: username)));
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            proFilePic == ""
                ? CircularProgressIndicator()
                : ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: Image.network(
                      proFilePic,
                      height: 70,
                      width: 70,
                      fit: BoxFit.cover,
                    ),
                  ),
            SizedBox(
              width: 10.0,
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                height: 10.0,
              ),
              Text(
                username,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
              Container(
                width: width / 3,
                child: Text(
                  widget.lastMessage,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 15,
                  ),
                ),
              )
            ]),
            Spacer(),
            Text(
              widget.time,
              style: TextStyle(color: Colors.black45, fontSize: 14),
            )
          ],
        ),
      ),
    );
  }
}
