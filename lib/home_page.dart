import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:signature/signature.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late SignatureController controller;
  double signHeight = 200;
  Color signBackColor = Colors.green.shade100;
  Color signPenColor = Colors.grey.shade900;

  @override
  void initState() {
    super.initState();
    controller = SignatureController(
      penStrokeWidth: 2,
      exportBackgroundColor: signBackColor,
      exportPenColor: signPenColor,
      penColor: signPenColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter Signature')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(15),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Signature(
                  controller: controller,
                  backgroundColor: signBackColor,
                  width: MediaQuery.of(context).size.width,
                  height: signHeight,
                ),
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.green),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
              onPressed: () => exportSignature(),
              child: Text(
                "Export Signature to Image",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  exportSignature() async {
    double height = signHeight;
    double width = MediaQuery.of(context).size.width;
    Uint8List? bytes = await controller.toPngBytes(
      height: height.toInt(),
      width: width.toInt(),
    );
    if (bytes != null) {
      SaverGallery.saveImage(
        bytes,
        fileName: 'my_sign',
        extension: 'jpg',
        skipIfExists: false,
      ).then((result) {
        if (result.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Signature saved successfully.")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Signature failed to save. ${result.errorMessage}"),
            ),
          );
        }
      });
    }
  }
}
