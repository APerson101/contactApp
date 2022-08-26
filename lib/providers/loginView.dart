import 'package:contactapp/homepage.dart';
import 'package:contactapp/model/contact_info.dart';
import 'package:contactapp/providers/loginform.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentPage = StateProvider((ref) => 0);

class LoginView extends ConsumerWidget {
  const LoginView({Key? key, this.contactToEdit}) : super(key: key);
  final ContactInfo? contactToEdit;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        width: MediaQuery.of(context).size.width,
        child: LoginForm(contact: contactToEdit));
    return Column(
      children: [
        CupertinoSlidingSegmentedControl<int>(
          padding: const EdgeInsets.all(8),
          children: const {0: Text("Login"), 1: Text("Sign up")},
          onValueChanged: (selected) {
            ref.watch(currentPage.notifier).state = selected!;
          },
          groupValue: ref.watch(currentPage),
        ),
        ref.watch(currentPage) == 0
            ? SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width,
                child: LoginForm())
            : SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width,
                child: const LandingPage())
      ],
    );
  }
}
