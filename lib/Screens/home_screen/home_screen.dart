import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_chat_app/Screens/home_screen/components/chat_list.dart';
import 'package:full_chat_app/Screens/home_screen/components/home_drawer.dart';
import 'package:full_chat_app/cubits/home_cubit/home_cubit.dart';
import 'package:full_chat_app/cubits/home_cubit/home_state.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class HomeScreen extends StatelessWidget {

  HomeScreen({Key? key}) : super(key: key);
  String currentUserName = '';
  String currentUserImageUrl = '';
  String alterNativeImageUrl =
      'https://firebasestorage.googleapis.com/v0/b/test-241a5.appspot.com/o/alternativeImage%2Fuser.png?alt=media&token=8f1d43c8-2b6b-4a42-b460-29aa27b434a2&_gl=1*1lrdonr*_ga*NzM2NjI2Mjc0LjE2OTgxNDYyNzc.*_ga_CW55HF8NVT*MTY5ODc3ODM0NC4zMC4xLjE2OTg3Nzg2MzIuNS4wLjA.';



  @override
  Widget build(BuildContext context) {
    BlocProvider.of<HomeCubit>(context).fatchCurrentUserData();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.deepPurple[100],
        appBar: AppBar(
          title: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if(state is HomeFatchCurrentUserDataState) {
                currentUserName = '${state.currentUserData[0]['firstName']} ${state.currentUserData[0]['lastName']}';
                currentUserImageUrl = '${state.currentUserData[0]['profileUrl']}';
              return Text('Chatyfi');
              } else {
                return Text('');
              }
            },
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/search');
                },
                icon: Icon(Icons.search_rounded))
          ],
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.wechat_outlined),
              ),
              Tab(icon: Icon(Icons.call)),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: LiquidPullToRefresh(

            onRefresh: () async{
              BlocProvider.of<HomeCubit>(context).fatchCurrentUserData();
            },
            child: Column(
              children: [
                Expanded(
                  child: TabBarView(children: [
                    Container(
                        margin: EdgeInsets.only(top: 20),
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(FirebaseAuth.instance.currentUser?.uid)
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
                              if (snapshot.hasData && snapshot.data!.exists) {
                                Map<String, dynamic> userData =
                                snapshot.data!.data() as Map<String, dynamic>;
                                List<dynamic> chatList =
                                    userData['chatList'] as List<dynamic> ?? [];

                                return Users(chatList: chatList, alternativeImage: alterNativeImageUrl,);
                              } else {
                                return Text('No data avai');
                              }
                            }
                          },
                        )),
                    Container(
                      child: Center(
                        child: Text("call"),
                      ),
                    )
                  ]),
                ),
              ],
            ),
          ),
        ),
        drawer: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeFatchCurrentUserDataState) {
              return HomeDrawer(
                currentUserName:currentUserName,
                currentUserImageUrl:currentUserImageUrl,
              );
            } else {
              return HomeDrawer(
                currentUserName: '',
                currentUserImageUrl: '',
              );
            }
          },
        ),
      ),
    );
  }
}
