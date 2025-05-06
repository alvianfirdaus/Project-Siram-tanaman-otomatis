import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class SoilClassificationPage extends StatefulWidget {
  @override
  _SoilClassificationPageState createState() => _SoilClassificationPageState();
}

class _SoilClassificationPageState extends State<SoilClassificationPage> {
  Interpreter? _interpreter; // Model interpreter
  String _result = "Pilih gambar untuk klasifikasi";

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  // Memuat model TensorFlow Lite
  _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/model_tanah.tflite');
      print("Model berhasil dimuat");

      // Cek ukuran input model
      var inputShape = _interpreter?.getInputTensor(0).shape;
      var inputType = _interpreter?.getInputTensor(0).type;
      print("Input shape: $inputShape");
      print("Input type: $inputType");
    } catch (e) {
      print("Gagal memuat model: $e");
    }
  }

  // Fungsi untuk mengklasifikasikan gambar
  Future<void> classifyImage(File image) async {
    // Mengambil gambar dan mengubahnya menjadi array yang dapat diproses oleh model
    img.Image? imageTemp = img.decodeImage(image.readAsBytesSync());
    imageTemp = img.copyResize(imageTemp!, width: 128, height: 128); // Resize sesuai ukuran input model

    // Convert image menjadi format float32 list
    var input = imageTemp.getBytes().buffer.asFloat32List();
    
    // Output sesuai dengan jumlah kelas dalam model (misal, 8 kelas)
    var output = List.generate(1, (_) => List.filled(8, 0.0)); // Array 2D untuk output float

    // Lakukan inferensi dengan model TFLite
    if (_interpreter != null) {
      _interpreter!.run(input, output);
      print("Output: $output");
      
      // Menampilkan hasil inferensi
      setState(() {
        // Menampilkan kelas dengan prediksi nilai tertinggi
        int predictedClass = output[0].indexOf(output[0].reduce((a, b) => a > b ? a : b));
        _result = "Prediksi: Kelas $predictedClass";
      });
    } else {
      setState(() {
        _result = "Interpreter tidak tersedia";
      });
    }
  }

  // Ambil gambar dari kamera
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      File image = File(pickedFile.path);
      classifyImage(image); // Klasifikasikan gambar setelah diambil
    }
  }

  @override
  void dispose() {
    _interpreter?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Klasifikasi Tanah")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: pickImage, // Ambil gambar langsung dari kamera
              child: Text('Ambil Gambar'),
            ),
            SizedBox(height: 20),
            Text(
              _result,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
