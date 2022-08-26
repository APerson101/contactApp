import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final editingItemsProvider = StateProvider((ref) => false);

class TextFieldWidget extends ConsumerWidget {
  TextFieldWidget(
      {Key? key,
      required this.controller,
      required this.text,
      required this.status})
      : super(key: key);
  final StateProvider<TextEditingController> controller;
  final String text;
  StateProvider<bool> status;

  var showSave = StateProvider((ref) => false);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var screenwidth = MediaQuery.of(context).size.width;
    double boxwidth = screenwidth <= 500
        ? MediaQuery.of(context).size.width
        : screenwidth <= 900
            ? 600
            : 800;

    return SizedBox(
      width: boxwidth - 30,
      child: TextField(
        onChanged: (newText) {
          newText != text && newText.isNotEmpty
              ? {
                  ref.watch(showSave.notifier).state = true,
                  ref.watch(editingItemsProvider.notifier).state = true
                }
              : {
                  ref.watch(showSave.notifier).state = false,
                  ref.watch(editingItemsProvider.notifier).state = false
                };
        },
        controller: ref.watch(controller),
        decoration: InputDecoration(
            suffixIcon: ref.watch(showSave)
                ? TextButton(onPressed: () {}, child: const Text("Save"))
                : IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () {
                      ref.watch(status.notifier).state = false;
                    },
                  ),
            hintText: text,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
      ),
    );
  }
}

final editingFirstNameProviders = StateProvider((ref) {
  return false;
});

final editingLastNameProvider = StateProvider((ref) {
  return false;
});

final editingAgeProvider = StateProvider((ref) {
  return false;
});

final editingtitleProvider = StateProvider((ref) {
  return false;
});

final editingOrganizationNameProvider = StateProvider((ref) {
  return false;
});
final editingPosiitonProvider = StateProvider((ref) {
  return false;
});
final editingNotesProvider = StateProvider((ref) {
  return false;
});
