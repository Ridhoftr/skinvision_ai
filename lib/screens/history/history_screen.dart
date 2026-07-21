import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//import '../diagnosis/detail_screen.dart';
import '../diagnosis/result_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Riwayat Diagnosa",
        ),
      ),

      body: StreamBuilder<QuerySnapshot>(

        stream: FirebaseFirestore.instance
            .collection('diagnosis')
              
            .snapshots(),

        builder: (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {

            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {

            return const Center(
              child: Text(
                "Belum ada riwayat diagnosa",
              ),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(

            padding:
                const EdgeInsets.all(12),

            itemCount: docs.length,

            itemBuilder:
                (context, index) {

              final data = 
                  docs[index].data()
                      as Map<String, dynamic>;

              final Timestamp? timestamp =
                  data['createdAt'];

              String dateText =
                  "Tanggal tidak tersedia";

              if (timestamp != null) {

                final date =
                    timestamp.toDate();

                dateText =
                    "${date.day}/${date.month}/${date.year}";
              }

              return Card(

                elevation: 3,

                margin:
                    const EdgeInsets.only(
                  bottom: 12,
                ),

                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                          16),
                ),

                child: ListTile(

                  onTap: () {

                    final String shapImage = 
                        data.containsKey('shap_image')
                            ? data['shap_image']
                            : "";

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ResultScreen(
                          disease: data['disease'],
                          confidence:
                              (data['confidence'] as num)
                                .toDouble(),
                          shapImage: shapImage,
                        ),
                      ),
                    );
                  },

                  contentPadding:
                      const EdgeInsets.all(
                          12),

                  leading: CircleAvatar(
                    radius: 28,
                    child: Icon(
                      Icons.health_and_safety,
                    ),
                  ),

                  title: Text(
                    data['disease'],
                    style:
                        const TextStyle(
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  subtitle: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                    children: [

                      const SizedBox(
                          height: 6),

                      Text(
                        "Confidence: ${data['confidence'].toStringAsFixed(2)}%",
                      ),

                      const SizedBox(
                          height: 4),

                      Text(
                        dateText,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}