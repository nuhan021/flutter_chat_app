import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_chat_app/Screens/chat_screen/chat_screen.dart';
import 'package:full_chat_app/Screens/home_screen/home_screen.dart';
import 'package:full_chat_app/Screens/login_screen/login_screen.dart';
import 'package:full_chat_app/Screens/register_screen/register_screen.dart';
import 'package:full_chat_app/Screens/search_screen/search_screen.dart';
import 'package:full_chat_app/Screens/settings_screen/change_email_screen.dart';
import 'package:full_chat_app/Screens/settings_screen/change_name_screen.dart';
import 'package:full_chat_app/Screens/settings_screen/change_number_screen.dart';
import 'package:full_chat_app/Screens/settings_screen/change_password_screen.dart';
import 'package:full_chat_app/Screens/settings_screen/settings_screen.dart';
import 'package:full_chat_app/cubits/auth_cubit/auth_cubit.dart';
import 'package:full_chat_app/cubits/change_name_cubit/change_name_cubit.dart';
import 'package:full_chat_app/cubits/change_number_cubit/change_number_cubit.dart';
import 'package:full_chat_app/cubits/change_password_cubit/change_password_cubit.dart';
import 'package:full_chat_app/cubits/chat_cubit/chat_cubit.dart';
import 'package:full_chat_app/cubits/home_cubit/home_cubit.dart';
import 'package:full_chat_app/cubits/search_cubit/search_cubit.dart';
import 'package:full_chat_app/cubits/settings_cubit/settings_cubit.dart';

import '../cubits/change_email_cubit/change_email_cubit.dart';

class Routes {
  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      // TODO __ sign in route
      case '/sign_in':
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => AuthCubit(),
            child: LoginScreen(),
          ),
        );

      // TODO __ sign up route
      case '/sign_up':
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => AuthCubit(),
            child: RegisterScreen(),
          ),
        );

      // TODO __ home route
      case '/home':
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => HomeCubit(),
            child: HomeScreen(),
          ),
        );

      // TODO __ chat route
      case '/chat':
        Map<String, dynamic> arguments =
            settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => ChatCubit(),
            child: ChatScreen(
                receiverName: arguments['receiverName'],
                receiverUserImageLink: arguments['receiverUserImageLink'],
                receiverUserId: arguments['receiverUserId']),
          ),
        );

      // todo __ search screen
      case '/search':
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => SearchCubit(),
            child: SearchScreen(),
          ),
        );

      //todo -- settings screen
      case '/settings':
        Map<String, dynamic> arguments =
            settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider<HomeCubit>(
                create: (context) => HomeCubit(),
              ),
              BlocProvider<SettingsCubit>(
                create: (context) => SettingsCubit(),
              )
            ],
            child: SettingsScreen(
              currentUserName: arguments['name'].toString(),
            ),
          ),
        );

      //todo -- change password screen
      case '/change_password':
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => ChangePasswordCubit(),
            child: ChangePassword(),
          ),
        );

      //todo -- change email screen
      case '/change_email':
        Map<String, dynamic> arguments =
            settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => ChangeEmailCubit(),
            child: ChangeEmailScreen(currentUserEmail: arguments['email']),
          ),
        );

      //todo -- change name screen
      case '/change_name':
        Map<String, dynamic> arguments =
            settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => ChangeNameCubit(),
            child: ChangeNameScreen(
              firstname: arguments['firstName'],
              lastName: arguments['lastName'],
            ),
          ),
        );

      case '/change_number':
        Map<String, dynamic> arguments =
            settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => ChangeNumberCubit(),
            child: ChangeNumberScreen(
              currentUserNumber: arguments['currentUserNumber'],
            ),
          ),
        );
    }
    return null;
  }
}
