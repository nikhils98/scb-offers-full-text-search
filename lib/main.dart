import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scb_offers/local_storage.dart';

import 'offer.dart';

void main() {
  runApp(const ScbOffers());
}

class ScbOffers extends StatefulWidget {
  const ScbOffers({super.key});

  @override
  State<ScbOffers> createState() => _ScbOffersState();
}

class _ScbOffersState extends State<ScbOffers> {
  late Future<List<Offer>> futureOffers;

  @override
  void initState() {
    super.initState();
    futureOffers = fetchOffers();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'SCB Offers',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity),
        home: Scaffold(
          body: Center(
              child: FutureBuilder<List<Offer>>(
            future: futureOffers,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text('${snapshot.data!.length}');
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const CircularProgressIndicator();
            },
          )),
        ));
  }
}

Future<List<Offer>> fetchOffers() async {
  var offers = await fetchOffersFromLocalStorage();

  if (offers.isNotEmpty) {
    return offers;
  }

  offers = await fetchOffersFromHttp();
  LocalStorage.save('scb_offers', offers);
  return offers;
}

Future<List<Offer>> fetchOffersFromLocalStorage() async {
  final json = await LocalStorage.read('scb_offers');

  if (json == null) {
    return [];
  }

  return (json as List).map((item) => Offer.fromJson(item)).toList();
}

Future<List<Offer>> fetchOffersFromHttp() async {
  final response =
      await http.get(Uri.parse('https://www.sc.com/pk/data/tgl/offers.json'));

  if (response.statusCode != 200) {
    throw Exception('Failed to load offers');
  }

  final json = jsonDecode(response.body)["offers"]["offer"] as List;
  return json.map((item) => Offer.fromJson(item)).toList();
}
