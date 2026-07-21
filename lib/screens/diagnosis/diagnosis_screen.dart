import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../services/api_service.dart';
import 'result_screen.dart';

class DiagnosisScreen extends StatefulWidget {
  const DiagnosisScreen({super.key});

  @override
  State<DiagnosisScreen> createState() =>
      _DiagnosisScreenState();
}

class _DiagnosisScreenState
    extends State<DiagnosisScreen> {

  File? image;

  final ImagePicker picker =
      ImagePicker();

  Future<void> pickFromGallery() async {

    final picked =
        await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (picked == null) return;

    setState(() {
      image = File(picked.path);
    });
  }

  Future<void> pickFromCamera() async {

    final picked =
        await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (picked == null) return;

    setState(() {
      image = File(picked.path);
    });
  }

  Future<void> uploadAndAnalyze() async {

    if (image == null) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Silakan pilih gambar terlebih dahulu",
          ),
        ),
      );

      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child:
            CircularProgressIndicator(),
      ),
    );

    try {

      final result =
          await ApiService.predictDisease(image!,);
          print(result);

      final disease =
    result["disease"];

      final confidence =
          result["confidence"]
              .toDouble();

      await FirebaseFirestore.instance
          .collection("diagnosis")
          .add({
        "uid":
            FirebaseAuth
                .instance
                .currentUser
                ?.uid,

        "disease": disease,

        "confidence": confidence,

        "shap_image":
              result["shap_image"],

        "createdAt":
            Timestamp.now(),
      });

      print("DATA BERHASIL DISIMPAN");
      print(FirebaseAuth.instance.currentUser?.uid);

      if (mounted) {
        Navigator.pop(context);
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            disease:disease,
            confidence: confidence,
            shapImage:
                result["shap_image"],
          ),
        ),
      );

    } catch (e) {
      
      print("========== ERROR API ==========");
      print(e);

      if (mounted) {
        Navigator.pop(context);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Cek Diagnosa",
        ),
      ),

      body: SingleChildScrollView(

        child: Padding(
          padding:
              const EdgeInsets.all(20),

          child: Column(

            children: [

              Container(
                height: 280,
                width: double.infinity,

                decoration:
                    BoxDecoration(
                  color:
                      Colors.grey.shade200,
                  borderRadius:
                      BorderRadius.circular(
                          20),
                  border: Border.all(
                    color:
                        Colors.grey.shade400,
                  ),
                ),

                child: image == null

                    ? Column(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .center,
                        children: const [

                          Icon(
                            Icons
                                .image_search,
                            size: 80,
                          ),

                          SizedBox(
                            height: 10,
                          ),

                          Text(
                            "Belum ada gambar",
                          ),
                        ],
                      )

                    : ClipRRect(
                        borderRadius:
                            BorderRadius
                                .circular(
                                    20),
                        child: Image.file(
                          image!,
                          fit:
                              BoxFit.cover,
                        ),
                      ),
              ),

              const SizedBox(
                height: 25,
              ),

              Row(
                children: [

                  Expanded(
                    child:
                        ElevatedButton.icon(
                      onPressed:
                          pickFromCamera,

                      icon: const Icon(
                        Icons.camera_alt,
                      ),

                      label: const Text(
                        "Kamera",
                      ),

                      style:
                          ElevatedButton
                              .styleFrom(
                        minimumSize:
                            const Size(
                          double.infinity,
                          55,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    width: 10,
                  ),

                  Expanded(
                    child:
                        ElevatedButton.icon(
                      onPressed:
                          pickFromGallery,

                      icon: const Icon(
                        Icons.photo,
                      ),

                      label: const Text(
                        "Galeri",
                      ),

                      style:
                          ElevatedButton
                              .styleFrom(
                        minimumSize:
                            const Size(
                          double.infinity,
                          55,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 20,
              ),

              SizedBox(
                width:
                    double.infinity,

                height: 55,

                child:
                    ElevatedButton.icon(
                  onPressed:
                      uploadAndAnalyze,

                  icon: const Icon(
                    Icons.analytics,
                  ),

                  label: const Text(
                    "Analisis Sekarang",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}