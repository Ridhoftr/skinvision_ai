import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../widgets/home_header.dart';
import '../../widgets/welcome_card.dart';
import '../../widgets/feature_card.dart';

import '../profile/profile_screen.dart';
import '../about/about_screen.dart';
import '../auth/login_screen.dart';
import '../diagnosis/diagnosis_screen.dart';
import '../history/history_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> logout(
      BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => LoginScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user =
        FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F7FA),

      appBar: AppBar(
        title: const Text(
          "SkinVision AI",
            style: TextStyle(
            fontWeight: FontWeight.bold, 
          ),
        ),
        centerTitle: true,

        actions: [
          IconButton(
            icon:
                const Icon(Icons.logout),
            onPressed: () =>
                logout(context),
          ),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.all(20),

            child: Column(
              children: [

                const HomeHeader(),

                const SizedBox(height: 20),

                const WelcomeCard(),

                const SizedBox(height: 20),

                Card(
                  elevation: 3,

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                            16),
                  ),

                  child: Padding(
                    padding:
                        const EdgeInsets.all(
                            16),

                    child: Column(
                      children: [

                        Row(
                          children: [

                            const Icon(
                              Icons.person,
                              size: 35,
                            ),

                            const SizedBox(
                                width: 10),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,

                                children: [

                                  const Text(
                                    "Login sebagai",
                                    style:
                                        TextStyle(
                                      fontSize:
                                          12,
                                    ),
                                  ),

                                  Text(
                                    user?.email ??
                                        "-",
                                    style:
                                        const TextStyle(
                                      fontWeight:
                                          FontWeight
                                              .bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                StreamBuilder<
                    QuerySnapshot>(
                  stream:
                      FirebaseFirestore
                          .instance
                          .collection(
                              'diagnosis')
                          .where(
                            'uid',
                            isEqualTo:
                                user?.uid,
                          )
                          .snapshots(),

                  builder:
                      (context, snapshot) {

                    int totalDiagnosa = 0;

                    if (snapshot.hasData) {
                      totalDiagnosa =
                          snapshot
                              .data!
                              .docs
                              .length;
                    }

                    return Row(
                      children: [

                        Expanded(
                          child: Card(
                            child: Padding(
                              padding:
                                  const EdgeInsets
                                      .all(
                                      16),

                              child: Column(
                                children: [

                                  const Icon(
                                    Icons.analytics,
                                  ),

                                  const SizedBox(
                                      height:
                                          10),

                                  Text(
                                    "$totalDiagnosa",
                                    style:
                                        const TextStyle(
                                      fontSize:
                                          24,
                                      fontWeight:
                                          FontWeight
                                              .bold,
                                    ),
                                  ),

                                  const Text(
                                    "Diagnosa",
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        Expanded(
                          child: Card(
                            child: Padding(
                              padding:
                                  const EdgeInsets
                                      .all(
                                      16),

                              child: Column(
                                children: const [

                                  Icon(
                                    Icons
                                        .model_training,
                                  ),

                                  SizedBox(
                                      height:
                                          10),

                                  Text(
                                    "66.5%",
                                    style:
                                        TextStyle(
                                      fontSize:
                                          24,
                                      fontWeight:
                                          FontWeight
                                              .bold,
                                    ),
                                  ),

                                  Text(
                                    "Akurasi AI",
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 25),

                Row(
                  children: [

                    Expanded(
                      child: FeatureCard(
                        icon:
                            Icons.camera_alt,
                        title:
                            "Cek Diagnosa",

                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const DiagnosisScreen(),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(
                        width: 15),

                    Expanded(
                      child: FeatureCard(
                        icon:
                            Icons.history,
                        title:
                            "Riwayat",

                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const HistoryScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                Row(
                  children: [

                    Expanded(
                      child: FeatureCard(
                        icon:
                            Icons.info,
                        title:
                            "Tentang",
                        onTap: () {

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const AboutScreen(),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(
                        width: 15),

                    Expanded(
                      child: FeatureCard(
                        icon: Icons.person,
                        title: "Profil",
                        onTap: () {

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => 
                                  const ProfileScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}