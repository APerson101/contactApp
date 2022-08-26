import 'package:contactapp/database/databasehelper.dart';
import 'package:contactapp/model/contact_info.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final emailField = StateProvider<String?>((ref) => "");
final passwordField = StateProvider<String?>((ref) => "");

class LoginForm extends ConsumerWidget {
  LoginForm({Key? key, this.contact}) : super(key: key);
  final ContactInfo? contact;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              validator: (text) {
                if (text != null && text.isNotEmpty) {
                  if (EmailValidator.validate(text)) {
                    return null;
                  } else {
                    return 'Enter valid email';
                  }
                }
                return 'Please Enter text';
              },
              onChanged: (email) {
                ref.watch(emailField.notifier).state = email;
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
              validator: (text) {
                if (text != null && text.isNotEmpty) {
                  if (text.length >= 6) {
                    return null;
                  }
                  return "Enter at least 6 characters";
                } else {
                  return "Enter valid text";
                }
              },
              onChanged: (password) {
                ref.watch(passwordField.notifier).state = password;
              },
              obscureText: true,
              decoration: InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15))),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              bool state = _formKey.currentState!.validate();
              if (state) {
                var user = await ref.watch(databaseProvider).login(
                    email: ref.watch(emailField)!,
                    password: ref.watch(passwordField)!);
                if (user['status'] == 'success') {
                  GoRouter.of(context).replace('/home', extra: contact);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: ListTile(
                    tileColor: Colors.red,
                    leading: const Icon(Icons.cancel),
                    title: Text(user['reason'],
                        style: const TextStyle(color: Colors.white)),
                  )));
                }
              }
            },
            style: ElevatedButton.styleFrom(fixedSize: const Size(200, 50)),
            child: const Text("Login"),
          ),
          const Divider(),
          const SizedBox(height: 30),
          ElevatedButton(
              style: ElevatedButton.styleFrom(fixedSize: const Size(200, 50)),
              onPressed: () {
                GoRouter.of(context).push('/signup');
              },
              child: const Text("sign up"))
        ],
      ),
    );
  }
}
