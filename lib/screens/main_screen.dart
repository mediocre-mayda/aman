import 'package:aman/data/network/services/report_service.dart';
import 'package:aman/utils/colors.dart';
import 'package:aman/widgets/header_widget.dart';
import 'package:easy_text_input/easy_text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:expandable/expandable.dart';
import 'package:expandable_card/expandable_card.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key key}) : super(key: key);
  String type;
  final TextEditingController _notesController = new TextEditingController();

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            HeaderWidget(name: "", description: "", icon: FontAwesomeIcons.map),
            SizedBox(height: 20),
            Text(
              "قائمة البلاغات",
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 35),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
            ),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.only(left: 50, right: 50),
              child: ExpandablePanel(
                header: Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.carCrash,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      "بلاغ مروري",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor, fontSize: 35),
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
                collapsed: Container(),
                expanded: InkWell(
                  onTap: () {
                    setState(() {
                      widget.type = "دهس وعفس";
                      print(widget.type);
                      _showSheet();
                    });
                  },
                  child: Row(children: <Widget>[
                    SizedBox(width: 20, height: 20),
                    Text(
                      "دهس وعفس",
                      softWrap: true,
                      style: TextStyle(fontSize: 22),
                    ),
                  ]),
                ),
                tapHeaderToExpand: true,
                hasIcon: true,
              ),
            ),
            Divider(
              indent: 50,
              endIndent: 50,
              thickness: 1.5,
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  void _showSheet() {
    showFlexibleBottomSheet<void>(
      minHeight: 0,
      initHeight: 0.6,
      maxHeight: 0.8,
      context: context,
      builder: _buildBottomSheet,
      anchors: [0, 0.5, 1],
    );
  }

  Widget _buildBottomSheet(
    BuildContext context,
    ScrollController scrollController,
    double bottomSheetOffset,
  ) {
    return SafeArea(
      child: Material(
        child: Container(
          decoration: const BoxDecoration(
            color: aman_red,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: ListView(
            padding: const EdgeInsets.all(0),
            controller: scrollController,
            children: _buildBottomSheetBody(),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildBottomSheetBody() => <Widget>[
        SizedBox(height: 10),
        Divider(
          color: Colors.white,
          endIndent: 140,
          indent: 140,
          thickness: 3,
        ),
        SizedBox(height: 20),
        Center(
          child: Text(
            widget.type,
            style: TextStyle(fontSize: 50, color: Colors.white),
          ),
        ),
        SizedBox(height: 20),
        Container(
          width: 100,
          height: 200,
          margin: EdgeInsets.only(left: 40, right: 40),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: Colors.white),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: InputField(
                  stream: null,
                  keyboardType: TextInputType.text,
                  borderRadius: 20.0,
                  controller: widget._notesController,
                  onChanged: (val) {
                    print('notes: ' + val);
                  },
                ),
              ),
              Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        spreadRadius: 0.5,
                        offset: Offset(-2, 6),
                        blurRadius: 4),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                        icon: Icon(
                          FontAwesomeIcons.paperclip,
                          color: aman_red,
                        ),
                        onPressed: null),
                    VerticalDivider(
                      color: aman_red,
                      indent: 5,
                      endIndent: 5,
                    ),
                    IconButton(
                        icon: Icon(FontAwesomeIcons.camera, color: aman_red),
                        onPressed: null),
                    VerticalDivider(
                      color: aman_red,
                      indent: 5,
                      endIndent: 5,
                    ),
                    IconButton(
                        icon:
                            Icon(FontAwesomeIcons.microphone, color: aman_red),
                        onPressed: null),
                  ],
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 40),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 60),
          child: FlatButton(
            onPressed: () {
              _submitReport(widget.type, widget._notesController.text);
            },
            color: Colors.white,
            child: Text("إرسال", style: TextStyle(color: aman_red)),
          ),
        ),
      ];

  _submitReport(String type, String text) async {
    print("type = $type");
    print("text = $text");
    print("token = ${prefs.getString("token")}");
    print("userId = ${prefs.getString("userId")}");
    await ReportService()
        .postReport(
            type, text, prefs.getString("token"), prefs.getString("userId"))
        .then((response) async {
      print("response: ${response.body}");
    });
  }
}
