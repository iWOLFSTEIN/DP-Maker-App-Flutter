import 'package:dp_maker_app/BackendServices.dart';
import 'package:dp_maker_app/MainScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown_alert/alert_controller.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AddImageScreen extends StatefulWidget {
  AddImageScreen({Key? key}) : super(key: key);

  @override
  _AddImageScreenState createState() => _AddImageScreenState();
}

class _AddImageScreenState extends State<AddImageScreen> {
  BackendServices backendServices = BackendServices();
  TextEditingController textEditingController = TextEditingController();
  TextEditingController textEditingController1 = TextEditingController();
  String? selectedGender = 'Boy';
  bool uploading = false;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var size = (height + width) / 4;
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: uploading,
        child: SafeArea(
            child: Stack(
          children: [
            // BackgroundDesign(
            //   height: height,
            // ),
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: height / 1.9,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: width * 2 / 100),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Add Image to Collection',
                            style: TextStyle(
                                fontSize: size * 9 / 100,
                                fontWeight: FontWeight.bold),
                          ),
                          TextField(
                            controller: textEditingController,
                            decoration: InputDecoration(
                                hintText: 'Enter image URL',
                                prefixIcon: Icon(Icons.link)),
                          ),
                          Container(
                            width: width * 80 / 100,
                            padding: EdgeInsets.symmetric(
                                horizontal: width * 3 / 100),
                            decoration: BoxDecoration(
                                //  color: Colors.orange,
                                border: Border.all(
                                    color: Colors.black.withOpacity(0.4)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: DropdownButton<String>(
                              style: TextStyle(
                                  fontSize: size * 6 / 100,
                                  color: Colors.black),
                              value: selectedGender,
                              isExpanded: true,
                              underline: SizedBox(),
                              items:
                                  <String>['Boy', 'Girl'].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: new Text(value),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedGender = value;
                                });
                              },
                            ),
                          ),
                          Container(
                            width: width,
                            height: height * 6 / 100,
                            child: ElevatedButton(
                                onPressed: () {
                                  try {
                                    if (!(textEditingController.text == '')) {
                                      setState(() {
                                        uploading = true;
                                      });
                                      backendServices.updateImageList(
                                          link: textEditingController.text,
                                          gender: selectedGender);

                                      textEditingController.text = '';
                                      setState(() {
                                        uploading = false;
                                      });

                                      AlertController.show(
                                          "Success!!!",
                                          "Image uploaded successfully!",
                                          TypeAlert.success);
                                    } else {
                                      AlertController.show(
                                          "Warning!!!",
                                          "Enter a valid image URL!",
                                          TypeAlert.warning);
                                    }
                                  } catch (e) {
                                    setState(() {
                                      uploading = false;
                                    });
                                    AlertController.show("Oops!!!",
                                        "An error occurred!", TypeAlert.error);
                                  }
                                },
                                child: Text(
                                  'Add',
                                  style: TextStyle(
                                      fontSize: size * 6 / 100,
                                      color: Colors.white),
                                )),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: height * 40 / 100,
                    // color: Colors.orange,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: width * 2 / 100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Add Fonts to Collection',
                            style: TextStyle(
                                fontSize: size * 9 / 100,
                                fontWeight: FontWeight.bold),
                          ),
                          TextField(
                            controller: textEditingController1,
                            decoration: InputDecoration(
                                hintText: 'Enter font name',
                                prefixIcon: Icon(Icons.font_download_outlined)),
                          ),
                          Container(
                            width: width,
                            height: height * 6 / 100,
                            child: ElevatedButton(
                                onPressed: () {
                                  try {
                                    if (!(textEditingController1.text == '')) {
                                      setState(() {
                                        uploading = true;
                                      });
                                      backendServices.updateFontsList(
                                        font: textEditingController1.text,
                                      );

                                      textEditingController1.text = '';
                                      setState(() {
                                        uploading = false;
                                      });

                                      AlertController.show(
                                          "Success!!!",
                                          "Font uploaded successfully!",
                                          TypeAlert.success);
                                    } else {
                                      AlertController.show(
                                          "Warning!!!",
                                          "Enter a valid font name!",
                                          TypeAlert.warning);
                                    }
                                  } catch (e) {
                                    setState(() {
                                      uploading = false;
                                    });
                                    AlertController.show("Oops!!!",
                                        "An error occurred!", TypeAlert.error);
                                  }
                                },
                                child: Text(
                                  'Add',
                                  style: TextStyle(
                                      fontSize: size * 6 / 100,
                                      color: Colors.white),
                                )),
                          ),
                          Container(
                            height: height * 4.5 / 100,
                          ),
                          // Container(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            BackgroundDesign(
              height: height,
            ),
          ],
        )),
      ),
    );
  }
}
