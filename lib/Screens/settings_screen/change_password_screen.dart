import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_chat_app/components/auth_button.dart';
import 'package:full_chat_app/components/auth_text_field.dart';
import 'package:full_chat_app/cubits/change_password_cubit/change_password_cubit.dart';
import 'package:full_chat_app/cubits/change_password_cubit/change_password_state.dart';

class ChangePassword extends StatelessWidget {
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();

  ChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      appBar: AppBar(
        title: Text('Change password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
  builder: (context, state) {
    return AuthTextField(
                controller: oldPasswordController,
                hintText: 'Type old password',
                obscureText: true,
      errorText: (state is ChangeOldPasswordErrorState) ? state.msg.toString() : null,
    );
  },
),
            SizedBox(
              height: 15,
            ),
            BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
              builder: (context, state) {
                return AuthTextField(
                  controller: newPasswordController,
                  hintText: 'Type new password',
                  obscureText: false,
                  onChange: (val) {
                    BlocProvider.of<ChangePasswordCubit>(context)
                        .checkNewPasswordValidation(
                        newPassword: newPasswordController.text);
                  },
                  errorText: (state is ChangePasswordNewPasswordErrorState)
                      ? state.msg.toString()
                      : null,
                );
              },
            ),
            SizedBox(
              height: 15,
            ),
            BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
              listener: (context, state) {
                if(state is ChangeOldPasswordValidateState) {

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Password changed.Please Sign in again'),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    )
                  );

                  Timer(Duration(seconds: 2), () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                    Navigator.pushNamed(context, '/sign_in');
                  },);
                }
              },
              builder: (context, state) {
                if(state is ChangePasswordLoadingState) {
                  return Center(child: CircularProgressIndicator(),);
                } else {
                  return AuthButton(
                      text: 'Change password',
                      color: (state is ChangePasswordNewPasswordValidateState)
                          ? Colors.deepPurple[500]
                          : Colors.grey,
                      onTap: (state is ChangePasswordNewPasswordValidateState)
                          ? () {
                        BlocProvider.of<ChangePasswordCubit>(context)
                            .changePassword(
                            oldPassword: oldPasswordController.text,
                            newPassword: newPasswordController.text
                        );
                      }
                          : () {}
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
