import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

class UploadImgs {
  String url;
  String descrip;

  void uploadStatusImg( List<File> imgs, bool validateAndSave) async {
    final StorageReference postImgRef =
        FirebaseStorage.instance.ref().child("Post Imgs");

    if (validateAndSave && imgs.isNotEmpty) {
      for (var img in imgs) {
        var timeKey = DateTime.now();
        final StorageUploadTask uploadTask =
        postImgRef.child(timeKey.toString() + ".jpg").putFile(img);
        var imgUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
        url = imgUrl.toString();
        print("===ImgURL=== $url");
        saveToDataBase(url);
      } 
      //save post a firebase real time
      
      print("==================VE A CHEACAR FIREBASE, RUUUUUUUN===========");
    }
  }

  void saveToDataBase(String url) {
    var dbTimeKey = DateTime.now();
    var formatDate = DateFormat('MMM d, yyyy');
    var formatTime = DateFormat('EEEE, hh:mm aaa');

    String date = formatDate.format(dbTimeKey);
    String time = formatTime.format(dbTimeKey);

    DatabaseReference ref = FirebaseDatabase.instance.reference();
    var data = {"img": url, "description": descrip, "date": date, "time": time};
    ref.child("Posts").push().set(data);
  }
}