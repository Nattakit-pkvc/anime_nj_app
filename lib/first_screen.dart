import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:anime_nj_app/services/filestore.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  void initState() {
    super.initState();
    checkInternetConnection();
  }

  // ตรวจสอบการเชื่อมต่ออินเทอร์เน็ต
  void checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult.contains(ConnectivityResult.mobile)) {
      _showToast(context, "Mobile network is available.");
    } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
      _showToast(context, "Wi-Fi is available.");
    } else if (connectivityResult.contains(ConnectivityResult.ethernet)) {
      _showToast(context, "Ethernet is available.");
    } else if (connectivityResult.contains(ConnectivityResult.vpn)) {
      _showToast(context, "VPN connection active.");
    } else if (connectivityResult.contains(ConnectivityResult.bluetooth)) {
      _showToast(context, "Bluetooth connection active.");
    } else if (connectivityResult.contains(ConnectivityResult.other)) {
      _showToast(context, "Other network is available.");
    } else if (connectivityResult.contains(ConnectivityResult.none)) {
      _showAlertDialog(
        context,
        "No Internet",
        "Please check your internet connection.",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1D1E33), // Dark Purple
              Color(0xFF2C3E50), // Dark Blue
              Color(0xFF34495E), // Grayish Blue
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black54,
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image.asset(
                      './android/assets/image/loadingScreen.jpeg',
                      width: 220,
                      height: 220,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                SpinKitFadingCircle(
                  color: Colors.pinkAccent.shade200,
                  size: 60.0,
                ),
                const SizedBox(height: 25),
                const Text(
                  "Loading Your Anime App...",
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Toast แบบธีมเข้ม
void _showToast(BuildContext context, String msg) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.blueGrey.shade800,
    textColor: Colors.pinkAccent.shade200,
    fontSize: 18.0,
  );
  _timer(context);
}

// Timer ไปหน้า SecondScreen หลัง 3 วินาที
void _timer(BuildContext context) {
  Timer(
    const Duration(seconds: 3),
    () => Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SecondScreen()),
    ),
  );
}

// AlertDialog แบบธีมเข้ม
void _showAlertDialog(BuildContext context, String title, String msg) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: const Color(0xFF2C3E50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            color: Colors.pinkAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(msg, style: const TextStyle(color: Colors.white70)),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent),
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      );
    },
  );
}

class SecondScreen extends StatefulWidget {
  const SecondScreen({super.key});

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  final FirestoreService firestoreService = FirestoreService();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController chapterController = TextEditingController();
  final TextEditingController seasonController = TextEditingController();
  final TextEditingController scoreController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();

  void openAnimeBox(String? animeID) async {
    if (animeID != null) {
      final anime = await firestoreService.getAnimeById(animeID);
      nameController.text = anime['animeName'] ?? '';
      chapterController.text = anime['animeChapter']?.toString() ?? '';
      seasonController.text = anime['animeSeason']?.toString() ?? '';
      scoreController.text = anime['animeScore']?.toString() ?? '';
      imageUrlController.text = anime['animeImageUrl'] ?? '';
    } else {
      nameController.clear();
      chapterController.clear();
      seasonController.clear();
      scoreController.clear();
      imageUrlController.clear();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C3E50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField("Anime Name", nameController),
              const SizedBox(height: 10),
              _buildTextField("Chapter", chapterController, isNumber: true),
              const SizedBox(height: 10),
              _buildTextField("Season", seasonController, isNumber: true),
              const SizedBox(height: 10),
              _buildTextField(
                "Score (0.00-5.00)",
                scoreController,
                isNumber: true,
              ),
              const SizedBox(height: 10),
              _buildTextField("Image URL", imageUrlController),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent),
            onPressed: () {
  // ตรวจสอบทุกช่องไม่ว่าง
  if (nameController.text.isEmpty ||
      chapterController.text.isEmpty ||
      seasonController.text.isEmpty ||
      scoreController.text.isEmpty ||
      imageUrlController.text.isEmpty) {
    _showToast(context, "Please fill all fields!");
    return;
  }

  // ตรวจสอบ Score
  double? score = double.tryParse(scoreController.text);
  if (score == null || score < 0 || score > 5) {
    _showToast(context, "Score must be a number between 0.00 and 5.00");
    return;
  }

  // ปรับให้มีทศนิยม 2 ตำแหน่ง
  score = double.parse(score.toStringAsFixed(2));

  final String name = nameController.text;
  final int chapter = int.tryParse(chapterController.text) ?? 0;
  final int season = int.tryParse(seasonController.text) ?? 0;
  final String imageUrl = imageUrlController.text;

  // ตรวจสอบ URL ว่าเป็น http/https
  if (!imageUrl.startsWith("http")) {
    _showToast(context, "Image URL must start with http or https");
    return;
  }

  if (animeID != null) {
    firestoreService.updateAnime(
      animeID: animeID,
      animeName: name,
      animeChapter: chapter,
      animeSeason: season,
      animeScore: score,
      animeImageUrl: imageUrl,
    );
  } else {
    firestoreService.addAnime(
      animeName: name,
      animeChapter: chapter,
      animeSeason: season,
      animeScore: score,
      animeImageUrl: imageUrl,
    );
  }

  Navigator.of(context).pop();
},

            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  TextField _buildTextField(
    String label,
    TextEditingController controller, {
    bool isNumber = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isNumber
          ? TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.pinkAccent),
        filled: true,
        fillColor: Colors.blueGrey.shade700.withOpacity(0.3),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1D1E33),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C3E50),
        title: const Text(
          "Anime List",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pinkAccent,
        onPressed: () => openAnimeBox(null),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getAnimes(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final animeList = snapshot.data!.docs;
            if (animeList.isEmpty) {
              return const Center(
                child: Text(
                  "No data available",
                  style: TextStyle(fontSize: 24, color: Colors.pinkAccent),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: animeList.length,
              itemBuilder: (context, index) {
                final anime = animeList[index];
                final animeData = anime.data() as Map<String, dynamic>;

                return Card(
                  color: Colors.blueGrey.shade800,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    leading: animeData['animeImageUrl'] != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              animeData['animeImageUrl'],
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          )
                        : null,
                    title: Text(
                      '${animeData['animeName']} (Season: ${animeData['animeSeason']})',
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      'Chapter: ${animeData['animeChapter']} | Score: ${animeData['animeScore']}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.pinkAccent,
                          ),
                          onPressed: () => openAnimeBox(anime.id),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.redAccent,
                          ),
                          onPressed: () =>
                              firestoreService.deleteAnime(anime.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(color: Colors.pinkAccent),
            );
          }
        },
      ),
    );
  }
}
