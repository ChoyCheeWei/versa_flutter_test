import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:versa_flutter_test/models/brewery_model.dart';

class BreweryDetailsScreen extends StatefulWidget {
  final BreweryModel item;

  const BreweryDetailsScreen({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  _BreweryDetailsScreenState createState() => _BreweryDetailsScreenState();
}

class _BreweryDetailsScreenState extends State<BreweryDetailsScreen> {
  final Completer<GoogleMapController> _mapControllerCompleter = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  late LatLng _center;

  late BreweryModel item;

  @override
  void initState() {
    super.initState();
    item = widget.item;
    _center = LatLng(
      double.parse(item.latitude?.isEmpty ?? true ? '9.669111' : item.latitude!),
      double.parse(item.longitude?.isEmpty ?? true ? '80.014007' : item.longitude!),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapControllerCompleter.complete(controller);

    setState(() {
      markers[const MarkerId('place_name')] = Marker(
        markerId: const MarkerId('place_name'),
        position: _center,
        // icon: BitmapDescriptor.,
        infoWindow: const InfoWindow(
          title: 'title',
          snippet: 'address',
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffFFBB00),
        title: Text(item.name ?? ''),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            children: [
              _getItemNameWidget(),
              _getTextWidget(title: 'Type', info: item.type ?? ''),
              _getTextWidget(title: 'Street', info: item.street ?? ''),
              _getTextWidget(title: 'Address_2', info: item.address_2 ?? ''),
              _getTextWidget(title: 'Address_3', info: item.address_3 ?? ''),
              _getTextWidget(title: 'City', info: item.city ?? ''),
              _getTextWidget(title: 'State', info: item.state ?? ''),
              _getTextWidget(title: 'Province', info: item.county_province ?? ''),
              _getTextWidget(title: 'Postcode', info: item.postal_code ?? ''),
              _getTextWidget(title: 'Country', info: item.country ?? ''),
              _getTextWidget(title: 'Phone', info: item.phone ?? ''),
              _getWebsiteWidget(context),
              _getGoogleMapWidget(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getTextWidget({required String title, required String info}) {
    if (title.isEmpty || info.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      children: [
        Row(
          children: [
            Text(
              '$title: ',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Text(
                info,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
      ],
    );
  }

  Widget _getWebsiteWidget(BuildContext context) {
    return Visibility(
      visible: item.website_url?.isNotEmpty ?? false,
      child: Row(
        children: [
          const Text(
            'Website: ',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: InkWell(
              onTap: () async {
                if (!await launch(item.website_url ?? '')) throw 'Could not launch ${item.website_url ?? ''}';
              },
              child: Text(
                item.website_url ?? '',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getGoogleMapWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text(
          'Location: ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.5,
          child: GoogleMap(
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 16.5,
            ),
            markers: markers.values.toSet(),
          ),
        ),
      ],
    );
  }

  Widget _getItemNameWidget() {
    return Container(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        item.name ?? '',
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
