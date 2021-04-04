import 'package:aman/data/network/services/report_service.dart';
import 'package:aman/screens/login_screen.dart';
import 'package:aman/screens/map_screen.dart';
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
import 'package:location/location.dart';
import 'package:toast/toast.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key key}) : super(key: key);
  String type;
  final TextEditingController _notesController = new TextEditingController();

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  SharedPreferences prefs;
  Location location = new Location();

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
          children: _buildExpandableReports(),
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
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    print("_locationData latitude =  ${_locationData.latitude}");
    print("_locationData longitude = ${_locationData.longitude}");

    await ReportService()
        .postReport(
            type,
            text,
            prefs.getString("token"),
            prefs.getString("userId"),
            _locationData.latitude,
            _locationData.longitude)
        .then((response) async {
      print("response: ${response.body}");
      Toast.show('تم نشر بلاغك', context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    });
  }

  List<Widget> _buildExpandableReports() {
    return <Widget>[
      InkWell(
          onTap: _goToMapScreen,
          child: HeaderWidget(
              name: "", description: "", icon: FontAwesomeIcons.mapMarked)),
      SizedBox(height: 20),
      Text(
        "قائمة البلاغات",
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: 35,
          fontWeight: FontWeight.w700,
        ),
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
                  color: Theme.of(context).primaryColor,
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
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
              SizedBox(width: 50, height: 30),
              Text(
                "دهس وعفس",
                softWrap: true,
                style: TextStyle(
                    fontSize: 22, color: Theme.of(context).primaryColor),
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
      Container(
        margin: EdgeInsets.only(left: 50, right: 50),
        child: ExpandablePanel(
          header: Row(
            children: [
              Icon(
                FontAwesomeIcons.ambulance,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(
                width: 15,
              ),
              Text(
                "طلب اسعاف",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
              ),
            ],
          ),
          collapsed: Container(),
          expanded: InkWell(
            onTap: () {
              setState(() {
                widget.type = "1طلب اسعاف";
                print(widget.type);
                _showSheet();
              });
            },
            child: Row(children: <Widget>[
              SizedBox(width: 50, height: 30),
              Text(
                "1طلب اسعاف",
                softWrap: true,
                style: TextStyle(
                    fontSize: 22, color: Theme.of(context).primaryColor),
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
      Container(
        margin: EdgeInsets.only(left: 50, right: 50),
        child: ExpandablePanel(
          header: Row(
            children: [
              Icon(
                FontAwesomeIcons.fireExtinguisher,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(
                width: 15,
              ),
              Text(
                "بلاغ حريق",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
              ),
            ],
          ),
          collapsed: Container(),
          expanded: InkWell(
            onTap: () {
              setState(() {
                widget.type = "بلاغ حريق";
                print(widget.type);
                _showSheet();
              });
            },
            child: Row(children: <Widget>[
              SizedBox(width: 50, height: 30),
              Text(
                "بلاغ حريق",
                softWrap: true,
                style: TextStyle(
                    fontSize: 22, color: Theme.of(context).primaryColor),
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
      Container(
        margin: EdgeInsets.only(left: 50, right: 50),
        child: ExpandablePanel(
          header: Row(
            children: [
              Icon(
                FontAwesomeIcons.infoCircle,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(
                width: 15,
              ),
              Text(
                "بلاغ مخصص",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
              ),
            ],
          ),
          collapsed: Container(),
          expanded: InkWell(
            onTap: () {
              setState(() {
                widget.type = "بلاغ مخصص";
                print(widget.type);
                _showSheet();
              });
            },
            child: Row(children: <Widget>[
              SizedBox(width: 50, height: 30),
              Text(
                "بلاغ مخصص",
                softWrap: true,
                style: TextStyle(
                    fontSize: 22, color: Theme.of(context).primaryColor),
              ),
            ]),
          ),
          tapHeaderToExpand: true,
          hasIcon: true,
        ),
      ),
      InkWell(
        onDoubleTap: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.remove("userId");
          prefs.remove("token");
          _goToLoginScreen(context);
        },
        child: Divider(
          indent: 50,
          endIndent: 50,
          thickness: 1.5,
          color: Theme.of(context).primaryColor,
        ),
      ),
    ];
  }

  _goToLoginScreen(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            fullscreenDialog: true,
            builder: (BuildContext context) => LoginScreen()),
        (Route<dynamic> route) => false);
  }

  _goToMapScreen() {
    Navigator.push(
        context,
        MaterialPageRoute(
            //settings: RouteSettings(name: RoutesSettings.MAIN_ROUTE),
            fullscreenDialog: true,
            builder: (BuildContext context) => MapScreen()));
  }
}
