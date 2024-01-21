import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

class MapScreen extends StatefulWidget {
  final LatLng initialPosition;
  final Function(LatLng) onLocationSelected;

  const MapScreen({
    Key? key,
    required this.initialPosition,
    required this.onLocationSelected,
  }) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

const kGoogleApiKey = 'AIzaSyCYg1-oVRMu5WFUwKdqz23v8Ey7Fy1-8Q0';

class _MapScreenState extends State<MapScreen> {
  static const CameraPosition initialCameraPosition =
      CameraPosition(target: LatLng(37.42796, -122.08574), zoom: 14.0);
  Set<Marker> markerList = {};

  late GoogleMapController googleMapController;
  final Mode _mode = Mode.overlay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Image.asset('assets/images/arrow.png'),
              ),
              Text(
                'Maps',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(29, 77, 79, 1),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: widget.initialPosition,
              zoom: 14.0,
            ),
            markers: markerList,
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController controller) {
              googleMapController = controller;
            },
            onTap: _handleMapTap, // Tambahkan handle tap pada peta
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _handlePressButton,
                child: Text(
                  'Cari lokasi',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Tombol "Pilih" untuk menyimpan lokasi yang dipilih
          if (markerList.isNotEmpty)
            Positioned(
              bottom: 50,
              left: 16,
              right: 16,
              child: ElevatedButton(
                onPressed: () => _saveSelectedLocation(context),
                child: Text('Pilih'),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _handlePressButton() async {
    Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiKey,
      onError: onError,
      mode: _mode,
      language: 'en',
      strictbounds: false,
      types: [""],
      decoration: InputDecoration(
        hintText: 'Cari',
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      components: [Component(Component.country, "id")],
    );

    if (p != null) {
      displayPrediction(p, ScaffoldMessenger.of(context));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pencarian dibatalkan'),
        ),
      );
    }
  }

  void onError(PlacesAutocompleteResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response.errorMessage ?? 'Pencarian dibatalkan'),
      ),
    );
  }

  Future<void> displayPrediction(
      Prediction p, ScaffoldMessengerState messenger) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);

    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;

    markerList.clear();
    markerList.add(
      Marker(
        markerId: const MarkerId("0"),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: detail.result.name),
      ),
    );

    setState(() {});

    googleMapController
        .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 14.0));
  }

  // Handle tap pada peta untuk menambahkan marker pada lokasi yang di-tap
  void _handleMapTap(LatLng tappedPoint) {
    markerList.clear();
    markerList.add(
      Marker(
        markerId: const MarkerId("0"),
        position: tappedPoint,
      ),
    );

    setState(() {});
  }

  // Implementasikan logika penyimpanan tempat yang dipilih di sini
  // Misalnya, Anda dapat menggunakan Navigator untuk kembali ke halaman sebelumnya
  // dan membawa informasi lokasi yang dipilih sebagai hasil
  Future<void> _saveSelectedLocation(BuildContext context) async {
    if (markerList.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Lokasi berhasil disimpan: ${markerList.first.position}'),
        ),
      );

      // Panggil fungsi callback dengan nilai latitude dan longitude
      widget.onLocationSelected(markerList.first.position);

      // Kembali ke halaman sebelumnya
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pemilihan tempat dibatalkan atau tidak valid'),
        ),
      );
    }
  }
}
