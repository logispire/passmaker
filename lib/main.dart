import 'dart:convert';
import 'dart:html' as html;
import 'dart:io';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_cropper_for_web/image_cropper_for_web.dart';
import 'package:image_picker/image_picker.dart';
import 'package:passmaker/FunctionIconButton.dart';
import 'package:passmaker/MyTextFormField.dart';
import 'package:screenshot/screenshot.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_strategy/url_strategy.dart';

import 'constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft])
      .then((_) {
    runApp(const MyApp());
  });
  // runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          fontFamily: 'Montserrat',
          primarySwatch: MaterialColor(0XFF383061, appPrimaryColorSwatch)),
      home: const MyHomePage(title: 'SANKAP SE SAFALTA'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ImagePicker picker = ImagePicker();
  html.File? pickedImage;
  html.File? companyLog0;
  Uint8List? file1;
  Uint8List? companyList;
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    // precacheImage(AssetImage("images/Placeholder.png"), context);
  }

  //todo remove this
  TextEditingController textEditingController = TextEditingController();
  TextEditingController companyTxt = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  uploadImage() async {
    // WEB
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker
        .pickImage(
      source: ImageSource.gallery,
    )
        .then((value) {
      if (value != null) {
        cropImageVertical(value);
      }
    });
  }

  uploadCompanyImage() async {
    // WEB
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
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
        presentStyle: CropperPresentStyle.page,
        boundary: Boundary(
          width: 450,
          height: 450,
        ),
        viewPort: ViewPort(
            width: 389 * 1.5.toInt(),
            height: 151 * 1.5.toInt(),
            type: 'square'),
        enableExif: true,
        enableZoom: true,
        showZoomer: true,
      ),
    ]).then((value) async {
      if (value != null) {
        var f = await value.readAsBytes();
        setState(() {
          companyList = f;
        });
      }
    });
    // if (croppedFile != null) {
    //     var f = await croppedFile.readAsBytes().then((value) {
    //       companyList=value;
    //     });
    //     setState(() {
    //       companyList=f;
    //     });
    // }
  }

  cropImageVertical(XFile pickedImage) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedImage.path,
        compressQuality: 90,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          WebUiSettings(
            context: context,
            presentStyle: CropperPresentStyle.page,
            boundary: Boundary(
              width: MediaQuery.of(context).size.width.toInt(),
              height: 400,
            ),
            viewPort: ViewPort(
                width: 220 * 1.5.toInt(),
                height: 288 * 1.5.toInt(),
                type: 'rectangle'),
            enableExif: true,
            enableZoom: true,
            showZoomer: true,
          ),
        ]).then((value) async {
      if (value != null) {
        var f = await value.readAsBytes();
        setState(() {
          file1 = f;
        });
      }
    });
//     if (croppedFile != null) {
//
//         var f = await croppedFile.readAsBytes().then((value){
//           file1=value;
//         });
//         setState(() {
// file1 =f;
//         });
//     }
  }

  @override
  Widget build(BuildContext context) {
    var Size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          height: Size.height,
          width: 500,
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Screenshot(
                    controller: screenshotController,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 249,
                          left: 316,
                          height: 144,
                          width: 110,
                          child: file1 == null
                              ? Container(
                                  width: 100,
                                  height: 100,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage("images/Avtar.png"),
                                    ),
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: MemoryImage(file1!))),
                                ),
                        ),
                        Image.asset(
                          "images/Placeholder.png",
                          width: 500,
                          height: 500,
                        ),
                        Positioned(
                          width: 160,
                          bottom: 88,
                          right: 48,
                          height: 20,
                          child: Container(
                            padding: EdgeInsets.only(right: 4,left: 4),
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                                // border: Border.all(width: 2)
                                ),
                            child: AutoSizeText(
                              textEditingController.text.trim(),
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: appPrimaryColor),
                              minFontSize: 3,
                            ),
                          ),
                        ),
                        Positioned(
                          width: 160,
                          bottom: 77,
                          right: 48,
                          height: 15,
                          child: Container(
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                                // border: Border.all(width: 2)
                                ),
                            child: AutoSizeText(
                              companyTxt.text.trim(),
                              style: TextStyle(
                                  fontSize: 15, color: appPrimaryColor),
                              minFontSize: 3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                  child: MyTextFormField(
                    label: "Your Name",
                    controller: textEditingController,
                    hintText: "Enter your Name Here",
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.name,
                    maxLines: 1,
                    maxLength: 20,
                    onChanged: (value) {
                      setState(() {});
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter a name";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                  child: MyTextFormField(
                    label: "Company Name",
                    controller: companyTxt,
                    hintText: "Enter your Company name Here",
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.name,
                    maxLines: 1,
                    maxLength: 21,
                    onChanged: (value) {
                      setState(() {});
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter company name";
                      }
                      return null;
                    },
                  ),
                ),
                // FunctionIconButton(),
                FunctionIconButton(
                    onPressed: () async {
                      uploadImage();
                    },
                    icon: CupertinoIcons.person_alt,
                    label: "Upload user's image"),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: FunctionIconButton(
                    onPressed: () async {
                      if (file1 == null) {
                        Fluttertoast.showToast(
                            msg: "Please Upload Profile Image",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        return;
                      }
                      if (formKey.currentState!.validate()) {
                        await screenshotController
                            .capture(
                                pixelRatio: 2,
                                delay: Duration(milliseconds: 300))
                            .then((value) {
                          if (value == null) {
                            Fluttertoast.showToast(
                                msg: "Failed to generate Image",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                          final base64data = base64Encode(value!.toList());
                          final a = html.AnchorElement(
                              href: 'data:image/jpeg;base64,$base64data');
                          a.download = 'download.jpg';
                          a.click();
                          a.remove();
                        });
                      }
                    },
                    icon: CupertinoIcons.cloud_download_fill,
                    label: "Download Image",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: InkWell(
                    onTap: () async {
                      await launchUrl(
                        Uri.parse("https://wa.me/+919429828152"),
                        mode: LaunchMode.externalApplication,
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Developed By",
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.withOpacity(0.7)),
                        ),
                        Image.asset(
                          "images/logo.webp",
                          height: 30,
                        ),
                        Text(
                          "Logispire IT Solution",
                          style: TextStyle(
                            color: Color(0xff00285b),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20,top: 5),
                          child: Text(
                            "Mobile Application Development, Website Development\nGraphic Design, Web-based CRM",
                            style:
                                TextStyle(fontSize: 9, color: Color(0xff00285b),),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
