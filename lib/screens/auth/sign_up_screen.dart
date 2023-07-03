import 'package:flutter/material.dart';
import 'package:new_flutter_project/screens/auth/sign_in_screen.dart';
import 'package:new_flutter_project/screens/home_screen.dart';

import '../../utilites/colors.dart';
import '../../utilites/strings.dart';
import '../../widgets/curvy_container.dart';
import '../../widgets/custom_btn.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/rowspan.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

// ignore: must_be_immutable
class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.mainColor,
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          clipBehavior: Clip.none,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                // TODO: MediaQuery Information !
                height: MediaQuery.of(context).size.height / 1.3,
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      const Spacer(),
                      rowSpanText(
                        text1: "SIGN",
                        text2: " UP",
                        color1: AppColor.white,
                        color2: AppColor.white,
                        decoration: TextDecoration.none,
                      ),
                      // customTextFormField(
                      //   errorBorderColor: AppColor.red,
                      //   enabledBorderColor: AppColor.gery,
                      //   focusBorderColor: AppColor.mainColor,
                      //   controller: usernameController,
                      //   fillColor: AppColor.gery,
                      //   iconData: Icons.person,
                      //   hint: "First Name",
                      //   validate: (value) {
                      //     if (value.toString().length <= 2 ||
                      //         !RegExp(RegularExp.validationName)
                      //             .hasMatch(value.toString())) {
                      //       return "Please Enter a Valid Name";
                      //     }
                      //     return null;
                      //   },
                      // ),
                      const SizedBox(height: 20),
                      customTextFormField(
                        errorBorderColor: AppColor.red,
                        enabledBorderColor: AppColor.gery,
                        focusBorderColor: AppColor.mainColor,
                        controller: usernameController,
                        fillColor: AppColor.gery,
                        iconData: Icons.person,
                        hint: "User Name",
                        validate: (value) {
                          if (value.toString().length <= 2 ||
                              !RegExp(RegularExp.validationName)
                                  .hasMatch(value.toString())) {
                            return "Please Enter a Valid Name";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      customTextFormField(
                        errorBorderColor: AppColor.red,
                        enabledBorderColor: AppColor.gery,
                        focusBorderColor: AppColor.mainColor,
                        controller: emailController,
                        fillColor: AppColor.gery,
                        iconData: Icons.email,
                        hint: "Email",
                        validate: (value) {
                          //   if (!RegExp(RegularExp.validationEmail)
                          if (value.toString().length <= 2 ||
                              !RegExp(RegularExp.validationName)
                                  .hasMatch(value.toString())) {
                            return "Please Enter a Valid Name";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      customTextFormField(
                        errorBorderColor: AppColor.red,
                        enabledBorderColor: AppColor.gery,
                        focusBorderColor: AppColor.mainColor,
                        controller: passwordController,
                        fillColor: AppColor.gery,
                        iconData: Icons.lock,
                        hint: "Password",
                        validate: (value) {
                          if (value.toString().length < 6) {
                            return "Password Should Be Greate Than 6 Characters";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // customTextFormField(
                      //   errorBorderColor: AppColor.red,
                      //   enabledBorderColor: AppColor.gery,
                      //   focusBorderColor: AppColor.mainColor,
                      //   controller: emailController,
                      //   fillColor: AppColor.gery,
                      //   iconData: Icons.lock,
                      //   hint: "Confirm Password",
                      //   validate: (value) {
                      //     if (value.toString().length < 6) {
                      //       return "Password Should Be Greate Than 6 Characters";
                      //     }
                      //     return null;
                      //   },
                      // ),
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      customBtn(
                        width: double.infinity,
                        text: "Sign Up",
                        color: Colors.brown,
                        function: () {
                          signupPostRequest().then((statusCode)
                          {
                            print('signup Status code: $statusCode');
                            var message = "";
                            if(statusCode == 201)
                            {
                              message = "Successful sign up!";
                            }
                            else if(statusCode == 403)
                            {
                              message = "User already exists!";
                            }
                            else
                            {
                              message = "Error creating an account!";
                            }
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Response Status'),
                                  content: Text(message),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        if(statusCode == 201)
                                        {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => const HomeScreen()),
                                            );
                                        }
                                      },
                                      child: const Text('Close'),
                                    ),
                                  ],
                                );
                              },
                            );
                          });
                          //Navigator.push(
                          //  context,
                          //  MaterialPageRoute(builder: (context) => const HomeScreen()),
                          //);
                        },
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: curvyContainer(
          color: Colors.brown,
          text1: "Already have an Account?",
          text2: "Log in",
          function: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignInScreen()),
            );
          },
        ),
      ),
    );
  }

  void __makePostRequest() async {
    final url = Uri.parse('http://kirollos.rocks:6969/user/signup/');

    // Create a map of any request payload or parameters
     final headers = {
      'Authorization': 'Bearer 69420',
      'Content-Type': 'application/json'
    };
    final payload = {
      'username': usernameController.value,
      'password': passwordController.value,
      'first_name': '',
      'last_name': '',
      'email': emailController.value
    };

    final response = await http.post(
      url,
      headers: headers,
      body: json.encode(payload)
    );

    if (response.statusCode == 201) {
      // Successful POST request
      print('Request successful');
      print(response.body);
    } else {
      // Handle errors or unsuccessful requests
      print('Request failed with status: ${response.statusCode}');
    }
  }

  Future<int> signupPostRequest() async {
    final url = Uri.parse('http://kirollos.rocks:6969/user/signup/');

    final headers = {
      'Authorization': 'Bearer 69420',
      'Content-Type': 'application/json', // optional header for specifying the request payload format
    };

    final payload = {
      'username': usernameController.text,
      'password': passwordController.text,
      'first_name': '',
      'last_name': '',
      'email': emailController.text
    };

    final response = await http.post(
      url,
      headers: headers,
      body: json.encode(payload),
    );

    print(response.body);

    return response.statusCode;
  }
}
