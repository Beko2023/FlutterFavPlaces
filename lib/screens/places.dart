import 'package:favorite_places_app/models/places.dart';
import 'package:favorite_places_app/providers/user_places.dart';
import 'package:favorite_places_app/screens/new_places.dart';
import 'package:favorite_places_app/widgets/places_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesScreen extends ConsumerStatefulWidget {
  const PlacesScreen({super.key});

  @override
  ConsumerState<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends ConsumerState<PlacesScreen> {
  late Future<void> _placesFuture;

  @override
  void initState() {
    super.initState();
    _placesFuture = ref.read(userPlacesProvider.notifier).loadPlaces();
  }

  @override
  Widget build(BuildContext context) {
    final userPlaces = ref.watch(userPlacesProvider);

    void addPlaces() async {
      await Navigator.of(context).push<Places>(
        MaterialPageRoute(
          builder: (ctx) => const NewPlacesScreen(),
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          title: const Row(
            children: [
              SizedBox(width: 10),
              Text("Your Places"),
            ],
          ),
          actions: [
            SizedBox(
              width: 40,
              height: 40,
              child: FloatingActionButton(
                onPressed: addPlaces,
                child: const Icon(Icons.add),
              ),
            ),
            const SizedBox(width: 30),
          ],
        ),
        body: FutureBuilder(
          future: _placesFuture,
          builder: (ctx, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? const Center(child: CircularProgressIndicator())
                  : PlacesList(places: userPlaces),
        ));
  }
}
