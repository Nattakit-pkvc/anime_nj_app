import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:anime_nj_app/services/filestore.dart'; // Firestore service

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Anime App',
      theme: ThemeData.dark(),
      home: const FirstScreen(),
    );
  }
}

// ======================= FirstScreen =======================
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

  void checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult.contains(ConnectivityResult.none)) {
      _showAlertDialog(
        context,
        "No Internet",
        "Please check your internet connection.",
      );
    } else if (connectivityResult.contains(ConnectivityResult.mobile)) {
      _showToast(context, "Mobile network is available.");
    } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
      _showToast(context, "Wi-Fi is available.");
    } else if (connectivityResult.contains(ConnectivityResult.ethernet)) {
      _showToast(context, "Ethernet is available.");
    } else if (connectivityResult.contains(ConnectivityResult.vpn)) {
      _showToast(context, "VPN connection active.");
    } else if (connectivityResult.contains(ConnectivityResult.bluetooth)) {
      _showToast(context, "Bluetooth connection active.");
    } else {
      _showToast(context, "Other network is available.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1D1E33), Color(0xFF2C3E50), Color(0xFF34495E)],
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

// ======================= Toast / Alert =======================
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

void _timer(BuildContext context) {
  Timer(
    const Duration(seconds: 3),
    () => Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SecondScreen()),
    ),
  );
}

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

// ======================= SecondScreen =======================
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

              // Chapter / Season ต้องเป็นตัวเลข
              int? chapter = int.tryParse(chapterController.text);
              int? season = int.tryParse(seasonController.text);
              if (chapter == null || season == null) {
                _showToast(context, "Chapter and Season must be numbers!");
                return;
              }

              // Score 0.00 - 5.00
              double? score = double.tryParse(scoreController.text);
              if (score == null || score < 0 || score > 5) {
                _showToast(
                  context,
                  "Score must be a number between 0.00 and 5.00",
                );
                return;
              }
              score = double.parse(score.toStringAsFixed(2));

              final String name = nameController.text;
              final String imageUrl = imageUrlController.text;

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
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        hintStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.blueGrey.shade700.withOpacity(0.3),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white70),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white),
        ),
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
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${animeData['animeName']}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Season: ${animeData['animeSeason']}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Chapter: ${animeData['animeChapter']}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${animeData['animeScore']}',
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ],
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
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor: const Color(0xFF2C3E50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                title: const Text(
                                  'Confirm Delete',
                                  style: TextStyle(
                                    color: Colors.pinkAccent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                content: const Text(
                                  'Are you sure you want to delete this anime?',
                                  style: TextStyle(color: Colors.white70),
                                ),
                                actions: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey,
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent,
                                    ),
                                    onPressed: () {
                                      firestoreService.deleteAnime(anime.id);
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            );
                          },
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
