import 'package:cloud_firestore/cloud_firestore.dart';

class BackendServices {
  final firestore = FirebaseFirestore.instance;

  updateImageList({var link, var gender}) async {
    var time = DateTime.now();
    var currentTime = time;

    if (gender == 'Boy') {
      await firestore
          .collection('BoysImagesCollection')
          .add({'timestamp': currentTime, 'link': link});
    }
    else if (gender=='Girl'){
         await firestore
          .collection('GirlsImagesCollection')
          .add({'timestamp': currentTime, 'link': link});
    }
  }
  updateFontsList({var font}) async {
    var time = DateTime.now();
    var currentTime = time;

    
      await firestore
          .collection('FontsCollection')
          .add({'timestamp': currentTime, 'font': font});
    
  }
}
