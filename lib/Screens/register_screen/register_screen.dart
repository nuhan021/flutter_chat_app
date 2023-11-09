import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_chat_app/cubits/auth_cubit/auth_cubit.dart';
import 'package:full_chat_app/cubits/auth_cubit/auth_state.dart';

import '../../components/auth_button.dart';
import '../../components/auth_icon_button.dart';
import '../../components/auth_text_field.dart';
import '../../util/text.dart';

class RegisterScreen extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 50,
                  ),

                  // TODO __ logo
                  Icon(
                    Icons.message_outlined,
                    size: 80,
                    color: Colors.grey[800],
                  ),
                  const SizedBox(
                    height: 50,
                  ),

                  // TODO __ create account message
                  const Text(
                    RegisterScreenText.accountCreateMessage,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      if(state is AuthSignUpErrorState) {
                        return Text(state.msg, style: TextStyle(color: Colors.red),);
                      } else {
                        return Container();
                      }
                    },
                  ),
                  const SizedBox(
                    height: 25,
                  ),

                  // todo __ names
                  Row(
                    children: [
                      // TODO __ email First name
                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          return Expanded(
                            child: AuthTextField(
                              controller: firstNameController,
                              hintText: RegisterScreenText.firstNameText,
                              obscureText: false,
                              errorText: (state is AuthSignUpNamesState)
                                  ? state.msg.toString()
                                  : null,
                              onChange: (String) {
                                BlocProvider.of<AuthCubit>(context)
                                    .authSignUpNames(
                                    firstName: firstNameController.text,
                                    lastName: lastNameController.text);
                              },
                            ),
                          );
                        },
                      ),

                      SizedBox(
                        width: 10,
                      ),

                      // TODO __ Last name
                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          return Expanded(
                            child: AuthTextField(
                              controller: lastNameController,
                              hintText: RegisterScreenText.lastNameText,
                              obscureText: false,
                              errorText: (state is AuthSignUpNamesState)
                                  ? state.msg.toString()
                                  : null,
                              onChange: (String) {
                                BlocProvider.of<AuthCubit>(context)
                                    .authSignUpNames(
                                    firstName: firstNameController.text,
                                    lastName: lastNameController.text);
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  //todo __ mobile number and email
                  Row(
                    children: [
                      // TODO __ mobile number
                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          return Expanded(
                            child: AuthTextField(
                              controller: phoneNumberController,
                              hintText: RegisterScreenText.phoneText,
                              obscureText: false,
                              errorText: (state is AuthSignUpPhoneState)
                                  ? state.msg.toString()
                                  : null,
                              onChange: (String) {
                                BlocProvider.of<AuthCubit>(context)
                                    .authSignUpPhone(
                                    phone: phoneNumberController.text);
                              },
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        width: 10,
                      ),

                      // TODO __ email textfield
                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          return Expanded(
                            child: AuthTextField(
                              controller: emailController,
                              hintText: LoginScreenText.emailHintMessage,
                              obscureText: false,
                              errorText: (state is AuthSignUpEmailTextChange)
                                  ? state.msg.toString()
                                  : null,
                              onChange: (String) {
                                BlocProvider.of<AuthCubit>(context)
                                    .authSignUpEmailTextChange(
                                    email: emailController.text);
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  // todo __ password and confirm password
                  Row(
                    children: [
                      // TODO __ password textfield
                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          return Expanded(
                            child: AuthTextField(
                              controller: passwordController,
                              hintText: LoginScreenText.passwordHintMessage,
                              obscureText: true,
                              errorText: (state is AuthPasswordErrorState)
                                  ? state.msg.toString()
                                  : null,
                              onChange: (String) {
                                BlocProvider.of<AuthCubit>(context)
                                    .authSignupPasswordChange(
                                    password: passwordController.text);
                              },
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        width: 10,
                      ),

                      // TODO __ confirm password textField
                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          return Expanded(
                            child: AuthTextField(
                              controller: confirmPasswordController,
                              hintText: RegisterScreenText.confirmPassword,
                              errorText:
                              (state is AuthConfirmPasswordErrorState)
                                  ? state.msg.toString()
                                  : null,
                              obscureText: true,
                              onChange: (String) {
                                BlocProvider.of<AuthCubit>(context)
                                    .authSignupConfirmPasswordChange(
                                    confirmPassword:
                                    confirmPasswordController.text,
                                    password: passwordController.text);
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 25,
                  ),

                  // TODO __ sign up button
                  BlocConsumer<AuthCubit, AuthState>(
                    listener: (context, state) {
                      // account create success snackbar
                      if (state is AuthSignUpState) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Account created'),
                          backgroundColor: Colors.green,
                          duration: Duration(seconds: 2),
                        ));

                        // after successfully created account return to the sign in page
                        Timer(Duration(seconds: 2), () {
                          Navigator.popUntil(context, (route) => route.isFirst);
                          Navigator.pushReplacementNamed(context, '/home');
                        });
                      }
                    },

                    // TODO __sign up button or loading indicator
                    builder: (context, state) {
                      if (state is AuthLoadingState) {
                        // TODO __ loading icon
                        return const Padding(
                          padding: EdgeInsets.all(25.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        );
                      } else {
                        // TODO __ sign up button
                        return AuthButton(
                          text: RegisterScreenText.signUpButtonText,
                          onTap: () {
                            (state is AuthConfirmPasswordValidateState)
                                ? BlocProvider.of<AuthCubit>(context).signUp(
                                email: emailController.text.trim(),
                                password: passwordController.text,
                                firstName: firstNameController.text,
                                lastName: lastNameController.text,
                                phone: phoneNumberController.text)
                                : null;
                          },
                          color: (state is AuthConfirmPasswordValidateState)
                              ? Colors.black
                              : Colors.grey,
                        );
                      }
                    },
                  ),
                  const SizedBox(
                    height: 25,
                  ),

                  // TODO __ or sign in with text
                  const Text(
                    RegisterScreenText.signUpOtherMethodText,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),

                  // TODO __ Sign up with google and apple

                  // google
                  AuthSignUpIconButton(
                    onTap: () {},
                    title: RegisterScreenText.signInWithGoogleText,
                    icon: LoginScreenText.googleIconAssetImageLink,
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  // TODO __ apple
                  AuthSignUpIconButton(
                    onTap: () {},
                    title: RegisterScreenText.signInWithAppleText,
                    icon: LoginScreenText.appleIconAssetImageLink,
                  ),

                  const SizedBox(
                    height: 50,
                  ),

                  // TODO __ not a member? register now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(RegisterScreenText.alreadyAmemberText),
                      const SizedBox(
                        width: 4,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/sign_in');
                        },
                        child: const Text(
                          RegisterScreenText.signInNowText,
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
