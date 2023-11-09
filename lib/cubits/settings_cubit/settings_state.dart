import 'dart:io';

abstract class SettingsState {}

class SettingsInitialState extends SettingsState {}

class SettingsImageLoadedState extends SettingsState {
  final String imagePath;
  final File pickedFile;
  final String path;
  SettingsImageLoadedState({required this.imagePath, required this.pickedFile, required this.path});
}

class SettingsImageUploadingState extends SettingsState {
  final String imagePath;
  SettingsImageUploadingState({required this.imagePath});
}

class SettingsImageUploadSuccess extends SettingsState {
  final String imagePath;
  SettingsImageUploadSuccess({required this.imagePath});
}

class SettingsImageNotLoadedState extends SettingsState {}

