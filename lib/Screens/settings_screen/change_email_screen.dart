import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_chat_app/components/auth_button.dart';
import 'package:full_chat_app/components/auth_text_field.dart';

import '../../cubits/change_email_cubit/change_email_cubit.dart';
import '../../cubits/change_email_cubit/change_email_state.dart';
class ChangeEmailScreen extends StatelessWidget {
  final String currentUserEmail;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  ChangeEmailScreen({super.key, required this.currentUserEmail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      appBar: AppBar(
        title: const Text('Change email'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            children: [
              Text(
                'First name: $currentUserEmail',
                style: TextStyle(
                    color: Colors.grey[900],
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 15,
              ),
              BlocBuilder<ChangeEmailCubit, ChangeEmailState>(
                builder: (context, state) {
                  return Text(
                    (state is PasswordErrorState) ? state.msg.toString() : '',
                    style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                  );
                },
              ),
              SizedBox(
                height: 15,
              ),
              BlocBuilder<ChangeEmailCubit, ChangeEmailState>(
                builder: (context, state) {
                  return AuthTextField(
                    controller: emailController,
                    hintText: 'New email',
                    obscureText: false,
                    errorText: (state is EmailErrorState)
                        ? state.msg.toString()
                        : null,
                    onChange: (val) {
                      BlocProvider.of<ChangeEmailCubit>(context)
                          .validateEmail(email: emailController.text);
                    },
                  );
                },
              ),
              SizedBox(
                height: 15,
              ),
              AuthTextField(
                  controller: passwordController,
                  hintText: 'Enter password',
                  obscureText: true),
              SizedBox(
                height: 15,
              ),
              BlocBuilder<ChangeEmailCubit, ChangeEmailState>(
                builder: (context, state) {
                  if(state is LoadingState) {
                    return Center(child: CircularProgressIndicator(),);
                  } else {
                    return AuthButton(
                      text: 'Change email',
                      color: (state is EmailValidateState)
                          ? Colors.black
                          : Colors.grey,
                      onTap: (state is EmailValidateState) ? () {
                        BlocProvider.of<ChangeEmailCubit>(context)
                            .checkPassword(
                            password: passwordController.text,
                            newEmail: emailController.text);
                      } : () {},
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
