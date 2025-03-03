import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class HitungNutrisiScreen extends StatefulWidget {
  @override
  _HitungNutrisiScreenState createState() => _HitungNutrisiScreenState();
}

class _HitungNutrisiScreenState extends State<HitungNutrisiScreen> {
  String selectedPlot = "Plot 01"; // Plot yang dipilih
  Map<String, dynamic> plotData = {}; // Data plot dari Firebase
  int jumlahTanaman = 1; // Default jumlah tanaman
  String vase = "Vegetatif"; // Default vase
  bool showResult = false; // Flag untuk menampilkan hasil

  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

  // Fungsi untuk mendengarkan data plot dari Firebase
  void listenToPlotData(String plot) {
    databaseReference.child(plot.toLowerCase()).onValue.listen((event) {
      if (event.snapshot.value != null) {
        setState(() {
          plotData = Map<String, dynamic>.from(event.snapshot.value as Map);
        });
      }
    });
  }

  // Perhitungan kebutuhan pupuk dan air
  Map<String, double> hitungKebutuhanPupukDanAir() {
    double nPerTanaman = vase == "Vegetatif" ? 2 : 3; // gram
    double pPerTanaman = 1; // gram
    double kPerTanaman = 1; // gram
    double airPerTanaman = 220; // ml

    double nTanah = (plotData['n'] ?? 0) * 0.001; // Konversi mg/kg ke gram/tanaman
    double pTanah = (plotData['p'] ?? 0) * 0.001; // Konversi mg/kg ke gram/tanaman
    double kTanah = (plotData['k'] ?? 0) * 0.001; // Konversi mg/kg ke gram/tanaman

    double nKebutuhan = (nPerTanaman - nTanah) * jumlahTanaman;
    double pKebutuhan = (pPerTanaman - pTanah) * jumlahTanaman;
    double kKebutuhan = (kPerTanaman - kTanah) * jumlahTanaman;

    double totalAir = airPerTanaman * jumlahTanaman;

    return {
      "n": nKebutuhan > 0 ? nKebutuhan : 0,
      "p": pKebutuhan > 0 ? pKebutuhan : 0,
      "k": kKebutuhan > 0 ? kKebutuhan : 0,
      "air": totalAir,
    };
  }

  @override
  void initState() {
    super.initState();
    listenToPlotData("plot1"); // Default mendengarkan plot1
  }

  @override
  Widget build(BuildContext context) {
    Map<String, double> kebutuhan = hitungKebutuhanPupukDanAir();

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              // Gambar Header
              Container(
                height: 230,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/headerlingkungan.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
          Positioned(
            top: 130,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Pilihan Plot
                Container(
                  height: 90,
                  child: Center(
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      children: [
                        _buildPlotBox("Plot 01", "plot1"),
                        _buildPlotBox("Plot 02", "plot2"),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Input Vase dan Jumlah Tanaman
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: vase,
                        items: ["Vegetatif", "Generatif"]
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            vase = value!;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: "Vase",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Jumlah Tanaman",
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            jumlahTanaman = int.tryParse(value) ?? 1;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // Tombol Cari
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showResult = true;
                      });
                    },
                    child: Text("Cari"),
                  ),
                ),

                SizedBox(height: 16),

                // Hasil Perhitungan
                if (showResult)
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hasil Perhitungan:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text("Nitrogen (N): ${kebutuhan['n']!.toStringAsFixed(2)} gram"),
                          Text("Phosphor (P): ${kebutuhan['p']!.toStringAsFixed(2)} gram"),
                          Text("Kalium (K): ${kebutuhan['k']!.toStringAsFixed(2)} gram"),
                          Text("Air: ${kebutuhan['air']!.toStringAsFixed(2)} ml"),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk kotak plot
  Widget _buildPlotBox(String plotName, String plotKey) {
    bool isSelected = selectedPlot == plotName;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPlot = plotName;
          listenToPlotData(plotKey);
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isSelected ? Colors.orange : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(
                Icons.local_florist,
                color: isSelected ? Colors.white : Colors.green,
                size: 30,
              ),
            ),
            SizedBox(height: 8),
            Text(
              plotName,
              style: TextStyle(
                color: isSelected ? Colors.orange : Colors.green[900],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
//futra app sistem skripsi ini apakah ping google apakah ini adaah sesuai yang 