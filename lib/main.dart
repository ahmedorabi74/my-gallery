import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galleryy/cubits/LoginCubit/login_cubit.dart';

import 'package:galleryy/screens/LoginPage.dart';
import 'package:galleryy/screens/home_View.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constant/constants.dart';
import 'cubits/fetch_image_cubit/fetch_image_cubit.dart';
import 'cubits/upload_image_cubit/upload_image_cubit.dart';

late SharedPreferences sharedPref;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPref = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginCubit(),
        ),
        BlocProvider(
          create: (context) => FetchImageCubit()..fetchImages(),
        ),
        BlocProvider(
          create: (context) => UploadImageCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home:
            Constants.userToken == null ? const LoginPage() : const HomePage(),
      ),
    );
  }
}
