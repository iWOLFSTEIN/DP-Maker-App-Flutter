import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dp_maker_app/AddImageScreen.dart';
import 'package:dp_maker_app/AdsIds.dart';
import 'package:dp_maker_app/EditingScreen.dart';
import 'package:dp_maker_app/MainScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dropdown_alert/alert_controller.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:progress_dialog/progress_dialog.dart';

class ImagesScreen extends StatefulWidget {
  ImagesScreen({Key? key, this.genderData}) : super(key: key);

  String? genderData;

  @override
  _ImagesScreenState createState() => _ImagesScreenState();
}

class _ImagesScreenState extends State<ImagesScreen> {
  var bannerAd;
  final firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    bannerAd = myBanner();
    bannerAd.load();
  }

  BannerAd myBanner() => BannerAd(
        adUnitId: BANNER2_AD_ID,
        // BannerAd.testAdUnitId,
        size: AdSize.getSmartBanner(Orientation.portrait),
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

  var path;

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
            StreamBuilder<QuerySnapshot>(
                stream: firestore
                    .collection(widget.genderData! + 'ImagesCollection')
                    .orderBy('timestamp', descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.none) {
                    return Center(
                      child: Text(
                        'Loading Images..',
                        style: TextStyle(
                            fontSize: size * 7 / 100,
                            fontWeight: FontWeight.bold),
                      ),
                    );
                  }

                  var images = snapshot.data!.docs;
                  List<Widget> imagesWidgetList = [];
                  for (var image in images) {
                    var imageLink = (image.data() as dynamic)['link'];

                    try {
                      var widget = Material(
                          color: Color(0xFFF3F4F5),
                          elevation: 2,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xFFF3F4F5),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return EditingScreen(
                                      path: imageLink,
                                    );
                                  }));
                                },
                                child: CachedNetworkImage(
                                  imageUrl: imageLink,
                                  fit: BoxFit.cover,
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
                            ),
                          ));
                      imagesWidgetList.add(widget);
                    } catch (e) {}
                  }

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: (height * 3 / 100) + 50),
                        Padding(
                          padding: EdgeInsets.only(
                              left: width * 3 / 100,
                              top: height * 1.5 / 100,
                              bottom: height * 2 / 100),
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Choose Photo.',
                              style: TextStyle(
                                  fontSize: size * 7 / 100,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: width * 3 / 100,
                              right: width * 3 / 100,
                              top: height * 0 / 100),
                          child: GridView.count(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            mainAxisSpacing: height * 2.25 / 100,
                            crossAxisSpacing: width * 3 / 100,
                            crossAxisCount: 2,
                            children: imagesWidgetList,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            BackgroundDesign(height: height),
            Padding(
              padding: EdgeInsets.only(top: height * 3 / 100),
              child: Container(
                color: Colors.blue.withOpacity(0.6),
                child: adWidget,
                width: width,
                height: 90,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: size * 15 / 100,
        ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AddImageScreen();
          }));
        },
      ),
    );
  }
}
