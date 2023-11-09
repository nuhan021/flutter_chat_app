import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_chat_app/components/auth_button.dart';
import 'package:full_chat_app/components/auth_icon_button.dart';
import 'package:full_chat_app/components/auth_text_field.dart';
import 'package:full_chat_app/cubits/auth_cubit/auth_cubit.dart';
import 'package:full_chat_app/cubits/auth_cubit/auth_state.dart';

import '../../util/text.dart';

class LoginScreen extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 50,
                  ),


                  // TODO __logo
                  Icon(
                    Icons.message_outlined,
                    size: 80,
                    color: Colors.grey[800],
                  ),
                  const SizedBox(
                    height: 50,
                  ),

                  // TODO __ welcome back message
                  const Text(
                    LoginScreenText.welcomeMessage,
                    style: TextStyle(fontSize: 16),
                  ),

                  // TODO __ error message
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      if(state is AuthSignInErrorState) {
                        return Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Text(state.msg.toString(),style: TextStyle(color: Colors.red),),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),

                  const SizedBox(
                    height: 25,
                  ),

                  //TODO __ email textfield
                  AuthTextField(
                      controller: emailController,
                      hintText: LoginScreenText.emailHintMessage,
                      obscureText: false),
                  const SizedBox(
                    height: 10,
                  ),

                  //TODO __ password textfield
                  AuthTextField(
                      controller: passwordController,
                      hintText: LoginScreenText.passwordHintMessage,
                      obscureText: true),
                  const SizedBox(
                    height: 25,
                  ),

                  // TODO: sign in button
                  BlocConsumer<AuthCubit, AuthState>(
                    listener: (context, state) {
                      if (state is AuthSignInState) {
                        Navigator.popUntil(context, (route) => route.isFirst);
                        Navigator.pushReplacementNamed(context, '/home');
                      }
                    },
                    builder: (context, state) {
                      if (state is AuthLoadingState) {

                        // TODO __ loading indicator
                        return const Padding(
                          padding: EdgeInsets.all(25.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        );
                      } else {

                        // TODO __ sign in button
                        return AuthButton(
                          text: LoginScreenText.signInButtonText,
                          onTap: () {
                            BlocProvider.of<AuthCubit>(context).signIn(
                                email: emailController.text,
                                password: passwordController.text);
                          },
                        );
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  // TODO __ or sign in with text
                  const Text(
                    LoginScreenText.signInOtherMethodText,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),

                  // TODO __ login with google and apple
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // TODO __ google button
                      AuthLoginIconButton(
                          onTap: () {},
                          icon: LoginScreenText.googleIconAssetImageLink),

                      const SizedBox(
                        width: 10,
                      ),

                      // TODO __ apple button
                      AuthLoginIconButton(
                          onTap: () {},
                          icon: LoginScreenText.appleIconAssetImageLink)
                    ],
                  ),

                  const SizedBox(
                    height: 50,
                  ),

                  // TODO __ not a member? register now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(LoginScreenText.notAmemberText),
                      SizedBox(
                        width: 4,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/sign_up');
                        },

                        // TODO __ register button
                        child: Text(
                          LoginScreenText.registerButtonText,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
