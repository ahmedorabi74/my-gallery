import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galleryy/cubits/login_cubit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../widgets/Button.dart';
import '../widgets/CustomTextField.dart';
import 'HomePage.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isValidEmail(String email) {
      // Define a regular expression for validating email addresses
      String emailPattern = r'^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+$';
      RegExp regExp = RegExp(emailPattern);

      // Return true if the email matches the pattern, false otherwise
      return regExp.hasMatch(email);
    }

    bool isLoading = false;
    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          isLoading = true;
        } else if (state is LoginSuccess) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: ((context) => const HomePage()),
            ),
          );
          isLoading = false;
        } else if (state is LoginFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 2),
            ),
          );
          isLoading = false;
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: isLoading,
          child: Scaffold(
            body: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      "assets/images/Screenshot 2024-09-11 190032.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: SingleChildScrollView(
                  // Enables scrolling
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16), // Adds some padding
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      const Text(
                        "My",
                        style: TextStyle(
                          color: Color(0xff4A4A4A),
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Segoe UI',
                        ),
                      ),
                      const Text(
                        "Gallery",
                        style: TextStyle(
                          color: Color(0xff4A4A4A),
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Segoe UI',
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Blurred container
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                            32), // Match the container's border radius
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                              sigmaX: 10.0, sigmaY: 10.0), // Apply the blur
                          child: Container(
                            width: 345,
                            decoration: BoxDecoration(
                              color: Colors.white
                                  .withOpacity(0.4), // Semi-transparent white
                              borderRadius: BorderRadius.circular(32),
                            ),
                            child: Column(
                              children: [
                                const SizedBox(height: 38),
                                const Text(
                                  "LOG IN",
                                  style: TextStyle(
                                    color: Color(0xff4A4A4A),
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Segoe UI',
                                  ),
                                ),
                                const SizedBox(height: 38),
                                CustomTextField(
                                  contloller: email,
                                  hintText: "User Name",
                                ),
                                const SizedBox(height: 38),
                                CustomTextField(
                                  contloller: password,
                                  hintText: "Password",
                                ),
                                const SizedBox(height: 38),
                                Button(
                                  text: 'SUBMIT',
                                  buttonColor: const Color(0xff7BB3FF),
                                  onPressed: () {
                                    if (isValidEmail(email.text) &&
                                        password.text.isNotEmpty) {
                                      BlocProvider.of<LoginCubit>(context)
                                          .loginMethod(email, password);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              "please enter a valid data!"),
                                          backgroundColor: Colors.red,
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    }
                                  },
                                ),
                                const SizedBox(height: 41),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
