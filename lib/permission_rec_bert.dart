// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:tflite/tflite.dart';

// class PermissionRecommendationScreen extends StatefulWidget {
//   const PermissionRecommendationScreen({Key? key}) : super(key: key);

//   @override
//   _PermissionRecommendationScreenState createState() => _PermissionRecommendationScreenState();
// }

// class _PermissionRecommendationScreenState extends State<PermissionRecommendationScreen> {
//   late List<dynamic> _outputs;
//   late File _image;
//   bool _loading = true;

//   @override
//   void initState() {
//     super.initState();
//     loadModel().then((value) {
//       setState(() {
//         _loading = false;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     Tflite.close();
//     super.dispose();
//   }

//   Future<void> loadModel() async {
//     try {
//       await Tflite.loadModel(
//         model: 'assets/tflite/model.tflite',
//         labels: 'assets/tflite/labels.txt',
//       );
//     } catch (e) {
//       print('Error loading model: $e');
//     }
//   }

//   Future<void> getImage() async {
//     final image = await ImagePicker().getImage(source: ImageSource.gallery);

//     if (image != null) {
//       setState(() {
//         _image = File(image.path);
//       });
//       classifyImage(_image);
//     }
//   }

//   Future<void> classifyImage(File image) async {
//     try {
//       final List<dynamic> results = await Tflite.runModelOnImage(
//         path: image.path,
//         numResults: 3,
//         threshold: 0.5,
//       );

//       setState(() {
//         _loading = false;
//         _outputs = results;
//       });
//     } catch (e) {
//       print('Error classifying image: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Permission Recommendation'),
//       ),
//       body: _loading
//           ? Center(child: CircularProgressIndicator())
//           : Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ElevatedButton(
//                   onPressed: getImage,
//                   child: Text('Select Image'),
//                 ),
//                 SizedBox(height: 20),
//                 _image != null
//                     ? Image.file(
//                         _image,
//                         height: 200,
//                         width: 200,
//                       )
//                     : Container(),
//                 SizedBox(height: 20),
//                 _outputs.isNotEmpty
//                     ? Column(
//                         children: [
//                           Text(
//                             'Recommended Permissions',
//                             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                           ),
//                           SizedBox(height: 10),
//                           Text(_outputs[0]['label']),
//                         ],
//                       )
//                     : Container(),
//               ],
//             ),
//     );
//   }
// }
