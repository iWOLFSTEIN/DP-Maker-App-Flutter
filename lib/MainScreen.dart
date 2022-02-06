import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dp_maker_app/AdsIds.dart';
import 'package:dp_maker_app/GenderSelectionScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown_alert/alert_controller.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var bannerAd;
  final firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    bannerAd = myBanner();
    bannerAd.load();
  }

  var _interstitialAd;

  loadInterstitialAd() => InterstitialAd.load(
      adUnitId: INTERSTITIAL_AD_ID,
      // InterstitialAd.testAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          // Keep a reference to the ad so you can show it later.
          this._interstitialAd = ad;

          ad.show();
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error');
        },
      ));

  BannerAd myBanner() => BannerAd(
        adUnitId: BANNER1_AD_ID,
        // BannerAd.testAdUnitId,
        size: AdSize.mediumRectangle,
        request: AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (Ad ad) => print('Ad loaded.'),
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            ad.dispose();
            print('Ad failed to load: $error');
          },
          onAdOpened: (Ad ad) => print('Ad opened.'),
          onAdClosed: (Ad ad) => print('Ad closed.'),
          onAdImpression: (Ad ad) => print('Ad impression.'),
        ),
      );

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var size = (height + width) / 4;

    AdWidget adWidget = AdWidget(
      ad: bannerAd,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Stack(
        children: [
          BackgroundDesign(height: height),
          Column(
            children: [
              Expanded(child: Container()),
              Container(
                alignment: Alignment.center,
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    child: adWidget),
                width: bannerAd.size.width.toDouble(),
                height: bannerAd.size.height.toDouble(),
              ),
              SizedBox(
                height: height * 5 / 100,
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: Container()),
                      buttonContainer(height, width, 'images/createdp2.png',
                          'Create DP', size, voidCallback: () {
                        loadInterstitialAd();

                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return GenderSelectionScreen();
                        }));
                      }),
                      SizedBox(
                        width: width * 6 / 100,
                      ),
                      StreamBuilder<DocumentSnapshot>(
                          stream: firestore
                              .collection('AppLinks')
                              .doc('rateUsLink')
                              .snapshots(),
                          builder: (context, snapshot) {
                            return buttonContainer(
                                height,
                                width,
                                'images/rateappimg2.png',
                                'Rate Us',
                                size, voidCallback: () async {
                              var url = snapshot.data!['link'];
                              try {
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  AlertController.show(
                                      "Warning!!!",
                                      "Not Available Currently!",
                                      TypeAlert.warning);
                                }
                              } catch (e) {
                                AlertController.show(
                                    "Oops!!!",
                                    "An error occurred!",
                                    // e.toString(),
                                    TypeAlert.error);
                              }
                            });
                          }),
                      Expanded(child: Container()),
                    ],
                  ),
                  SizedBox(
                    height: height * 3 / 100,
                  ),
                  Row(
                    children: [
                      Expanded(child: Container()),
                      StreamBuilder<DocumentSnapshot>(
                          stream: firestore
                              .collection('AppLinks')
                              .doc('moreAppsLink')
                              .snapshots(),
                          builder: (context, snapshot) {
                            return buttonContainer(
                                height,
                                width,
                                'images/moreappsimg2.png',
                                'More Apps',
                                size, voidCallback: () async {
                              var url = snapshot.data!['link'];
                              try {
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  AlertController.show(
                                      "Warning!!!",
                                      "Not Available Currently!",
                                      TypeAlert.warning);
                                }
                              } catch (e) {
                                AlertController.show(
                                    "Oops!!!",
                                    "An error occurred!",
                                    // e.toString(),
                                    TypeAlert.error);
                              }
                            });
                          }),
                      SizedBox(
                        width: width * 6 / 100,
                      ),
                      buttonContainer(height, width, 'images/exitapp2.png',
                          'Exit App', size, voidCallback: () {
                        if (Platform.isAndroid) {
                          SystemChannels.platform
                              .invokeMethod('SystemNavigator.pop');
                        }
                      }),
                      Expanded(child: Container()),
                    ],
                  ),
                ],
              ),
              Expanded(child: Container()),
            ],
          )
        ],
      )),
    );
  }

  Material buttonContainer(
      double height, double width, String imageAdress, String name, double size,
      {VoidCallback? voidCallback}) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.all(Radius.circular(15)),
      color: Color(0xFFF3F4F5),
      child: InkWell(
        //   splashColor: Color(0xFFE73AAF).withOpacity(0.4),
        onTap: voidCallback,
        child: Container(
          height: height * 18 / 100,
          width: width * 35 / 100,
          decoration: BoxDecoration(
            // color: Colors.orange,
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(),
              Container(
                  height: height * 8.5 / 100,
                  width: width * 17 / 100,
                  // color: Colors.orange,
                  child: Image.asset(
                    imageAdress,
                  )),
              Text(
                name,
                style: TextStyle(
                    fontSize: size * 6.5 / 100,
                    // fontWeight: FontWeight.bold
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class BackgroundDesign extends StatelessWidget {
  const BackgroundDesign({
    Key? key,
    required this.height,
  }) : super(key: key);

  final double height;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: height * 3 / 100,
          color: Color(0xFFE73BAF),
        ),
        Image.asset('images/design1.png')
      ],
    );
  }
}
