import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_chat_app/cubits/settings_cubit/settings_cubit.dart';
import 'package:full_chat_app/cubits/settings_cubit/settings_state.dart';

class SettingsScreen extends StatelessWidget {
  final String currentUserName;
  String alterNativeImageUrl =
      'https://firebasestorage.googleapis.com/v0/b/test-241a5.appspot.com/o/alternativeImage%2Fuser.png?alt=media&token=8f1d43c8-2b6b-4a42-b460-29aa27b434a2&_gl=1*1lrdonr*_ga*NzM2NjI2Mjc0LjE2OTgxNDYyNzc.*_ga_CW55HF8NVT*MTY5ODc3ODM0NC4zMC4xLjE2OTg3Nzg2MzIuNS4wLjA.';
  String profileUrl = '';
  String currentUserEmail = '';
  String currentUserFirstName = '';
  String currentUserLastName = '';
  String currentUserNumber ='';

  SettingsScreen({
    super.key,
    required this.currentUserName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            //profile picture and email and phone number
            Container(
              height: 200,
              width: double.infinity,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(children: [
                      BlocBuilder<SettingsCubit, SettingsState>(
                        builder: (context, state) {
                          if (state is SettingsImageLoadedState) {
                            return CircleAvatar(
                              backgroundColor: Colors.grey,
                              backgroundImage: FileImage(
                                  File(state.imagePath)),
                              radius: 70,
                            );
                          } else if (state is SettingsImageUploadingState) {
                            return CircleAvatar(
                              backgroundColor: Colors.grey,
                              backgroundImage: FileImage(
                                  File(state.imagePath)),
                              radius: 70,
                            );
                          } else if (state is SettingsImageUploadSuccess) {
                            profileUrl = state.imagePath.toString();
                            return CircleAvatar(
                              backgroundColor: Colors.grey,
                              backgroundImage:
                                  NetworkImage(state.imagePath.toString()), /////
                              radius: 70,
                            );
                          } else if(state is SettingsInitialState) {
                            return StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(FirebaseAuth.instance.currentUser!.uid
                                      .toString())
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text("Error: ${snapshot.error}");
                                } else {
                                  if (snapshot.hasData &&
                                      snapshot.data!.exists) {
                                    Map<String, dynamic> userData =
                                        snapshot.data!.data()
                                            as Map<String, dynamic>;
                                    profileUrl =
                                        userData['profileUrl'].toString();
                                    currentUserEmail = userData['email'];
                                    currentUserFirstName = userData['firstName'];
                                    currentUserLastName = userData['lastName'];
                                    currentUserNumber = userData['phone'];
                                    return CircleAvatar(
                                      backgroundColor: Colors.grey,
                                      backgroundImage: (profileUrl != '')
                                          ? NetworkImage(profileUrl.toString())
                                          : NetworkImage(alterNativeImageUrl),
                                      radius: 70,
                                    );
                                  }
                                }
                                return SizedBox();
                              },
                            );
                          } else{
                            return SizedBox();
                          }
                        },
                      ),
                      Positioned(
                          bottom: 0,
                          child: IconButton(
                              onPressed: () {
                                BlocProvider.of<SettingsCubit>(context)
                                    .pickImage(userId: FirebaseAuth.instance.currentUser!.uid.toString());
                              },
                              icon: Icon(
                                Icons.edit,
                                color: Colors.deepPurple[300],
                              ))),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: BlocBuilder<SettingsCubit, SettingsState>(
                          builder: (context, state) {
                            if (state is SettingsImageLoadedState) {
                              return IconButton(
                                  onPressed: () {
                                    BlocProvider.of<SettingsCubit>(context)
                                        .uploadImage(
                                            pickedFile: state.pickedFile,
                                            profileUrl: profileUrl,
                                            path: state.path,
                                            imagePath: state.imagePath);
                                  },
                                  icon: Icon(
                                    Icons.cloud_upload,
                                    color: Colors.greenAccent,
                                  ));
                            } else if (state is SettingsImageUploadingState) {
                              return CircularProgressIndicator();
                            } else {
                              return Container();
                            }
                          },
                        ),
                      )
                    ]),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      currentUserName,
                      style: TextStyle(
                          color: Colors.grey[900],
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    )
                  ],
                ),
              ),
            ),

            SizedBox(
              height: 25,
            ),

            // all settings
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //name
                    ListTile(
                      leading: Icon(
                        Icons.title,
                        size: 30,
                      ),
                      title: Text(
                        'Name',
                        style: TextStyle(
                            color: Colors.grey[900],
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('Change your name'),
                      tileColor: Colors.deepPurple[200],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, '/change_name', arguments: {
                          'firstName' : currentUserFirstName,
                          'lastName' : currentUserLastName
                        });
                      },
                    ),

                    //email
                    SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.key,
                        size: 30,
                      ),
                      title: Text(
                        'Password',
                        style: TextStyle(
                            color: Colors.grey[900],
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('Change your password'),
                      tileColor: Colors.deepPurple[200],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, '/change_password');
                      },
                    ),

                    //phone number
                    SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.numbers,
                        size: 30,
                      ),
                      title: Text(
                        'Number',
                        style: TextStyle(
                            color: Colors.grey[900],
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('Change your phone number'),
                      tileColor: Colors.deepPurple[200],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, '/change_number' , arguments: {
                          'currentUserNumber': currentUserNumber.toString()
                        });
                      },
                    ),

                    //password
                    SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.alternate_email,
                        size: 30,
                      ),
                      title: Text(
                        'Email',
                        style: TextStyle(
                            color: Colors.grey[900],
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('Change your email'),
                      tileColor: Colors.deepPurple[200],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, '/change_email', arguments: {
                          'email': currentUserEmail
                        });
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
