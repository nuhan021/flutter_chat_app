import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_chat_app/components/auth_button.dart';
import 'package:full_chat_app/components/auth_text_field.dart';
import 'package:full_chat_app/cubits/change_name_cubit/change_name_cubit.dart';
import 'package:full_chat_app/cubits/change_name_cubit/change_name_state.dart';

class ChangeNameScreen extends StatelessWidget {
  final String firstname;
  final String lastName;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  ChangeNameScreen(
      {super.key, required this.firstname, required this.lastName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      appBar: AppBar(
        title: Text('Change name'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              Text(
                'Your current name: $firstname $lastName',
                style: TextStyle(
                    color: Colors.grey[900],
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 15,
              ),
              AuthTextField(
                  controller: firstNameController,
                  hintText: 'First name',
                  obscureText: false),
              SizedBox(
                height: 15,
              ),
              AuthTextField(
                  controller: lastNameController,
                  hintText: 'Last name',
                  obscureText: false),
              SizedBox(
                height: 15,
              ),
              BlocBuilder<ChangeNameCubit, ChangeNameState>(
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
              BlocConsumer<ChangeNameCubit, ChangeNameState>(
                listener: (context, state) {
                  if(state is PasswordValidateState) {
                    Navigator.popUntil(context, (route) => route.isFirst);
                    Navigator.pushNamed(context, '/home');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Name changed'),backgroundColor: Colors.green,),
                    );
                  }
                },
                builder: (context, state) {
                  if(state is LoadingState) {
                    return Center(child: CircularProgressIndicator(),);
                  } else {
                    return AuthButton(
                        text: 'Change name',
                        onTap: () {
                          BlocProvider.of<ChangeNameCubit>(context).changeName(
                              fName: firstNameController.text,
                              lName: lastNameController.text,
                              password: passwordController.text);
                        });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
