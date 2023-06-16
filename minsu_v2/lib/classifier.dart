import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:io' as io;
import 'package:image/image.dart' as img;
// import 'package:dart_tensor/dart_tensor.dart';

class Classifier {
  Classifier();

  classifyImage(List<String> image) async {
    late List<Uint8List>? imagesList = [];

    // Ugly boilerplate to get it to Uint8List
    for (int i = 0; i < 5; i+=1){
      var _file = io.File(image[i]);
      img.Image? imageTemp = img.decodeImage(_file.readAsBytesSync());
      img.Image resizedImg = img.copyResize(imageTemp!, height: 180, width: 320);
      var imgBytes = resizedImg.getBytes();
      var imgAsList = imgBytes.buffer.asUint8List();
      imagesList.add(imgAsList);
    }

    return getPred(imagesList);
  }

  Future<int> getPred(List<Uint8List> imgAsList) async {
    List resultBytes = List.filled(180*320*15, 0.0, growable: false);

    int index = 0;
    print("==============================================================================");
    print("Image preprocessing");
    for (int i = 0; i < imgAsList[0].lengthInBytes; i += 3) {
      for (int j = 0; j < 5; j+=1){
        final r = imgAsList[j][i];
        final g = imgAsList[j][i + 1];
        final b = imgAsList[j][i + 2];

        resultBytes[index] = (r / 1.0);
        resultBytes[index + 1] = (g / 1.0);
        resultBytes[index + 2] = (b / 1.0);
        index += 3;
      }
    }

    var input = resultBytes.reshape([1, 180, 320, 15]);
    var output = List.filled(1 * 7, 1.0, growable: false).reshape([1, 7]);

    InterpreterOptions interpreterOptions = InterpreterOptions();

    // print(input);
    // print(output);
    print("Model inference");
    try {
      Interpreter interpreter = await Interpreter.fromAsset(
          "model_v3.tflite",
          options: interpreterOptions
      );
      interpreter.run(input, output);
    } catch (e) {
      print(e);
      print("Error loading model or running model");
    }

    // print(output);

    double highestProb = 0;
    int digitPred = 0;

    for (int i = 0; i < output[0].length; i++) {
      if (output[0][i] > highestProb) {
        highestProb = output[0][i];
        digitPred = i;
      }
    }
    print(output[0]);
    print(digitPred);
    print("Complete!");
    print("==============================================================================");
    return digitPred;
  }
}