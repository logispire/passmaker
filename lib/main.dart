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
import 'package:passmaker/ImageBlock.dart';
import 'package:passmaker/MyTextFormField.dart';
import 'package:passmaker/helperFunction.dart';
import 'package:printing/printing.dart';
import 'package:screenshot/screenshot.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

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


  @override
  void initState() {
    super.initState();
    precacheImage(AssetImage("images/Placeholder.png"), context);
  }
  //todo remove this
  TextEditingController textEditingController =
      TextEditingController();
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
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              MediaQuery.of(context).size.width < 500
                  ? Stack(
                      children: [
                        Positioned(
                          top: Size.width * 72 / 500,
                          left: Size.width * 311 / 500,
                          height: Size.width * 175 / 500,
                          width: Size.width * 138 / 500,
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
                            width: Size.width,
                            height: Size.width,
                          ),
                        ),
                        Positioned(
                          width: Size.width * 225 / 500,
                          top: Size.width * 257 / 500,
                          left: Size.width * 265 / 500,
                          child: Container(
                            height: 30,
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
                              maxLines: 1,
                            ),
                          ),
                        ),
                        Positioned(
                          top: Size.width * 300 / 500,
                          left: Size.width * 290 / 500,
                          height: Size.width * 70 / 500,
                          width: Size.width * 180 / 500,
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
                    )
                  : Stack(
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

                      // await compute(
                      //     await buildPdf(
                      //       const PdfPageFormat(1080,1080),
                      //     ),
                      //     "Q");

                      await screenshotController
                          .captureFromWidget(Stack(
                        children: [
                          Positioned(
                            top: calculate(72),
                            left: calculate(311),
                            height: calculate(175),
                            width: calculate(138),
                            child: file1 == null
                                ? Container(color: Colors.amber)
                                : SizedBox(
                                    width: 100,
                                    height: 100,
                                    child:
                                        Image.memory(file1!, fit: BoxFit.cover),
                                  ),
                          ),
                          Image.asset(
                            "images/Placeholder.png",
                            width: 350,
                            height: 350,
                            fit: BoxFit.contain,
                          ),
                          Positioned(
                            width: calculate(225),
                            top: calculate(257),
                            left: calculate(265),
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
                            top: calculate(300),
                            left: calculate(290),
                            height: calculate(70),
                            width: calculate(180),
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
                      ))
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
                        final base64data = base64Encode(value.toList());
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future buildPdf(PdfPageFormat format) async {
    pw.Document pdf = pw.Document();
    final montserrat = await PdfGoogleFonts.montserratSemiBold();

    final ByteData couponGift = await rootBundle.load('images/Placeholder.png');
    print(couponGift);
    final Uint8List couponGiftByteList = couponGift.buffer.asUint8List();
    // print(couponGiftByteList);

    pdf.addPage(pw.Page(
        theme: pw.ThemeData.withFont(
            base: await PdfGoogleFonts.montserratSemiBold()),
        build: (pw.Context context) {
          return pw.SizedBox(
            height: 1080,
            width: 1080,
            child: pw.Stack(
              children: [
                pw.Positioned(
                  top: calculate(72),
                  left: calculate(311),
                  child: file1 == null
                      ? pw.Container(
                          height: 378,
                          width: calculate(138),
                          color: PdfColors.amber)
                      : pw.Container(
                          height: 378,
                          width: calculate(138),
                          child: pw.Image(pw.MemoryImage(file1!),
                              fit: pw.BoxFit.cover),
                        ),
                ),
          pw.Positioned(
            top: 0,
                  left: 0,
                  child: pw.Image(
                    pw.MemoryImage(couponGiftByteList),
                    width: 1080,
                    height: 1080,
                    // fit: pw.BoxFit.cover,
                  ),
                ),
                pw.Positioned(
                  top: calculate(257),
                  left: calculate(265),
                  child: pw.Container(
                    width: calculate(225),
                    alignment: pw.Alignment.center,
                    decoration: pw.BoxDecoration(
                        // border: Border.all(width: 2)
                        ),
                    child: pw.Text(
                      "${textEditingController.text.trim()}",
                      style: pw.TextStyle(
                        fontSize: 40,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                pw.Positioned(
                  top: calculate(300),
                  left: calculate(290),
                  child: companyList == null
                      ? pw.Container(
                          height: calculate(70),
                          width: calculate(180),
                          alignment: pw.Alignment.center,
                          child: pw.Text("Company logo here"),
                        )
                      : pw.Container(
                          decoration: pw.BoxDecoration(
                              // border: Border.all(width: 2,color: Colors.green)
                              ),
                          alignment: pw.Alignment.center,
                          width: 100,
                          height: 100,
                          child: pw.Image(pw.MemoryImage(companyList!)),
                        ),
                ),
              ],
            ),
          );
        }));

    final bytes = await pdf.save();
    final blob = Blob([bytes], 'application/pdf');
    final url = Url.createObjectUrlFromBlob(blob);
    window.open(url, '_blank');
    Url.revokeObjectUrl(url);
    // setState(() {
    //   isDownload = false;
    // });
    return (String foo) {};
  }
}
