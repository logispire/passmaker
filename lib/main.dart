import 'dart:convert';
import 'dart:html' as html;
import 'dart:html';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_cropper_for_web/image_cropper_for_web.dart';
import 'package:image_picker/image_picker.dart';
import 'package:passmaker/FunctionIconButton.dart';
import 'package:passmaker/ImageBlock.dart';
import 'package:passmaker/MyTextFormField.dart';
import 'package:passmaker/helperFunction.dart';
import 'package:printing/printing.dart';
import 'package:screenshot/screenshot.dart';
import 'package:pdf/pdf.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft])
      .then((_) {
    runApp(MyApp());
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
        primarySwatch: Colors.blue,
      ),
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
        viewPort: ViewPort(width: 389, height: 151, type: 'square'),
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
        presentStyle: CropperPresentStyle.page,
        boundary: Boundary(
          width: 450,
          height: 450,
        ),
        viewPort: ViewPort(width: 298, height: 378, type: 'rectangle'),
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
      backgroundColor: Colors.grey.shade100,
      body: SizedBox(
        height: Size.height,
        width: 500,
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: MediaQuery.of(context).size.width < 500
                    ? Screenshot(
                        controller: screenshotController,
                        child: Stack(
                          children: [
                            Positioned(
                              top: 72,
                              left: 311,
                              height: 175,
                              width: 138,
                              child: file1 == null
                                  ? Container(
                                      width: 100,
                                      height: 100,
                                      decoration: const BoxDecoration(
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: AssetImage(
                                                  "images/Avtar.png"))),
                                    )
                                  : Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: MemoryImage(file1!))),
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
                              width: 225,
                              top: 257,
                              left: 265,
                              child: Container(
                                height: 30,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                    // border: Border.all(width: 2)
                                    ),
                                child: Text(
                                  textEditingController.text.trim(),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 300,
                              left: 290,
                              height: 70,
                              width: 180,
                              child: companyList == null
                                  ? Container(
                                      alignment: Alignment.center,
                                      width: 100,
                                      height: 100,
                                      child: const Text("Company logo here"),
                                    )
                                  : Container(
                                      decoration: const BoxDecoration(
                                          // border: Border.all(width: 2,color: Colors.green)
                                          ),
                                      alignment: Alignment.center,
                                      width: 100,
                                      height: 100,
                                      child: Image.memory(companyList!),
                                    ),
                            ),
                          ],
                        ),
                      )
                    : Screenshot(
                        controller: screenshotController,
                        child: Stack(
                          children: [
                            Positioned(
                              top: 72,
                              left: 311,
                              height: 175,
                              width: 138,
                              child: file1 == null
                                  ? Container(
                                      width: 100,
                                      height: 100,
                                      decoration: const BoxDecoration(
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: AssetImage(
                                                  "images/Avtar.png"))),
                                    )
                                  : Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: MemoryImage(file1!))),
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
                              width: 225,
                              top: 257,
                              left: 265,
                              child: Container(
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                    // border: Border.all(width: 2)
                                    ),
                                child: Text(
                                  textEditingController.text.trim(),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 300,
                              left: 290,
                              height: 70,
                              width: 180,
                              child: companyList == null
                                  ? Container(
                                      alignment: Alignment.center,
                                      width: 100,
                                      height: 100,
                                      child: const Text("Company logo here"),
                                    )
                                  : Container(
                                      decoration: const BoxDecoration(),
                                      alignment: Alignment.center,
                                      width: 100,
                                      height: 100,
                                      child: Image.memory(companyList!),
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
                  textInputAction: TextInputAction.done,
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
                    const EdgeInsets.only(left: 20.0, right: 20.0, top: 10),
                child: MyTextFormField(
                  label: "Business Name",
                  controller: textEditingController,
                  hintText: "Enter Your Business Name",
                  textInputAction: TextInputAction.done,
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
              FunctionIconButton(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () async {
                      uploadImage();
                    },
                    child: const Text("Upload user's image")),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () async {
                      uploadCompanyImage();
                    },
                    child: const Text("Upload company's logo")),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 200),
                child: ElevatedButton(
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
                    if (companyList == null) {
                      Fluttertoast.showToast(
                          msg: "Please Upload Company Logo",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      return;
                    }
                    if (formKey.currentState!.validate()) {
                      await screenshotController.capture().then((value) {
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
                  child: const Text("Download Image"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
