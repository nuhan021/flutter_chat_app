import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_chat_app/components/auth_text_field.dart';
import 'package:full_chat_app/cubits/search_cubit/search_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:full_chat_app/cubits/search_cubit/search_state.dart';

class SearchScreen extends StatelessWidget {
  TextEditingController searchController = TextEditingController();
  String alterNativeImageUrl = 'https://firebasestorage.googleapis.com/v0/b/test-241a5.appspot.com/o/alternativeImage%2Fuser.png?alt=media&token=8f1d43c8-2b6b-4a42-b460-29aa27b434a2&_gl=1*1lrdonr*_ga*NzM2NjI2Mjc0LjE2OTgxNDYyNzc.*_ga_CW55HF8NVT*MTY5ODc3ODM0NC4zMC4xLjE2OTg3Nzg2MzIuNS4wLjA.';
  List<QueryDocumentSnapshot> allUsers = [];

  SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      appBar: AppBar(
        title: Text('Search users'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            AuthTextField(
              controller: searchController,
              hintText: 'Search user by phone number',
              obscureText: false,
              onChange: (String) {
                BlocProvider.of<SearchCubit>(context).searchUser(
                    allUsers: allUsers, searchTerm: searchController.text);
              },
            ),
            SizedBox(
              height: 50,
            ),
            Expanded(
              child: StreamBuilder(
                stream: BlocProvider.of<SearchCubit>(context).searchData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error : ${snapshot.error}'));
                  } else {
                    allUsers = snapshot.data ?? [];
                    return BlocBuilder<SearchCubit, SearchState>(
                      builder: (context, state) {
                        if(state is SearchUserFindState) {
                          List user = state.findUser.toList();
                          return ListView.separated(
                            itemCount: user.length,
                            separatorBuilder: (context, index) => SizedBox(height: 10,),
                            itemBuilder: (context, index) {
                              if(user[index]['uId'] != FirebaseAuth.instance.currentUser?.uid) {
                                return ListTile(
                                  onTap: () {
                                    Navigator.pushNamed(context, '/chat', arguments: {
                                      "receiverName": "${user[index]['firstName'].toString()} ${user[index]['lastName'].toString()}",
                                      "receiverUserId" : user[index]['uId'],
                                      "receiverUserImageLink" : user[index]['profileUrl']
                                    });
                                  },
                                  contentPadding: EdgeInsets.all(5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  tileColor: Colors.deepPurple[200],
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.deepPurple[300],
                                    backgroundImage: (user[index]['profileUrl'] != '') ? NetworkImage(user[index]['profileUrl'].toString()) : NetworkImage(alterNativeImageUrl) ,
                                    radius: 25,
                                  ),
                                  title: Text("${user[index]['firstName'].toString()} ${user[index]['lastName'].toString()}", style: TextStyle(fontWeight: FontWeight.bold),),
                                  subtitle: Text(user[index]['phone'].toString()),
                                );
                              } else {
                                return Container();
                              }
                            },
                          );
                        } else if (state is SearchUserNotFindState) {
                          return Text('no user found');
                        } else return Text('no user found');
                      },
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
