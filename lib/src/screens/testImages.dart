import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login_app/src/providers/upload_img_provider.dart';

class SingleImageUpload extends StatefulWidget {
  @override
  _SingleImageUploadState createState() {
    return _SingleImageUploadState();
  }
}

class _SingleImageUploadState extends State<SingleImageUpload> {
  UploadImgs upload= new UploadImgs();
  List<Object> images = List<Object>();
  List<File> imgs = List<File>();
  Future<File> _imageFile;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    setState(() {
      images.add("Add Image");
      images.add("Add Image");
      images.add("Add Image");
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          centerTitle: true,
          title: const Text('Image Test'),
        ),
        body: Column(
          children: <Widget>[
            Form(
              key: formKey,
              child: TextFormField(
                decoration: InputDecoration(labelText: "Descripción"),
                validator: (value) {
                  return value.isEmpty
                    ? "Se requiere una descripción del producto"
                    : null;
                },
                onSaved: (value) {
                  //upload.descrip = value;
                  return value;
                },
              ),
            ),
            Expanded(
              child: buildGridView(),
            ),
            RaisedButton(
              elevation: 10.0,
              child: Text("Upload Photo"),
              textColor: Colors.white,
              color: Colors.lightBlue,
              onPressed: (){
                //upload.uploadStatusImg(imgs,validateAndSave());
                clean();
              },
            )
          ],
        ),
      ),
    );
  }

  Widget buildGridView() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      childAspectRatio: 1,
      children: List.generate(images.length, (index) {
        if (images[index] is ImageUploadModel) {
          ImageUploadModel uploadModel = images[index];
          return Card(
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: <Widget>[
                Image.file(
                  uploadModel.imageFile,
                  width: 500,
                  height: 700,
                ),
                Positioned(
                  right: 5,
                  top: 5,
                  child: InkWell(
                    child: Icon(
                      Icons.remove_circle,
                      size: 20,
                      color: Colors.red,
                    ),
                    onTap: () {
                      if (index>0) {
                        imgs.removeAt(index);
                      }else{
                        imgs.remove(0);
                      }                    
                      setState(() {
                        images.replaceRange(index, index + 1, ['Add Image']);
                      });
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          return Card(
            child: IconButton(
              icon: Icon(Icons.add_a_photo),
              onPressed: () {
                _onAddImageClick(index);
              },
            ),
          );
        }
      }),
    );
  }

  void clean(){
    images.clear();
    initState();
  }

  Future _onAddImageClick(int index) async {
    setState(() {
      _imageFile = ImagePicker.pickImage(source: ImageSource.gallery);
      getFileImage(index);
    });
  }

  void getFileImage(int index) async {
    _imageFile.then((file) async {
      imgs.add(file);
      setState(() {
        ImageUploadModel imageUpload = new ImageUploadModel();
        imageUpload.imageFile = file;
        imageUpload.imageUrl = '';
        images.replaceRange(index, index + 1, [imageUpload]);
      });
    });
  }

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }
}

class ImageUploadModel {
  File imageFile;
  String imageUrl;

  ImageUploadModel({
    this.imageFile,
    this.imageUrl,
  });
}