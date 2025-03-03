import 'package:flutter/material.dart';
import 'package:sitanamalvian/Pages/dashboard.dart';
import 'package:sitanamalvian/Pages/splashscreen.dart';
import 'package:sitanamalvian/Pages/settings.dart';
import 'package:sitanamalvian/Pages/addcatatan.dart';
import 'package:sitanamalvian/Pages/editcatatan.dart';

class Routes {
  static const String splash = '/';
  static const String dashboard = '/dashboard';
  static const String settings = '/settings';
  static const String addCatatan = '/addcatatan';
  static const String editCatatan = '/editcatatan';

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => SplashScreen(),
    dashboard: (context) => DashboardScreen(),
    settings: (context) => SettingsPage(),
    addCatatan: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is String) {
        return AddCatatanScreen(selectedPlot: args);
      } else {
        return AddCatatanScreen(selectedPlot: ''); // Nilai default jika null
      }
    },
    editCatatan: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map<String, dynamic>) {
        return EditCatatanScreen(
          selectedPlot: args['selectedPlot'] ?? '',
          catatanKey: args['catatanKey'] ?? '',
          initialCatatan: args['initialCatatan'] ?? '',
          initialTanggal: args['initialTanggal'] ?? '',
          initialWaktu: args['initialWaktu'] ?? '',
        );
      } else {
        return EditCatatanScreen(
          selectedPlot: '',
          catatanKey: '',
          initialCatatan: '',
          initialTanggal: '',
          initialWaktu: '',
        ); // Nilai default jika `arguments` tidak sesuai
      }
    },
  };
}
