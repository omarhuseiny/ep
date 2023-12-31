import 'package:flutter/material.dart';
import 'package:new_flutter_project/screens/auth/sign_up_screen.dart';
import 'package:new_flutter_project/screens/home_screen.dart';

import '../../utilites/colors.dart';
import '../../utilites/strings.dart';
import '../../widgets/curvy_container.dart';
import '../../widgets/custom_btn.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/rowspan.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:new_flutter_project/main.dart';

// ignore: must_be_immutable
class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});
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
                        text2: " IN",
                        color1: AppColor.white,
                        color2: AppColor.white,
                        decoration: TextDecoration.none,
                      ),
                      const SizedBox(
                        height: 20,
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
                      customTextFormField(
                        errorBorderColor: AppColor.red,
                        enabledBorderColor: AppColor.gery,
                        focusBorderColor: AppColor.mainColor,
                        controller: usernameController,
                        fillColor: AppColor.gery,
                        iconData: Icons.person,
                        hint: "Username",
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
                        visibleText: true,
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
                        text: "Sign In",
                        color: Colors.brown,
                        function: () {
                          if(usernameController.text.isEmpty || !RegExp(RegularExp.validationName).hasMatch(usernameController.text))
                          {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Error'),
                                  content: const Text("Invalid username!"),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Close'),
                                    ),
                                  ],
                                );
                              },
                            );
                            return;
                          }
                          if(passwordController.text.isEmpty)
                          {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Error'),
                                  content: const Text("Password field empty!"),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Close'),
                                    ),
                                  ],
                                );
                              },
                            );
                            return;
                          }
                          signinPostRequest().then((statusCode)
                          {
                            print('signin Status code: $statusCode');
                            var message = "";
                            if(statusCode == 200)
                            {
                              message = "Successful sign in!";
                            }
                            else if(statusCode == 403)
                            {
                              message = "Error: Incorrect password!";
                            }
                            else if(statusCode == 404)
                            {
                              message = "Error: User not found!";
                            }
                            else
                            {
                              message = "Error signing in!";
                            }
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Sign in Response'),
                                  content: Text(message),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        if(statusCode == 200)
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
          text1: "Don't have an Account?",
          text2: "Sign Up",
          function: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignUpScreen()),
            );
          },
        ),
      ),
    );
  }

  Future<int> signinPostRequest() async {
    final url = Uri.parse('http://kirollos.rocks:6969/user/signin/');

    final headers = {
      'Authorization': 'Bearer 69420',
      'Content-Type': 'application/json', // optional header for specifying the request payload format
    };

    final payload = {
      'username': usernameController.text,
      'password': passwordController.text
    };

    final response = await http.post(
      url,
      headers: headers,
      body: json.encode(payload),
    );

    print(response.body);

    if(response.statusCode == 200)
    {
      MyApp.username = json.decode(response.body)['username'];
      MyApp.email = json.decode(response.body)['email'];
    }

    return response.statusCode;
  }
}
