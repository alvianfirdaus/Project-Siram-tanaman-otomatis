import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sitanamalvianb/Pages/akun.dart';

class TambahAlatPage extends StatefulWidget {
  const TambahAlatPage({Key? key}) : super(key: key);

  @override
  State<TambahAlatPage> createState() => _TambahAlatPageState();
}

class _TambahAlatPageState extends State<TambahAlatPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  final TextEditingController _alatController = TextEditingController();
  bool _scanned = false; // Untuk mencegah scan berulang-ulang

  void _onScan(Barcode barcode) {
    if (_scanned) return;
    setState(() {
      _alatController.text = barcode.rawValue ?? '';
      _scanned = true;
    });
  }

  Future<void> _connectDevice() async {
    final String plotName = _alatController.text.trim();
    final String? userUid = _auth.currentUser?.uid;

    if (plotName.isEmpty || userUid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ID alat kosong atau pengguna tidak terautentikasi.')),
      );
      return;
    }

    try {
      final plotRef = _dbRef.child(plotName);
      final snapshot = await plotRef.get();

      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);

        List<dynamic> idList = [];
        if (data.containsKey('id')) {
          idList = List.from(data['id']);
        }

        if (!idList.contains(userUid)) {
          idList.add(userUid);
          await plotRef.update({'id': idList});
        }

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Berhasil'),
            content: Text('Berhasil terkoneksi dengan $plotName'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/daftaralatpage');
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Plot "$plotName" tidak ditemukan di database.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF006400),
      appBar: AppBar(
        backgroundColor: const Color(0xFF006400),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AkunScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
  children: [
    const SizedBox(height: 40),
    Expanded(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Scan atau Masukkan ID Perangkat",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 300,
                child: MobileScanner(
                  fit: BoxFit.cover,
                  onDetect: (BarcodeCapture capture) {
                    final barcode = capture.barcodes.firstOrNull;
                    if (barcode != null) {
                      _onScan(barcode);
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _alatController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'ID Perangkat',
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: _connectDevice,
                  child: const Text('Connect'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ],
),


    );
  }
}
