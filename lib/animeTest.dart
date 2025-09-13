import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.mobile)) {
      _showToast(context, "Mobile network is available.");
    } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
      _showToast(context, "Wi-Fi is available.");
    } else if (connectivityResult.contains(ConnectivityResult.ethernet)) {
      _showToast(context, "Ethernet is available.");
    } else if (connectivityResult.contains(ConnectivityResult.vpn)) {
      _showToast(context, "Vpn connection active.");
    } else if (connectivityResult.contains(ConnectivityResult.bluetooth)) {
      _showToast(context, "Bluetooth connection active.");
    } else if (connectivityResult.contains(ConnectivityResult.other)) {
      _showToast(context, "Other network is available.");
    } else if (connectivityResult.contains(ConnectivityResult.none)) {
      setState(() {
        _showAlertDialog(
          context,
          "No Internet",
          "Please check your internet connection.",
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // ✅ Gradient: ขาว + ฟ้า + ชมพู
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFFFFF), // ขาว
              Color(0xFF80D8FF), // ฟ้าอ่อน
              Color(0xFFF48FB1), // ชมพู
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
                // รูปภาพขอบมน + เงา
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 15,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      './android/assets/image/loadingScreen.jpeg',
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // Spin animation (ชมพู)
                const SpinKitFadingCircle(color: Colors.pinkAccent, size: 50.0),
                const SizedBox(height: 20),
                const Text(
                  "Welcome to Anime Rating",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
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

// Step 4 : Show toast message
void _timer(BuildContext context) {
  Timer(
    const Duration(seconds: 3),
    () => Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SecondScreen()),
    ),
  );
}

void _showToast(BuildContext context, String msg) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.blueAccent, // ✅ ฟ้า
    textColor: Colors.white,
    fontSize: 20.0,
  );
  _timer(context);
}

void _showAlertDialog(BuildContext context, String title, String msg) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            color: Colors.pinkAccent,
            fontWeight: FontWeight.w500,
          ),
        ),
        content: Text(msg, style: const TextStyle(color: Colors.black87)),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlueAccent, // ✅ ฟ้าอ่อน
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "OK",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      );
    },
  );
}

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // ✅ Gradient: ฟ้า + ชมพู
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF80D8FF), // ฟ้าอ่อน
              Color(0xFFF48FB1), // ชมพู
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Text(
              'Welcome to the Second Screen!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    blurRadius: 10,
                    color: Colors.black26,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


