import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_chat_app/components/auth_button.dart';
import 'package:full_chat_app/components/auth_text_field.dart';
import 'package:full_chat_app/cubits/change_number_cubit/change_number_cubit.dart';
import 'package:full_chat_app/cubits/change_number_cubit/change_number_state.dart';

class ChangeNumberScreen extends StatelessWidget {
  final String currentUserNumber;
  TextEditingController numberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  ChangeNumberScreen({super.key, required this.currentUserNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      appBar: AppBar(
        title: Text('Change nane'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              children: [
                Text(
                  'You current number: $currentUserNumber',
                  style: TextStyle(
                      color: Colors.grey[900],
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 15,
                ),
                BlocBuilder<ChangeNumberCubit, ChangeNumberState>(
                  builder: (context, state) {
                    return AuthTextField(
                      controller: numberController,
                      hintText: 'New number',
                      obscureText: false,
                      errorText: (state is NumberInvalideState)
                          ? state.msg.toString()
                          : null,
                      onChange: (val) {
                        BlocProvider.of<ChangeNumberCubit>(context).checkNumber(number: numberController.text);
                      },
                    );
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                BlocBuilder<ChangeNumberCubit, ChangeNumberState>(
                  builder: (context, state) {
                    return AuthTextField(
                      controller: passwordController,
                      hintText: 'Password',
                      obscureText: true,
                      errorText: (state is PasswordInvalideState)
                          ? state.msg.toString()
                          : null,
                    );
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                BlocConsumer<ChangeNumberCubit, ChangeNumberState>(
                  listener: (context, state) {
                    if (state is PasswordValideState) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Number update success'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 1),
                      ));
                      Timer(Duration(seconds: 1), () {
                        Navigator.popUntil(context, (route) => route.isFirst);
                        Navigator.pushNamed(context, '/home');
                      });
                    }
                  },
                  builder: (context, state) {
                    if (state is LoadingState) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return AuthButton(
                        text: 'Change number',
                        color: (state is NumberValideState)
                            ? Colors.black
                            : Colors.grey,
                        onTap: () {
                          BlocProvider.of<ChangeNumberCubit>(context)
                              .updateNumber(
                                  number: numberController.text,
                                  password: passwordController.text);
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
