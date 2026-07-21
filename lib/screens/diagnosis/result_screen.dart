import 'package:flutter/material.dart';
import 'detail_screen.dart';

class ResultScreen extends StatelessWidget {
  final String disease;
  final double confidence;
  final String? shapImage;

  const ResultScreen({
    super.key,
    required this.disease,
    required this.confidence,
    this.shapImage,
  });

  String getRiskLevel() {
    if (confidence >= 80) {
      return "Tinggi";
    }

    if (confidence >= 60) {
      return "Sedang";
    }

    return "Rendah";
  }

  String getRecommendation() {
    switch (disease) {
      case "Melanoma":
        return "Segera konsultasikan ke dokter spesialis kulit untuk pemeriksaan lebih lanjut.";

      case "Basal Cell Carcinoma":
        return "Disarankan melakukan pemeriksaan dermatologi untuk memastikan kondisi kulit.";

      case "Actinic Keratoses":
        return "Gunakan tabir surya dan lakukan pemeriksaan rutin pada kulit.";

      case "Benign Keratosis":
        return "Biasanya tidak berbahaya, namun tetap pantau perubahan pada kulit.";

      case "Dermatofibroma":
        return "Lesi umumnya jinak, namun konsultasikan jika terjadi perubahan ukuran atau warna.";

      case "Melanocytic Nevi":
        return "Pantau perubahan bentuk, ukuran, atau warna tahi lalat.";

      case "Vascular Lesions":
        return "Konsultasikan ke dokter apabila lesi menyebabkan nyeri atau perdarahan.";

      default:
        return "Lakukan pemeriksaan lanjutan untuk memastikan diagnosis.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hasil Diagnosa"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            const Icon(
              Icons.health_and_safety,
              size: 100,
              color: Colors.green,
            ),

            const SizedBox(height: 20),

            Text(
              disease,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Column(
                  children: [

                    const Text(
                      "Tingkat Keyakinan Model",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      "${confidence.toStringAsFixed(2)} %",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    LinearProgressIndicator(
                      value: confidence / 100,
                      minHeight: 12,
                      borderRadius:
                          BorderRadius.circular(10),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.warning_amber,
                ),
                title: const Text(
                  "Tingkat Risiko",
                ),
                subtitle: Text(
                  getRiskLevel(),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    const Text(
                      "Saran Awal",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      getRecommendation(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ==========================
            // SHAP EXPLAINABLE AI
            // ==========================

            if (shapImage != null &&
                shapImage!.isNotEmpty) ...[

              Card(
                elevation: 3,

                child: Padding(
                  padding:
                      const EdgeInsets.all(16),

                  child: Column(

                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [

                      const Text(
                        "Explainable AI (SHAP)",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        "Area berwarna menunjukkan bagian gambar yang paling diperhatikan oleh model CNN saat melakukan prediksi.",
                      ),

                      const SizedBox(height: 15),

                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(
                                12),

                        child: Image.network(
                          "http://192.168.0.177:8000/$shapImage",
                          fit: BoxFit.cover,

                          errorBuilder:
                              (
                                context,
                                error,
                                stackTrace,
                              ) {
                            return Container(
                              height: 220,

                              alignment:
                                  Alignment.center,

                              child: const Text(
                                "Heatmap SHAP belum tersedia",
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],

            SizedBox(
              width: double.infinity,

              child: ElevatedButton.icon(
                icon: const Icon(
                  Icons.info_outline,
                ),

                label: const Text(
                  "Lihat Detail Penyakit",
                ),

                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          DetailScreen(
                        disease: disease,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton.icon(
                icon: const Icon(
                  Icons.refresh,
                ),

                label: const Text(
                  "Diagnosa Lagi",
                ),

                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}