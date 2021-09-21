
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class ImageController{
   final picker = ImagePicker();

  Future<File> getImage() async{
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if(pickedFile != null){
      return File(pickedFile.path);}
          else{
            return File("assets/images/idSample.png");
    }
  }
}