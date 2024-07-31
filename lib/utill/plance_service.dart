import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class Place {

  String? streetNumber;
  String? street;
  String? city;
  String? zipCode;
  double? lat;
  double? lng;

  Place({
    this.streetNumber,
    this.street,
    this.city,
    this.zipCode,
    this.lat,
    this.lng,
  });

  @override
  String toString() {
    return 'Place(streetNumber: $streetNumber, street: $street, city: $city, zipCode: $zipCode)';
  }
}

class Suggestion {
  final String placeId;
  final String description;

  Suggestion(this.placeId, this.description);

  @override
  String toString() {
    return 'Suggestion(description: $description, placeId: $placeId)';
  }
}

class PlaceApiProvider {

  final client = new http.Client();

  PlaceApiProvider(this.sessionToken);

  final sessionToken;

  static final String androidKey = 'AIzaSyBX9RkuQzSYLDjlJ0lBX6Wi2GCuMwcsHuw';
  static final String iosKey = 'AIzaSyAOvhZ1G3LfP7HBWMEAf_vElRTgzI1rprk';
  //final apiKey = Platform.isAndroid ? androidKey : iosKey;
  final apiKey = androidKey;

  Future<List<Suggestion>> fetchSuggestions(String input, String lang) async {

    print('$input $lang $sessionToken');

    /* final request =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&types=address&language=$lang&components=country:bd&key=$apiKey&sessiontoken=$sessionToken';
    */
    final request =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&language=$lang&components=country:bd&key=$apiKey&sessiontoken=$sessionToken';

    var response;
    try {

      response = await client.get(Uri.parse(request));

    } catch (e, stackTrace) {
      print(e.toString());
      print(stackTrace);
    } finally {
      print('complete');
    }

    print('53 ${response.toString()}');

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        // compose suggestions in a list
        return result['predictions']
            .map<Suggestion>((p) => Suggestion(p['place_id'], p['description']))
            .toList();
      }
      if (result['status'] == 'ZERO_RESULTS') {
        return [];
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

  Future<Place> getPlaceDetailFromId(String placeId) async {

    /* final request =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=address_component&key=$apiKey&sessiontoken=$sessionToken';

      https://maps.googleapis.com/maps/api/geocode/json?latlng=44.4647452,7.3553838&key=apiKey
   */
    final request =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey&sessiontoken=$sessionToken';

    final response = await client.get(Uri.parse(request));

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {

        final components =
        result['result']['address_components'] as List<dynamic>;
        // build result
        final place = Place();
        components.forEach((c) {
          final List type = c['types'];
          if (type.contains('street_number')) {
            place.streetNumber = c['long_name'];
          }
          if (type.contains('route')) {
            place.street = c['long_name'];
          }
          if (type.contains('locality')) {
            place.city = c['long_name'];
          }
          if (type.contains('postal_code')) {
            place.zipCode = c['long_name'];
          }
        });

        final geometry = result['result']['geometry'];
        place.lat = geometry['location']['lat'];
        place.lng = geometry['location']['lng'];

        return place;
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

  Future<String> fetchAddress(LatLng latLng) async {

    final request =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${latLng.latitude},${latLng.longitude}&key=$apiKey';

    final response = await client.get(Uri.parse(request));

    if (response.statusCode == 200) {
      final result = json.decode(response.body);

      print('result $result ');

      if (result['status'] == 'OK') {
        return result['results'][0]['formatted_address'];
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

}
