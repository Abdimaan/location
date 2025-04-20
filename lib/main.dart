import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://lpnlwxtqcfxtajeerhcu.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imxwbmx3eHRxY2Z4dGFqZWVyaGN1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDIzNzM0ODAsImV4cCI6MjA1Nzk0OTQ4MH0.VF22-4nH-rXZtNRgE_qvGKz3sV1CSW_6Vl-ib-4dLIA',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> getAndSaveLocation() async {
    // Ask for permission
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      print('Location permission denied.');
      return;
    }

    // Get current position
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Save to Supabase
    final response = await Supabase.instance.client.from('user').insert({
      // replace with real user ID
      'latitude': position.latitude,
      'longitude': position.longitude,
    }).execute();

    print('Saved: ${position.latitude}, ${position.longitude}');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('fetching user location')),
        body: Center(
          child: ElevatedButton(
            onPressed: getAndSaveLocation,
            child: Text('Get and Save Location'),
          ),
        ),
      ),
    );
  }
}
