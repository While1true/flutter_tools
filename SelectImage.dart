//
// Created by ckckck on 2018/9/19.
//
import 'dart:async';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_jtest/Constants/Strings.dart';
import 'package:flutter_jtest/Widgets/MyBottomSheet.dart';

typedef CallBack(BuildContext context);

class SelectImage {
  static Future<File> show(
      BuildContext context, CallBack openGally, CallBack openCamera) {
    showMyBottomSheet(
        context: context,
        builder: (c) {
          return _buildDialog(context, openGally, openCamera);
        },
        bgcolor: Colors.transparent);
  }

  static Widget _buildDialog(
      BuildContext context, CallBack openGally, CallBack openCamera) {
    return IntrinsicHeight(
        child: Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(left: 15.0, right: 15.0),
                child: Container(
                  child: InkWell(
                    onTap: () {
                      openGally(context);
                    },
                    child: SizedBox(
                      height: 45.0,
                      child: Center(
                        child: Text(Strings.of(context).openGallery),
                      ),
                    ),
                  ),
                  color: Colors.white,
                )),
            Divider(
              height: 0.5,
            ),
            Padding(
                padding: EdgeInsets.only(left: 15.0, right: 15.0),
                child: Container(
                  child: InkWell(
                      onTap: () {
                        openCamera(context);
                      },
                      child: SizedBox(
                        height: 45.0,
                        child: Center(child: Text(Strings.of(context).openCamera)),
                      )),
                  color: Colors.white,
                )),
            Padding(
                padding: EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 12.0, bottom: 15.0),
                child: Container(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: SizedBox(
                      height: 45.0,
                      child: Center(child: Text(Strings.of(context).cancel)),
                    ),
                  ),
                  color: Colors.white,
                ))
          ],
        ));
  }
}
