import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:offertree/ui/screens/dashboard/home.dart';
import 'package:offertree/api/api.dart';

class LocationSelector extends StatefulWidget {
  const LocationSelector({super.key});

  @override
  _LocationSelectorState createState() => _LocationSelectorState();
}

class _LocationSelectorState extends State<LocationSelector> {
  bool _isLoading = false;

  Future<void> _getLocationAndCallApi(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location services are disabled.')),
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied.')),
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Location permissions are permanently denied.')),
        );
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      String location =
          'https://www.google.com/maps/embed?pb=!1m14!1m12!1m3!1d230.35247658780517!2d${position.longitude}!3d${position.latitude}!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!5e0!3m2!1sen!2sin!4v1738920375277!5m2!1sen!2sin';
      final id = await ApiService.userId;
      print(id);

      if (id == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to retrieve user ID.')),
        );
        return;
      }
      final apiService = ApiService();
      final response = await apiService.location(id as int, location);

      if (response.success) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const Dashboard(),
            ));
      } else {
        var snackBar = SnackBar(
          content: Text(response.message),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      const snackBar = SnackBar(
        content: Text('An unexpected error occurred. Please try again.'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/svg/Illustrators/location_access.png'),
              const SizedBox(height: 32),
              const Text(
                "What's your location?",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Enjoy a personalized selling and buying\nexperience by telling us your location",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              // Find My Location button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      _isLoading ? null : () => _getLocationAndCallApi(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF576bd6),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : const Text(
                          'Find My Location',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
