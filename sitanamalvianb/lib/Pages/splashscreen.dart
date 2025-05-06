import 'package:flutter/material.dart';
import 'package:sitanamalvianb/Routes/routes.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Menambahkan delay 5 detik sebelum navigasi ke dashboard
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacementNamed(context, Routes.loginPage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logositanam.png',
                width: 170, height: 170),
            SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'sitanam mobile @ 2024',
          style: TextStyle(
            fontFamily: 'Urbanist',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: const Color(0xff4a4a4a),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
