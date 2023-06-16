import 'dart:io';
import 'package:camera/camera.dart';
import 'package:camera/camera.dart' show CameraController, CameraLensDirection, ImageFormatGroup;
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:minsu_v2/classifier.dart';
import 'dart:async';
import 'package:minsu_v2/label.dart';
import 'package:minsu_v2/main.dart';
import 'package:provider/provider.dart';

class CameraScreen extends StatefulWidget {
  final Function(int digit, String label, String message, List<String> images) onCaptureComplete;
  CameraScreen({required this.onCaptureComplete});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? controller;
  List<String> capturedImages = [];
  bool showCamera = true;

  Classifier classifier = Classifier();
  Label label = Label();
  int digit = -1;
  String current_label = "";
  String message = '';
  String name_assign = '';

  @override
  void initState() {
    super.initState();
    initializeCamera();
    Timer(Duration(seconds: 1), () {
      if (controller != null && controller!.value.isInitialized) {
        capturePhotos();
      }
    });
  }

   AssignName(name){
    name_assign = name;
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
    );
    controller = CameraController(
      frontCamera,
      ResolutionPreset.medium,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );
    await controller!.initialize();

    if (!mounted) return;

    setState(() {});
  }

  Future<void> capturePhotos() async {
    if (controller != null && controller!.value.isInitialized) {
      List<String> capturedImages = [];
      for (var i = 0; i < 5; i++) {
        final image = await controller!.takePicture();
        final imagePath = image.path;
        setState(() {
          capturedImages.add(imagePath);
        });
        await Future.delayed(Duration(seconds: 1));
      }
      digit = await classifier.classifyImage(capturedImages);
      Map<String, String> result = await label.Labeling(digit);
      current_label = result['label'] ?? '';
      message = result['message'] ?? '';

      Navigator.pop(context);

      widget.onCaptureComplete(digit, current_label, message, capturedImages);
    }
  }

  void toggleCameraView() {
    setState(() {
      showCamera = !showCamera;
    });
  }

  Widget buildCameraView() {
    if (controller == null || !controller!.value.isInitialized) {
      return Container();
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        final deviceRatio = size.width / size.height;
        final previewRatio = controller!.value.previewSize!.height /
            controller!.value.previewSize!.width;

        return FittedBox(
          fit: BoxFit.fitWidth,
          child: Container(
            width: size.width,
            height: size.width / previewRatio,
            child: CameraPreview(controller!),
          ),
        );
      },
    );
  }

  Widget buildImagePreview() {
    return ListView.builder(
      itemCount: capturedImages.length,
      itemBuilder: (context, index) {
        final imagePath = capturedImages[index];
        return Image.file(File(imagePath));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Analyzing automatically...'),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: showCamera ? buildCameraView() : buildImagePreview(),
          ),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: FloatingActionButton(
              onPressed: () {
                if (showCamera) {
                  capturePhotos();
                } else {
                  Navigator.pop(context);
                }
              },
              child: Icon(showCamera ? Icons.camera : Icons.arrow_back),
            ),
          ),
        ],
      ),
    );
  }
}
