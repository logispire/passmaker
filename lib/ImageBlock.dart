import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_cropper_for_web/image_cropper_for_web.dart';
import 'package:image_picker/image_picker.dart';
import 'package:passmaker/MyTextFormField.dart';
import 'package:screenshot/screenshot.dart';

class ImageBlock extends StatefulWidget {
  const ImageBlock({Key? key}) : super(key: key);

  @override
  State<ImageBlock> createState() => _ImageBlockState();
}

class _ImageBlockState extends State<ImageBlock> {
  ImagePicker picker = ImagePicker();
  html.File? pickedImage;
  html.File? companyLog0;
  Uint8List? file1;
  Uint8List? companyList;
  ScreenshotController screenshotController = ScreenshotController();
  TextEditingController textEditingController = TextEditingController(text: "Ruchit Mavani");

  uploadImage() async {
    // WEB
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (image != null) {
      cropImageVertical(image);
    }
  }

  uploadCompanyImage() async {
    // WEB
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (image != null) {
      cropImageHorizontal(image);
    }
  }

  cropImageHorizontal(XFile pickedImage) async {
    CroppedFile? croppedFile = await ImageCropper()
        .cropImage(sourcePath: pickedImage.path, aspectRatioPresets: [
      CropAspectRatioPreset.square,
    ], uiSettings: [
      WebUiSettings(
        context: context,
        presentStyle: CropperPresentStyle.dialog,
        boundary: Boundary(
          width: 450,
          height: 450,
        ),
        viewPort: ViewPort(width: 180, height: 180, type: 'square'),
        enableExif: true,
        enableZoom: true,
        showZoomer: true,
      ),
    ]);
    if (croppedFile != null) {
      setState(() async {
        var f = await croppedFile.readAsBytes();
        setState(() {
          companyList = f;
        });
      });
    }
  }

  cropImageVertical(XFile pickedImage) async {
    CroppedFile? croppedFile = await ImageCropper()
        .cropImage(sourcePath: pickedImage.path, aspectRatioPresets: [
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio16x9
    ], uiSettings: [
      WebUiSettings(
        context: context,
        presentStyle: CropperPresentStyle.dialog,
        boundary: Boundary(
          width: 450,
          height: 450,
        ),
        viewPort: ViewPort(width: 250, height: 100, type: 'rectangle'),
        enableExif: true,
        enableZoom: true,
        showZoomer: true,
      ),
    ]);
    if (croppedFile != null) {
      setState(() async {
        var f = await croppedFile.readAsBytes();
        setState(() {
          file1 = f;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Screenshot(
          controller: screenshotController,
          child: Stack(
            children: [
              Positioned(
                top: 72,
                left: 311,
                height: 175,
                width: 138,
                child: file1 == null
                    ? Container(width: 100, height: 100, color: Colors.amber)
                    : Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                            image: DecorationImage(image: MemoryImage(file1!))),
                      ),
              ),
              Opacity(
                opacity: 1.0,
                child: Image.asset(
                  "images/Placeholder.png",
                  width: 500,
                  height: 500,
                ),
              ),
              Positioned(
                width:225,
                top: 257,
                left: 265,
                child: Container(
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    // border: Border.all(width: 2)
                  ),
                  child: Text("${textEditingController.text.trim()}",style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),),
                ),
              ),
              Positioned(
                top: 300,
                left: 350,
                height: 70,
                width: 70,
                child: companyList == null
                    ? Container(alignment: Alignment.center,width: 100, height: 100, child: const Text("Company logo here"),)
                    : Container(
                  width: 100,
                  height: 100,
                  child: Image.memory(companyList!),
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            ElevatedButton(
                onPressed: () async {
                  uploadImage();
                },
                child: const Text("Upload user's image")),
            ElevatedButton(
                onPressed: () async {
                  uploadCompanyImage();
                },
                child: const Text("Upload company's logo")),
          ],
        ),
        MyTextFormField(
          controller: textEditingController,
          hintText: "Enter Your Name Here",
          maxLines: 1,
          maxLength: 20,
          onChanged: (value){
            setState(() {

            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please Enter a name";
            }
            return null;
          },
        )
      ],
    );
  }

  download(
    Uint8List bytes, {
    String? downloadName,
  }) {
    // Encode our file in base64
    try {
      final _base64 = base64Encode(bytes);
      // Create the link with the file
      final anchor = html.AnchorElement(
          href: 'data:application/octet-stream;base64,$_base64')
        ..setAttribute("download", "file.png");
      // add the name
      if (downloadName != null) {
        anchor.download = downloadName;
      }
      // trigger download
      html.document.body!.append(anchor);
      anchor.click();
      anchor.remove();
      return;
    } catch (e) {
      print(e);
    }
  }
}
