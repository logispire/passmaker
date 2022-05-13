import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_cropper_for_web/image_cropper_for_web.dart';
import 'package:image_picker/image_picker.dart';
import 'package:passmaker/ImageBlock.dart';
import 'package:passmaker/MyTextFormField.dart';
import 'package:screenshot/screenshot.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft])
      .then((_) {
    runApp(new MyApp());
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
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Sankalap'),
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
  TextEditingController textEditingController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  uploadImage() async {
    // WEB
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    ).then((value) {
      if(value != null){
        cropImageVertical(value);
      }
    });

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
        presentStyle: CropperPresentStyle.page,
        boundary: Boundary(
          width: 450,
          height: 450,
        ),
        viewPort: ViewPort(width: 180, height: 70, type: 'square'),
        enableExif: true,
        enableZoom: true,
        showZoomer: true,
      ),
    ]).then((value) async{
      if(value != null){
        var f = await value.readAsBytes();
        setState(() {
          companyList=f;
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
        viewPort: ViewPort(width: 138, height: 175, type: 'rectangle'),
        enableExif: true,
        enableZoom: true,
        showZoomer: true,
      ),
    ]).then((value) async{
      if(value != null){
        var f=await value.readAsBytes();
        setState(() {
          file1=f;
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
    return Scaffold(
      body: MediaQuery.of(context).size.width<500?Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.screen_rotation,size: 45,),
          Text("\nPlease Rotate Your Phone horizontally, and then try"),
        ],
      ),):SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
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
                          ? Container(
                              width: 100, height: 100, color: Colors.amber)
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
                        decoration: BoxDecoration(
                            // border: Border.all(width: 2)
                            ),
                        child: Text(
                          "${textEditingController.text.trim()}",
                          style: TextStyle(
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
                              child: Text("Company logo here"),
                            )
                          : Container(
                              decoration: BoxDecoration(
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
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MyTextFormField(
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
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          uploadImage();
                        },
                        child: const Text("Upload user's image")),
                    SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          uploadCompanyImage();
                        },
                        child: const Text("Upload company's logo")),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 200),
                child: ElevatedButton(
                  onPressed: () async {
                    if(file1 ==null){
                      Fluttertoast.showToast(
                          msg: "Please Upload Profile Image",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                      return ;
                    }
                    if(companyList ==null){
                      Fluttertoast.showToast(
                          msg: "Please Upload Company Logo",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                      return ;
                    }
                    if (formKey.currentState!.validate()) {
                      await screenshotController.capture()
                      // .captureFromWidget(Container(
                      //   height: 200,
                      //   width: 300,
                      //   decoration: BoxDecoration(
                      //     color: Colors.red,
                      //
                      //   ),
                      // ))
                          .then((value) {
                        if (value == null) {
                          Fluttertoast.showToast(
                              msg: "Failed to generate Image",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );
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
                  child: Text("Download Image"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
