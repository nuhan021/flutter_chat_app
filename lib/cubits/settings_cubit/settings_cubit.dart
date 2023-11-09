import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_chat_app/cubits/settings_cubit/settings_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() :super(SettingsInitialState());


  void pickImage({required String userId}) async {
    final result = await FilePicker.platform
        .pickFiles(
        allowMultiple: false,
        allowCompression: true,
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg']);

    if(result == null) {
      emit(SettingsImageNotLoadedState());
    } else if(result.files.isNotEmpty) {
      final file = File(result.files.single.path!);
      final path = '$userId/${result.files.single.name}';
      final imgPath = result.files.single.path!;
      emit(SettingsImageLoadedState(
        imagePath: imgPath,
        path: path,
        pickedFile: file
      ));
    }
  }

  void uploadImage({required File pickedFile, required String path , required String imagePath, required String profileUrl}) async {
    emit(SettingsImageUploadingState(imagePath: imagePath));
    try{

      print("Url is: ${profileUrl}");

      if(profileUrl != '') {
        final oldImageRef = FirebaseStorage.instance.refFromURL(profileUrl);
        await oldImageRef.delete();
        print('image delete');
      }

      final ref = FirebaseStorage.instance.ref().child(path);
      UploadTask uploadTask = ref.putFile(pickedFile);
      final snapshot = await uploadTask.whenComplete(() {

      });
      final urlDownload = await snapshot.ref.getDownloadURL();
      FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid.toString()).update({
        'profileUrl': urlDownload.toString()
      });
      print(urlDownload.toString());
      emit(SettingsImageUploadSuccess(imagePath: urlDownload));
    } on FirebaseException catch(ex) {
      print(ex.code.toString());
    }
  }
}