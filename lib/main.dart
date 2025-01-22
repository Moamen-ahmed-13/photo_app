import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'camera_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://dfhjoaazooyocmzfpsdu.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRmaGpvYWF6b295b2NtemZwc2R1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzcyODQyMzEsImV4cCI6MjA1Mjg2MDIzMX0.R9LYowbFY0ezBC-m7ZDPY5FMrxMXWKCtZCHIpGFml-U',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CameraPage(),
    );
  }
}
