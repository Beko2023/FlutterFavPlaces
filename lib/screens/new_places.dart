import 'dart:io';
import 'package:favorite_places_app/models/places.dart';
import 'package:favorite_places_app/providers/user_places.dart';
import 'package:favorite_places_app/widgets/image_input.dart';
import 'package:favorite_places_app/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewPlacesScreen extends ConsumerStatefulWidget {
  const NewPlacesScreen({super.key});

  @override
  ConsumerState<NewPlacesScreen> createState() => _NewPlacesScreenState();
}

class _NewPlacesScreenState extends ConsumerState<NewPlacesScreen> {
  final _formKey = GlobalKey<FormState>();
  var enteredPlace = "";
  File? _selectedImage;
  PlaceLocation? _selectedLocation;

  void _savePlace() {
    if (_formKey.currentState!.validate() &&
        _selectedImage != null &&
        _selectedLocation != null) {
      _formKey.currentState!.save();

      ref
          .read(userPlacesProvider.notifier)
          .addPlace(enteredPlace, _selectedImage!, _selectedLocation!);

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text("Pick your place"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text("Place"),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1) {
                    return "Please enter a valid input";
                  }
                  return null;
                },
                onSaved: (value) {
                  enteredPlace = value!;
                },
              ),
              const SizedBox(height: 10),
              ImageInput(
                onPickImage: (image) {
                  _selectedImage = image;
                },
              ),
              const SizedBox(height: 14),
              LocationInput(
                onSelectLocation: (location) {
                  print(location);
                  _selectedLocation = location;
                },
              ),
              const SizedBox(height: 14),
              ElevatedButton.icon(
                icon: const Icon(
                  Icons.add,
                ),
                label: const Text('Add Place'),
                onPressed: _savePlace,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
