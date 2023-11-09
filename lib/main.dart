import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_chat_app/cubits/auth_cubit/auth_cubit.dart';
import 'package:full_chat_app/cubits/auth_cubit/auth_state.dart';
import 'package:full_chat_app/routes/routes.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
    webProvider: ReCaptchaV3Provider('6Lezm_EoAAAAAM1-zUnLPO5Ofw9pwEbodD40Wm-q')
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          return MaterialApp(
            theme: ThemeData(
                platform: TargetPlatform.iOS,
              primarySwatch: Colors.deepPurple
              // useMaterial3: true,
            ),
            debugShowCheckedModeBanner: false,
            onGenerateRoute: Routes().onGenerateRoute,
            initialRoute: (state is AuthSignInState) ? '/home' : '/sign_in',
          );
        },
      ),
    );
  }
}
