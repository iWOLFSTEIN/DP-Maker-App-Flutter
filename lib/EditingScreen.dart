import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_dropdown_alert/alert_controller.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

class EditingScreen extends StatefulWidget {
  EditingScreen({Key? key, this.path}) : super(key: key);
  var path;
  @override
  _EditingScreenState createState() => _EditingScreenState();
}

class _EditingScreenState extends State<EditingScreen> {
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Colors.yellow;
  final globalKey = GlobalKey();
  final globalKey1 = GlobalKey();
  ScreenshotController screenshotController = ScreenshotController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  //Color(0xff443a49);

// ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  var name = '';
  var font = 'Anton';
  // int a = 400;
  var weight = '400';
  // List fontList = [
  //   // 'Regular-blah blah',
  //   'Roboto',
  //   'Abril Fatface',
  //   'Amatic SC',
  //   'Anton',
  //   'Bahianita',
  //   'Caveat',

  //   'Courgette',
  //   'Dosis',
  //   'Gloria Hallelujah',
  //   'Indie Flower',
  //   'Kanit',
  //   'Kaushan Script',
  //   // 'MonteCarlo',
  //   'New Rocker',
  //   'Open Sans Condensed',
  //   'Oswald',
  //   'Pacifico',
  //   // 'PaletteMosaic',
  //   'Permanent Marker',
  //   'Prompt',
  //   'Questrial',
  //   'Rajdhani',
  //   'Raleway',
  //   'Russo One',
  //   'Shadows Into Light',
  //   'Concert One',
  //   // 'StyleScript',
  //   'Teko',
  //   'Titillium Web',
  //   // 'WindSong',
  //   'Yanone Kaffeesatz',
  // ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback(_afterLayout);
    fontBuilder();
  }

  List<Widget> builtFonts = [];

  fontBuilder() async {
    Stream<QuerySnapshot> stream = firestore
        .collection('FontsCollection')
        .orderBy('timestamp', descending: false)
        .snapshots();
    stream.listen((snapshot) {
      var fontList = snapshot.docs;
      for (var fontName in fontList) {
        var widget;
        var fontNameToBeUsed = (fontName.data() as dynamic)['font'];

        try {
          widget = Padding(
            padding: const EdgeInsets.symmetric(vertical: 1),
            child: Material(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      font = fontNameToBeUsed;
                    });
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 70,
                    width: 220,
                    decoration: BoxDecoration(
                      color: Color(0xFFF3F4F5),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Center(
                      child: Text(
                        fontNameToBeUsed,
                        style: GoogleFonts.getFont(
                            fontNameToBeUsed,
                            textStyle: TextStyle(fontSize: 20)),
                      ),
                    ),
                  ),
                )),
          );
          builtFonts.add(widget);
        } catch (e) {}
      }
    });
    // for (var fontName in fontList) {
    //   var widget;

    //   try {
    //     widget = Padding(
    //       padding: const EdgeInsets.symmetric(vertical: 1),
    //       child: Material(
    //           borderRadius: BorderRadius.all(Radius.circular(15)),
    //           child: InkWell(
    //             onTap: () {
    //               setState(() {
    //                 font = fontName;
    //               });
    //               Navigator.pop(context);
    //             },
    //             child: Container(
    //               height: 70,
    //               width: 220,
    //               decoration: BoxDecoration(
    //                 color: Color(0xFFF3F4F5),
    //                 borderRadius: BorderRadius.all(Radius.circular(15)),
    //               ),
    //               child: Center(
    //                 child: Text(
    //                   fontName,
    //                   style: GoogleFonts.getFont(fontName,
    //                       textStyle: TextStyle(fontSize: 20)),
    //                 ),
    //               ),
    //             ),
    //           )),
    //     );
    //     builtFonts.add(widget);
    //   } catch (e) {}
    // }
  }

  Offset? containerPosition;

  Offset? position;

  var upperLimit;
  void _getRenderOffsets() {
    final RenderBox? renderBoxWidget =
        globalKey.currentContext!.findRenderObject() as RenderBox;
    final offset = renderBoxWidget!.localToGlobal(
      Offset.zero,
    );

    upperLimit = offset.dy;
    containerPosition = offset;
    containerPosition =
        Offset(containerPosition!.dx + 1, containerPosition!.dy + 1);
  }

  void _afterLayout(_) {
    _getRenderOffsets();
  }

  double prevScale = 1;
  double scale = 1;

  void updateScale(double zoom) => setState(() => scale = prevScale * zoom);
  void commitScale() => setState(() => prevScale = scale);

  // String myData = "";
  var imageFile;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var size = (height * width) / 1000;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: height * 3 / 100,
              color: Color(0xFFE73AAF),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 6 / 100),
              child: Material(
                elevation: 2,
                color: Color(0xFFF3F4F5),
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: Container(
                  height: height * 7 / 100,
                  padding: EdgeInsets.symmetric(horizontal: width * 5 / 100),
                  decoration: BoxDecoration(
                    color: Color(0xFFF3F4F5),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Center(
                    child: TextField(
                      style: TextStyle(fontSize: size * 6.5 / 100),
                      onChanged: (value) {
                        setState(() {
                          name = value;
                        });
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter Your Name',
                        hintStyle: TextStyle(fontSize: size * 6.5 / 100),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              key: globalKey,
              width: width,
              height: height * 50 / 100,
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.green)),
              child: GestureDetector(
                onScaleUpdate: (details) => updateScale(details.scale),
                onScaleEnd: (_) => commitScale(),
                child: Screenshot(
                  controller: screenshotController,
                  // key: globalKey1,
                  child: Stack(
                    // overflow: Overflow.clip,
                    clipBehavior: Clip.antiAlias,
                    children: [
                      Container(
                        color: Colors.black,

                        child: Center(
                          child: CachedNetworkImage(
                            imageUrl:
                                //'https://www.theattitudequotes.com/wp-content/uploads/2021/03/Boys-Dp-Pic-Attitude-Boy-Pic-41.jpg',
                                widget.path,
                            fit: BoxFit.contain,
                            placeholder: (context, url) => Container(
                              child: Center(
                                child: Text(
                                  'Please Wait..',
                                  style: TextStyle(
                                      fontSize: size * 7 / 100,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),

                        // )),
                      ),
                      Positioned(
                        left: (position == null)
                            ? width / 2.75
                            : position!.dx
                                .clamp(0, width - (width * 30 / 100))
                                .toDouble(),
                        top: (position == null)
                            ? 120
                            : position!.dy
                                .clamp(
                                    -4,
                                    // containerPosition!.dy +
                                    (height * 46.5 / 100))
                                .toDouble(),
                        child: Draggable<String>(
                          maxSimultaneousDrags: 1,
                          data: name,
                          feedback: Material(
                            //  color: Colors.white.withOpacity(0.0),
                            child: Transform.scale(
                              scale: scale,
                              child: Text(name,
                                  maxLines: 1,
                                  style: GoogleFonts.getFont(
                                    font,
                                    textStyle: TextStyle(
                                        fontSize: 20,
                                        color: currentColor,
                                        // fontFamily: font,
                                        fontWeight: FontWeightSelecter.select(
                                            value: weight)),
                                  )),
                            ),
                          ),
                          childWhenDragging: Container(),
                          child: Transform.scale(
                            scale: scale,
                            child: Text(name,
                                maxLines: 1,
                                style: GoogleFonts.getFont(
                                  font,
                                  textStyle: TextStyle(
                                      fontSize: 20,
                                      color: currentColor,
                                      // fontFamily: font,
                                      fontWeight: FontWeightSelecter.select(
                                          value: weight)),
                                )),
                          ),
                          onDragEnd: (drag) {
                            setState(() {
                              // if (drag.offset.dy >
                              //     containerPosition!.dy +
                              //         (height * 46.5 / 100)) {
                              //   position = Offset(
                              //           drag.offset.dx,
                              //           containerPosition!.dy +
                              //               (height * 46.5 / 100)) -
                              //       containerPosition!;
                              // }
                              // if (drag.offset.dx > width) {
                              //   position = Offset(width + (width * 10.5 / 100),
                              //       drag.offset.dx - containerPosition!.dx);
                              // }
                              // else {
                              position = drag.offset - containerPosition!;
                              // }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(child: Container()),
                buttonContainer(() {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Fonts'),
                          content: Container(
                              height: height * 50 / 100,
                              child: SingleChildScrollView(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: builtFonts))),
                        );
                      });
                }, height, width, 'images/font.png', 'Font', size),
                SizedBox(
                  width: width * 18 / 100,
                ),
                buttonContainer(() {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Pick a color!'),
                      content: SingleChildScrollView(
                        child: ColorPicker(
                          pickerColor: pickerColor,
                          onColorChanged: (color) {
                            setState(() {
                              pickerColor = color;
                            });
                          },
                          // changeColor,
                          showLabel: true,
                          pickerAreaHeightPercent: 0.8,
                        ),
                      ),
                      actions: <Widget>[
                        FlatButton(
                          child: const Text('Got it'),
                          onPressed: () {
                            setState(() => currentColor = pickerColor);
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  );
                }, height, width, 'images/chromatic.png', 'Colours', size),
                Expanded(child: Container()),
              ],
            ),
            Material(
              elevation: 2,
              color: Color(0xFFF3F4F5),
              borderRadius: BorderRadius.all(Radius.circular(20)),
              child: InkWell(
                //  splashColor: Color(0xFFE73AAF).withOpacity(0.4),
                onTap: () {
                  try {
                    takeSS();
                    AlertController.show("Success!!!",
                        "Image Saved successfully!", TypeAlert.success);
                  } catch (e) {
                    AlertController.show(
                        "Oops!!!", "An error occurred!", TypeAlert.error);
                  }
                },
                child: Container(
                  height: height * 13 / 100,
                  width: width * 77 / 100,
                  decoration: BoxDecoration(
                    color: Color(0xFFF3F4F5),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: height * 6 / 100,
                        width: width * 12 / 100,
                        child: Image.asset('images/save_file.png'),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: width * 4 / 100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Save Image',
                              style: TextStyle(
                                  fontSize: size * 6.5 / 100,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: height * 0.7 / 100,
                            ),
                            Container(
                              width: width * 40 / 100,
                              child: Text(
                                'Images will be saved in DPMaker folder',
                                style: TextStyle(fontSize: size * 5 / 100),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container(),
          ],
        ),
      ),
    );
  }

  takeSS() async {
    var path = await getAppDirectory();
    if (path != null) {
      var savedFilePath = await screenshotController.captureAndSave(path);
      print(savedFilePath);
      // save(file: File(savedFilePath!));
    }
  }

  getAppDirectory({image}) async {
    var directory;

    if (await _requestPermission(Permission.storage)) {
      if (await _requestPermission(Permission.manageExternalStorage)) {
        directory = (await getExternalStorageDirectory())!;
        String newPath = "";
        List<String> paths = directory.path.split("/");
        for (int x = 1; x < paths.length; x++) {
          String folder = paths[x];
          if (folder != "Android") {
            newPath += "/" + folder;
          } else {
            break;
          }
        }
        newPath = newPath + "/DPMaker";
        directory = Directory(newPath).path;
      } else {
        directory = (await getExternalStorageDirectory())!;
        String newPath = "";
        List<String> paths = directory.path.split("/");
        for (int x = 1; x < paths.length; x++) {
          String folder = paths[x];
          if (folder != "Android") {
            newPath += "/" + folder;
          } else {
            break;
          }
        }

        newPath = newPath + "/DPMaker";
        directory = Directory(newPath).path;
      }
    }

    return directory;
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  // save({file}) async {
  //   print(file);
  //   await ImageGallerySaver.saveImage(
  //       Uint8List.fromList(await file.readAsBytes()),
  //       quality: 100);
  // }

  Material buttonContainer(VoidCallback voidCallback, double height,
      double width, String imageAddress, String name, double size) {
    return Material(
      elevation: 2,
      color: Color(0xFFF3F4F5),
      borderRadius: BorderRadius.all(Radius.circular(20)),
      child: InkWell(
        //  splashColor: Color(0xFFE73AAF).withOpacity(0.4),
        onTap: voidCallback,
        child: Container(
          height: height * 13 / 100,
          width: width * 26.5 / 100,
          decoration: BoxDecoration(
            color: Color(0xFFF3F4F5),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(),
              Container(
                  height: height * 6 / 100,
                  width: width * 12 / 100,
                  //   color: Colors.orange,
                  child: Image.asset(imageAddress)),
              Text(
                name,
                style: TextStyle(
                    fontSize: size * 5.75 / 100, fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class FontWeightSelecter {
  static select({value}) {
    if (value == '100') {
      return FontWeight.w100;
    } else if (value == '200') {
      return FontWeight.w200;
    } else if (value == '300') {
      return FontWeight.w300;
    } else if (value == '400') {
      return FontWeight.w400;
    } else if (value == '500') {
      return FontWeight.w500;
    } else if (value == '600') {
      return FontWeight.w600;
    } else if (value == '700') {
      return FontWeight.w700;
    } else if (value == '800') {
      return FontWeight.w800;
    } else if (value == '900') {
      return FontWeight.w900;
    }
  }
}
