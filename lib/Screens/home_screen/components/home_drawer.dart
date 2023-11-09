import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_chat_app/cubits/auth_cubit/auth_cubit.dart';
import 'package:full_chat_app/cubits/auth_cubit/auth_state.dart';

class HomeDrawer extends StatelessWidget {
  final String currentUserName;
  final String currentUserImageUrl;
  String alterNativeImageUrl =
      'https://firebasestorage.googleapis.com/v0/b/test-241a5.appspot.com/o/alternativeImage%2Fuser.png?alt=media&token=8f1d43c8-2b6b-4a42-b460-29aa27b434a2&_gl=1*1lrdonr*_ga*NzM2NjI2Mjc0LjE2OTgxNDYyNzc.*_ga_CW55HF8NVT*MTY5ODc3ODM0NC4zMC4xLjE2OTg3Nzg2MzIuNS4wLjA.';

  HomeDrawer({
    super.key,
    required this.currentUserName,
    required this.currentUserImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.deepPurple[100],
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 50),
              height: 70,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: Colors.deepPurple.withOpacity(0.2),
                          width: 2))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey,
                          backgroundImage: (currentUserImageUrl != '')
                              ? NetworkImage(currentUserImageUrl)
                              : NetworkImage(alterNativeImageUrl),
                          radius: 25,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: Text(
                            currentUserName,
                            style: TextStyle(
                                color: Colors.grey[900],
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/settings', arguments: {
                          'name': currentUserName,
                        });
                      },
                      icon: Icon(
                        Icons.settings,
                        color: Colors.grey[900],
                        size: 30,
                      ))
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  //chats button
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 8,
                          ),
                          Container(
                              decoration: BoxDecoration(
                                color: Colors.deepPurple,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Icon(
                                  Icons.wechat_sharp,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              )),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            'Chats',
                            style: TextStyle(
                                color: Colors.grey[900],
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  //groups button
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 8,
                          ),
                          Container(
                              decoration: BoxDecoration(
                                color: Colors.deepPurple,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Icon(
                                  Icons.groups_outlined,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              )),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            'Groups',
                            style: TextStyle(
                                color: Colors.grey[900],
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  //community button
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 8,
                          ),
                          Container(
                              decoration: BoxDecoration(
                                color: Colors.deepPurple,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Icon(
                                  Icons.chat,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              )),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            'Message requests',
                            style: TextStyle(
                                color: Colors.grey[900],
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),

                  //archive button
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 8,
                          ),
                          Container(
                              decoration: BoxDecoration(
                                color: Colors.deepPurple,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Icon(
                                  Icons.archive,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              )),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            'Archive',
                            style: TextStyle(
                                color: Colors.grey[900],
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    alignment: Alignment.bottomRight,
                    child: BlocConsumer<AuthCubit, AuthState>(
                      listener: (context, state) {
                        if(state is AuthSignOutState) {
                          Navigator.popUntil(context, (route) => route.isFirst);
                          Navigator.pushNamed(context, '/sign_in');
                        }
                      },
                      builder: (context, state) {
                        return TextButton(
                          onPressed: (){
                            BlocProvider.of<AuthCubit>(context).signOut();
                          },
                          child: Row(
                            children: [
                              Text('Sign out', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                              SizedBox(width: 10,),
                              Icon(Icons.logout, color: Colors.redAccent,)
                            ],
                          ),
                        );
                      }

                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
