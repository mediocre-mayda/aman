import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:intl/intl.dart';

class HelperMethods {
  // static Future checkContactPermission() async {
  //   PermissionStatus permission = await PermissionHandler()
  //       .checkPermissionStatus(PermissionGroup.contacts);
  // }

  // static Future requestContactPermissions() async {
  //   Map<PermissionGroup, PermissionStatus> permissions =
  //       await PermissionHandler()
  //           .requestPermissions([PermissionGroup.contacts]);
  // }

  // static Future openAppSettings() async {
  //   bool isOpened = await PermissionHandler().openAppSettings();
  // }

  static void playClickSound() {
    SystemSound.play(SystemSoundType.click);
  }

  static ProgressDialog progressDialog;
  static void showProgressDialog(
      BuildContext context, String msg, bool isDismissible) {
    progressDialog = new ProgressDialog(context,
        type: ProgressDialogType.Normal,
        isDismissible: isDismissible,
        showLogs: true);
    progressDialog.style(
      message: msg,
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.w600),
    );
    progressDialog.show();
  }

  static void hideProgressDialog() {
    progressDialog.hide();
  }

  static void showAlert(BuildContext context, String title, String desc) {
    Alert(
      context: context,
      title: title,
      desc: desc,
      style: AlertStyle(backgroundColor: Colors.white),
      closeFunction: () {
        return false;
      },
      buttons: [
        DialogButton(
          child: Text(
            "Ok",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.red[600],
          radius: BorderRadius.circular(0.0),
        ),
      ],
    ).show();
  }

  static String dateOnlyFromString(String strDate) {
    DateTime date = DateTime.parse(strDate);
    String formattedDate =
        new DateFormat("dd-MM-yyyy").format(date); // => 21-04-2019
    return formattedDate;
  }
}
