import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_flutter/peges/home.dart';
import 'package:demo_flutter/service/database.dart';
import 'package:demo_flutter/service/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';

class chatpage extends StatefulWidget {
  String name, profileurl, username;
  chatpage(
      {super.key,
      required this.name,
      required this.profileurl,
      required this.username});

  @override
  State<chatpage> createState() => _chatpageState();
}

class _chatpageState extends State<chatpage> {
  TextEditingController messagecontroller = TextEditingController();
  String? myUserName, myprofilepic, myName, myEmail, messageId, chatRoomId;
  Stream? messageStrem;

  getthesharedpref() async {
    myUserName = await sharedpreferenceHelper().getUserName();
    myprofilepic = await sharedpreferenceHelper().getUserPic();
    myName = await sharedpreferenceHelper().getDisplayname();
    myEmail = await sharedpreferenceHelper().getUserEmail();

    chatRoomId = getchatRoomIdbyusername(widget.username, myUserName!);
    setState(() {});
  }

  ontheload() async {
    await getthesharedpref();
    await getandSetMessages();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    ontheload();
  }

  getchatRoomIdbyusername(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  Widget chatMassageTile(String message, bool sendByMe) {
    return Row(
      mainAxisAlignment:
          sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    bottomRight:
                        sendByMe ? Radius.circular(0) : Radius.circular(24),
                    topRight: Radius.circular(24),
                    bottomLeft:
                        sendByMe ? Radius.circular(24) : Radius.circular(0)),
                color: sendByMe
                    ? Color.fromARGB(255, 195, 197, 202)
                    : Color.fromARGB(255, 173, 187, 223)),
            child: Text(
              message,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500),
            ),
          ),
        )
      ],
    );
  }

  Widget chatMassage() {
    return StreamBuilder(
        stream: messageStrem,
        builder: (context, AsyncSnapshot Snapshot) {
          return Snapshot.hasData
              ? ListView.builder(
                  padding: EdgeInsets.only(bottom: 90.0, top: 130),
                  itemCount: Snapshot.data.docs.length,
                  reverse: true,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = Snapshot.data.docs[index];
                    return chatMassageTile(
                        ds["message"], myUserName == ds["sendby"]);
                  })
              : Center(
                  child: CircularProgressIndicator(),
                );
        });
  }

  addMessage(bool sendClicked) {
    if (messagecontroller.text != "") {
      String message = messagecontroller.text;
      messagecontroller.text = "";

      DateTime now = DateTime.now();
      String fromattedDate = DateFormat("h:mma").format(now);
      Map<String, dynamic> messageInfoMap = {
        "message": message,
        "sendby": myUserName,
        "ts": fromattedDate,
        "time": FieldValue.serverTimestamp(),
        "imgeUrl": myprofilepic,
      };
      messageId ??= randomAlphaNumeric(10);

      Databasemethod()
          .addMessage(chatRoomId!, messageId!, messageInfoMap)
          .then((value) {
        Map<String, dynamic> lastmessageInfoMap = {
          "lastmessage": message,
          "lastMessageSendTs": fromattedDate,
          "time": FieldValue.serverTimestamp(),
          "lastmessageSendBy": myUserName,
        };
        Databasemethod().updateLastMessageSend(chatRoomId!, lastmessageInfoMap);
        if (sendClicked) {
          messageId = null;
        }
      });
    }
  }

  getandSetMessages() async {
    messageStrem = await Databasemethod().getChatRoomMessages(chatRoomId);
    setState(() {});
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
              width: width,
              height: height / 1.07,
              margin: EdgeInsets.only(
                top: 60,
              ),
              child: Stack(children: [
                Container(
                    margin: EdgeInsets.only(top: 60),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30))),
                    child: chatMassage()),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => Home()));
                        },
                        child: Icon(
                          Icons.arrow_back_ios_new_outlined,
                          color: Color(0xffc199cd),
                        ),
                      ),
                      SizedBox(
                        width: width / 3.5,
                      ),
                      Text(
                        widget.name,
                        style: TextStyle(
                            color: Color(0xffc199cd),
                            fontSize: 22.0,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                // SizedBox(
                //   height: 15,
                // ),
                // Container(
                //   padding:
                //       EdgeInsets.only(left: 20, right: 20, top: 50, bottom: 20),
                //   height: height / 1.13,
                //   width: width,
                //   decoration: BoxDecoration(
                //       color: Colors.white,
                //       borderRadius: BorderRadius.only(
                //           topLeft: Radius.circular(30),
                //           topRight: Radius.circular(30))),
                //   child: Column(
                //     children: [
                //       Container(
                //         padding: EdgeInsets.all(10),
                //         margin: EdgeInsets.only(left: width / 2),
                //         alignment: Alignment.bottomRight,
                //         decoration: BoxDecoration(
                //             color: Color.fromARGB(255, 195, 197, 202),
                //             borderRadius: BorderRadius.only(
                //                 topLeft: Radius.circular(10),
                //                 topRight: Radius.circular(10),
                //                 bottomLeft: Radius.circular(10))),
                //         child: Text(
                //           "hello,how are you",
                //           style: TextStyle(
                //               color: Colors.black,
                //               fontSize: 15.0,
                //               fontWeight: FontWeight.w500),
                //         ),
                //       ),
                //       SizedBox(
                //         height: 20.0,
                //       ),
                //       Container(
                //         padding: EdgeInsets.all(10),
                //         margin: EdgeInsets.only(right: width / 2),
                //         alignment: Alignment.bottomLeft,
                //         decoration: BoxDecoration(
                //             color: Color.fromARGB(255, 173, 187, 223),
                //             borderRadius: BorderRadius.only(
                //                 topLeft: Radius.circular(10),
                //                 topRight: Radius.circular(10),
                //                 bottomRight: Radius.circular(10))),
                //         child: Text(
                //           "yeah good",
                //           style: TextStyle(
                //               color: Colors.black,
                //               fontSize: 15.0,
                //               fontWeight: FontWeight.w500),
                //         ),
                //       ),
                //       SizedBox(
                //         height: 20,
                //       ),
                //       Container(
                //         padding: EdgeInsets.all(10),
                //         margin: EdgeInsets.only(left: width / 2),
                //         alignment: Alignment.bottomRight,
                //         decoration: BoxDecoration(
                //             color: Color.fromARGB(255, 195, 197, 202),
                //             borderRadius: BorderRadius.only(
                //                 topLeft: Radius.circular(10),
                //                 topRight: Radius.circular(10),
                //                 bottomLeft: Radius.circular(10))),
                //         child: Text(
                //           "hello,how are you",
                //           style: TextStyle(
                //               color: Colors.black,
                //               fontSize: 15.0,
                //               fontWeight: FontWeight.w500),
                //         ),
                //       ),
                //       SizedBox(
                //         height: 20,
                //       ),
                //       Container(
                //         padding: EdgeInsets.all(10),
                //         margin: EdgeInsets.only(right: width / 2),
                //         alignment: Alignment.bottomLeft,
                //         decoration: BoxDecoration(
                //             color: Color.fromARGB(255, 173, 187, 223),
                //             borderRadius: BorderRadius.only(
                //                 topLeft: Radius.circular(10),
                //                 topRight: Radius.circular(10),
                //                 bottomRight: Radius.circular(10))),
                //         child: Text(
                //           "yeah good",
                //           style: TextStyle(
                //               color: Colors.black,
                //               fontSize: 15.0,
                //               fontWeight: FontWeight.w500),
                //         ),
                //       ),
                //       SizedBox(
                //         height: 20,
                //       ),
                //       Container(
                //         padding: EdgeInsets.all(10),
                //         margin: EdgeInsets.only(left: width / 2),
                //         alignment: Alignment.bottomRight,
                //         decoration: BoxDecoration(
                //             color: Color.fromARGB(255, 195, 197, 202),
                //             borderRadius: BorderRadius.only(
                //                 topLeft: Radius.circular(10),
                //                 topRight: Radius.circular(10),
                //                 bottomLeft: Radius.circular(10))),
                //         child: Text(
                //           "hello,how are you",
                //           style: TextStyle(
                //               color: Colors.black,
                //               fontSize: 15.0,
                //               fontWeight: FontWeight.w500),
                //         ),
                //       ),
                //       SizedBox(
                //         height: 20,
                //       ),
                //       Container(
                //         padding: EdgeInsets.all(10),
                //         margin: EdgeInsets.only(right: width / 2),
                //         alignment: Alignment.bottomLeft,
                //         decoration: BoxDecoration(
                //             color: Color.fromARGB(255, 173, 187, 223),
                //             borderRadius: BorderRadius.only(
                //                 topLeft: Radius.circular(10),
                //                 topRight: Radius.circular(10),
                //                 bottomRight: Radius.circular(10))),
                //         child: Text(
                //           "yeah good",
                //           style: TextStyle(
                //               color: Colors.black,
                //               fontSize: 15.0,
                //               fontWeight: FontWeight.w500),
                //         ),
                //       ),

                Container(
                  margin:
                      EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                  alignment: Alignment.bottomCenter,
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30)),
                        child: TextField(
                            controller: messagecontroller,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Type a message",
                                hintStyle: TextStyle(color: Colors.black45),
                                suffixIcon: GestureDetector(
                                    onTap: () {
                                      addMessage(true);
                                    },
                                    child: Icon(Icons.send_rounded))))),
                    // GestureDetector(
                    //   onTap: () {
                    //     addMessage(true);
                    //   },
                    //   child: Container(
                    //     padding: EdgeInsets.all(10),
                    //     decoration: BoxDecoration(
                    //         color: Color.fromARGB(212, 211, 218, 218),
                    //         borderRadius: BorderRadius.circular(60)),
                    //     child: Center(
                    //       child: Icon(
                    //         Icons.send,
                    //         color: Colors.black45,
                    //       ),
                    //     ),
                    //   ),
                    // )
                  ),
                ),
              ]),
            ),
          )),
    );
  }
}
