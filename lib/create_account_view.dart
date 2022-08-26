import 'package:contactapp/database/databasehelper.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:random_string/random_string.dart';

final _signUpEmail = StateProvider<String?>((ref) => null);
final _password = StateProvider<String?>((ref) => null);
final _confirmPassword = StateProvider<String?>((ref) => null);

class CreateAccount extends ConsumerWidget {
  CreateAccount({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        body: Form(
      key: _formKey,
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            validator: (enteredText) {
              if (enteredText != null && enteredText.isNotEmpty) {
                return EmailValidator.validate(enteredText)
                    ? null
                    : 'Enter valid Email address';
              }
              return 'Enter text';
            },
            onChanged: (email) {
              ref.watch(_signUpEmail.notifier).state = email;
            },
            decoration: InputDecoration(
                hintText: 'Email',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15))),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            validator: (enteredText) {
              return null;
            },
            controller: _passwordController,
            onChanged: (password) {
              ref.watch(_password.notifier).state = password;
            },
            obscureText: true,
            decoration: InputDecoration(
                hintText: 'Password',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15))),
          ),
        ),
        FlutterPwValidator(
            controller: _passwordController,
            minLength: 6,
            width: 400,
            height: 150,
            onSuccess: () {},
            onFail: () {}),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            obscureText: true,
            validator: (text) {
              if (text != null && text.isNotEmpty) {
                return text == _passwordController.text
                    ? null
                    : 'Password does not match';
              } else {
                return 'Enter valid text';
              }
            },
            onChanged: (email) {
              _formKey.currentState!.validate();
              // ref.watch(_confirmPassword.notifier).state = email;
            },
            decoration: InputDecoration(
                hintText: 'Confirm Password',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15))),
          ),
        ),
        ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                String id = randomAlphaNumeric(7);
                var user = await ref.watch(databaseProvider).createAuth(
                    id, ref.read(_signUpEmail)!, ref.read(_password)!);
                if (user['status'] == 'success') {
                  var pop = GoRouter.of(context).canPop();
                  if (pop) {
                    GoRouter.of(context)
                      ..pop()
                      ..push('/home');
                  } else {
                    GoRouter.of(context).replace('/home');
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: ListTile(
                          tileColor: Colors.red,
                          leading: const Icon(Icons.cancel),
                          title: Text(user['reason'],
                              style: const TextStyle(color: Colors.white)))));
                }
              }
            },
            child: const Text("Sign up"))
      ]),
    ));
  }
}
