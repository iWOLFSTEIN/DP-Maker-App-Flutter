import 'package:dp_maker_app/ImagesScreen.dart';
import 'package:dp_maker_app/MainScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class GenderSelectionScreen extends StatefulWidget {
  GenderSelectionScreen({Key? key}) : super(key: key);

  @override
  _GenderSelectionScreenState createState() => _GenderSelectionScreenState();
}

class _GenderSelectionScreenState extends State<GenderSelectionScreen> {

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var size = (height + width) / 4;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            BackgroundDesign(height: height),
            Container(
              height: height / 1.8,
              // color: Colors.cyan,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //  Expanded(child:
                  Container(),
                  Container(),
                  Container(),
                  Container(),
                 
                  genderIdentityContainer(
                      width, height, 'images/maleimg.png', 'Boys', size,
                      voidCallback: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ImagesScreen(
                        genderData: 'Boys',
                      );
                    }));
                  }),
                  //),
                  genderIdentityContainer(
                      width, height, 'images/femaleimg.png', 'Girls', size,
                      voidCallback: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ImagesScreen(
                        genderData: 'Girls',
                      );
                    }));
                  }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Padding genderIdentityContainer(double width, double height,
      String imageAdress, String gender, double size,
      {VoidCallback? voidCallback}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 8 / 100),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Color(0xFFF3F4F5),
        child: InkWell(
        //  splashColor: Color(0xFFE73AAF).withOpacity(0.4),
          onTap: voidCallback,
          child: Container(
            height: height * 17 / 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(),
                Padding(
                  padding: EdgeInsets.only(
                      left: width * 0 / 100, bottom: height * 1.5 / 100),
                  child: Container(
                      //  color: Colors.red,
                      height: height * 12.5 / 100,
                      width: width * 25 / 100,
                      child: Image.asset(imageAdress)),
                ),
                Padding(
                  padding: EdgeInsets.only(left: width * 1 / 100),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        gender + ' DP Maker',
                        style: TextStyle(
                            fontSize: size * 7 / 100,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: height * 0.5 / 100,
                      ),
                      Container(
                        width: width * 45 / 100,
                        // color: Colors.orange,
                        child: Text(
                          'create good looking DP for ' + gender.toLowerCase(),
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: size * 5.3 / 100,
                            // fontWeight: FontWeight.bold
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: width * 9 / 100,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
