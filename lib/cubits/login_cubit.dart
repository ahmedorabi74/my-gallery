import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import '../constant/constants.dart';
import 'package:http/http.dart' as http;

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());
  String? baseUrl = Constants.baseUrl; // get url from const class

  Future<void> loginMethod(TextEditingController emailController,
      TextEditingController passwordController) async {
    emit(LoginLoading());
    final url = Uri.parse('$baseUrl/auth/login');
    String email = emailController.text;
    String password = passwordController.text;
    final response = await http.post(url, body: {
      'email': email,
      'password': password,
    });
    try {
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data.containsKey('token')) {
          // sharedPref.setString("token", data["token"]);
          // Constants.userToken = data["token"];
          emit(LoginSuccess());
        } else if (data.containsKey('error_message')) {
          emit(LoginFailure(
              errorMessage: "invaled email or password,please try again"));
        } else {
          // Handle unexpected response structure
          emit(LoginFailure(
              errorMessage: 'Unexpected response from the server'));
        }
      } else {
        // Handle non-200 responses (e.g., network errors, server errors)
        emit(LoginFailure(
            errorMessage: 'An error occurred: ${response.statusCode}'));
      }
    } catch (e) {
      emit(LoginFailure(errorMessage: 'An error occurred,please try again'));
    }
  }
}
