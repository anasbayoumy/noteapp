import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mynoteapp/components/crud.dart';
import 'package:mynoteapp/components/customformfield.dart';
import 'package:mynoteapp/constant/links.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final GlobalKey<FormState> formstate = GlobalKey<FormState>();
  final Crud _crud = Crud();
  bool isloading = false;

  final TextEditingController email = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController password = TextEditingController();

  signup() async {
    setState(() {
      isloading = true;
    });

    if (formstate.currentState!.validate()) {
      var response = await _crud.postRequest(linkSignUp, {
        "username": name.text,
        "email": email.text,
        "password": password.text
      });

      isloading = false;
      setState(() {});

      print("API Response: $response");

      if (response == null) {
        print("No response from the server.");
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          body: Center(
            child: Text(
              "No response from the server. Please check your network connection.",
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          title: 'Network Error',
          btnOkOnPress: () {},
          btnOkText: "Retry",
        ).show();
      } else if (response["status"] == "success") {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          body: Center(
            child: Text(
              "Account created successfully",
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          title: 'SUCCESS',
          btnOkOnPress: () {
            Navigator.of(context).pushReplacementNamed("Login");
          },
          btnOkText: "Login",
        ).show();
      } else {
        print("Error: ${response["message"]}");
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          body: Center(
            child: Text(
              response["message"] ?? "Something went wrong!",
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          title: 'Error',
          btnOkOnPress: () {},
          btnOkText: "Retry",
        ).show();
      }
    } else {
      setState(() {
        isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isloading == true
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: formstate,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: ListView(
                  children: [
                    const SizedBox(height: 20),
                    const Center(
                      child: Text(
                        "SignUp",
                        style: TextStyle(
                            fontSize: 35, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: Image.asset(
                        "images/logo_n.png",
                        width: 200,
                        height: 200,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      hint: 'Enter Your Full Name',
                      mycont: name,
                      valid: (val) {
                        return validfn(val!, 5, 100);
                      },
                    ),
                    const SizedBox(height: 30),
                    CustomTextField(
                      valid: (val) {
                        return validfn(val!, 5, 100);
                      },
                      hint: 'Enter Your Email',
                      mycont: email,
                    ),
                    const SizedBox(height: 30),
                    CustomTextField(
                      valid: (val) {
                        return validfn(val!, 8, 25);
                      },
                      hint: 'Enter Your Password',
                      mycont: password,
                    ),
                    const SizedBox(height: 40),
                    Container(
                      width: 300,
                      color: const Color.fromARGB(255, 235, 216, 47),
                      child: MaterialButton(
                        onPressed:
                            signup, // Execute signup function on button press
                        height: 50,
                        child: const Text("SignUp"),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: "Already have an account? ",
                              style: TextStyle(color: Colors.black),
                            ),
                            TextSpan(
                              text: "Login",
                              style: const TextStyle(
                                color: Color.fromARGB(255, 235, 216, 47),
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.of(context)
                                      .pushReplacementNamed("Login");
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
