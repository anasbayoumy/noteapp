import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mynoteapp/components/crud.dart';
import 'package:mynoteapp/components/customformfield.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:mynoteapp/constant/links.dart';
import 'package:mynoteapp/main.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> formstate = GlobalKey();
  Crud _crud = Crud();
  bool isloading = false;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  login() async {
    isloading = true;
    setState(() {});
    if (formstate.currentState!.validate()) {
      var response = await _crud.postRequest(
          linkLogin, {"email": email.text, "password": password.text});
      isloading = false;
      setState(() {});
      if (response != null && response["status"] == "success") {
        sharedPreferences.setString("id", response['data']['id'].toString());
        sharedPreferences.setString("username", response['data']['username']);
        sharedPreferences.setString("email", response['data']['email']);

        Navigator.of(context).pushReplacementNamed("Home");
      } else {
        AwesomeDialog(
          context: context,
          animType: AnimType.scale,
          dialogType: DialogType.error,
          body: const Center(
            child: Text(
              "The password or email is wrong!",
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          title: 'Error',
          btnCancelOnPress: () {},
          btnCancelColor: Colors.red,
          btnOkColor: const Color.fromARGB(255, 235, 216, 47),
          btnOkOnPress: () {},
          btnOkText: "Retry",
        ).show();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formstate,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: ListView(
            children: [
              const SizedBox(height: 20),
              const Center(
                  child: Text(
                "Login",
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
              )),
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
                  onPressed: () async {
                    await login();
                  },
                  height: 50,
                  child: isloading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text("Login"),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: "Create an account? ",
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: "SignUp",
                        style: const TextStyle(
                          color: Color.fromARGB(255, 235, 216, 47),
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context).pushNamed("Signup");
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
