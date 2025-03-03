import 'package:flutter/material.dart';
import 'package:sitanamalvian/Pages/kendali.dart';
import 'package:sitanamalvian/Pages/lingkungan.dart';
import 'package:sitanamalvian/Pages/catatan.dart';
import 'package:sitanamalvian/Pages/deteksi.dart';
import 'package:sitanamalvian/Pages/hitung_nutrisi.dart';


class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              // Gambar Header
              Container(
                height: 230, // Set height sesuai kebutuhan
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/headerdashboardref3.png'), // Pastikan path benar
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 50), // Spasi untuk grid
            ],
          ),
          // Grid di atas gambar (posisi tumpang tindih)
          Positioned(
            top: 0250, // Atur posisi agar tumpang tindih dengan gambar header
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  DashboardItem(
                    imagePath: 'assets/images/iconcontrol.png',
                    label: 'Kendali IOT',
                    onTap: () {
                      Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => KendaliScreen()),
                            );
                    },
                  ),
                  DashboardItem(
                    imagePath: 'assets/images/iconlingkungan.png',
                    label: 'Status Lingkungan',
                    onTap: () {
                      Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LingkunganScreen()),
                            );
                    },
                  ),
                  DashboardItem(
                    imagePath: 'assets/images/iconscript.png',
                    label: 'Catatan',
                    onTap: () {
                      Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => CatatanScreen()),
                            );
                    },
                  ),
                  DashboardItem(
                    imagePath: 'assets/images/icondeteksi.png',
                    label: 'Deteksi',
                    onTap: () {
                      Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => DeteksiScreen()),
                            );
                    },
                  ),
                  DashboardItem(
                    imagePath: 'assets/images/script.png',
                    label: 'Hitung Nutrisi',
                    onTap: () {
                      Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => HitungNutrisiScreen()),
                            );
                      // Navigation to Script HitungNutrisiScreen
                    },
                  ),
                  // DashboardItem(
                  //   imagePath: 'assets/images/technique.png',
                  //   label: 'Technique',
                  //   onTap: () {
                  //     // Navigation to Technique
                  //   },
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardItem extends StatelessWidget {
  final String imagePath; // Gambar icon dari assets
  final String label;
  final VoidCallback onTap;

  const DashboardItem({
    required this.imagePath,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent, // Agar warna latar belakang transparan
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16), // Efek ripple mengikuti bentuk kotak
        splashColor: Colors.green.withOpacity(0.2), // Warna efek klik
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 4,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath, // Path untuk gambar
                width: 48,
                height: 48,
              ),
              SizedBox(height: 16),
              Text(
                label,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.green[900], // Warna teks hijau tua
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
