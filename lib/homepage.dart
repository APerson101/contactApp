import 'package:contactapp/database/databasehelper.dart';
import 'package:contactapp/model/contact_info.dart';
import 'package:contactapp/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'providers/form_providers.dart';

final passwordViewer = StateProvider((ref) => true);
final selectedImage = StateProvider<XFile?>((ref) => null);
final selectedDate = StateProvider<DateTime?>((ref) => null);
final firstNameProvider =
    StateProvider<TextEditingController>((ref) => TextEditingController());
final lastNameProvider =
    StateProvider<TextEditingController>((ref) => TextEditingController());
final organisationNameProvider =
    StateProvider<TextEditingController>((ref) => TextEditingController());
final organisationPositionProvider =
    StateProvider<TextEditingController>((ref) => TextEditingController());
final titleProvider =
    StateProvider<TextEditingController>((ref) => TextEditingController());
final cardInfoProvider =
    StateProvider<TextEditingController>((ref) => TextEditingController());
final notesProvider =
    StateProvider<TextEditingController>((ref) => TextEditingController());
final emailProvider = StateProvider<String?>((ref) => null);
final passwordProvider = StateProvider<String?>((ref) => null);
final profilePicProvider = StateProvider<String?>((ref) => null);
final _emailControllerProvider = StateProvider<String>((ref) {
  return FirebaseAuth.instance.currentUser!.email!;
});
final loadUserDetails =
    FutureProvider.family<ContactInfo, String>((ref, userID) async {
  print(userID);
  return await ref.watch(databaseProvider).loadUser(userID);
});

class LandingPage extends ConsumerWidget {
  const LandingPage({Key? key, this.contact}) : super(key: key);
  final ContactInfo? contact;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var screenwidth = MediaQuery.of(context).size.width;
    double boxwidth = screenwidth <= 500
        ? MediaQuery.of(context).size.width
        : screenwidth <= 900
            ? 600
            : 800;
    return ref
        .watch(loadUserDetails(FirebaseAuth.instance.currentUser!.uid))
        .when(
            error: (st, err) {
              print(err);
              return const Material(
                child: Center(child: Text("ERROR Loading")),
              );
            },
            loading: () => const Material(
                child: Center(child: CircularProgressIndicator.adaptive())),
            data: (contact) {
              return Scaffold(
                  appBar: AppBar(
                      title: const Text("Sign up"),
                      centerTitle: true,
                      actions: [
                        ref.watch(editingItemsProvider)
                            ? IconButton(
                                icon: const Icon(Icons.save),
                                onPressed: () {},
                              )
                            : Container()
                      ]),
                  body: SingleChildScrollView(
                      child: Material(
                    child: Column(children: [
                      Row(children: [
                        const Spacer(
                          flex: 3,
                        ),
                        Expanded(
                          flex: 1,
                          child: ListTile(
                            title: Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                child: const Text(
                                  'Contact Creator',
                                  style: TextStyle(),
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ),
                        )
                      ]),

                      SizedBox(
                        width: boxwidth,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: const [
                              Expanded(
                                child: Divider(),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Authentication'),
                              ),
                              Expanded(
                                child: Divider(),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: boxwidth - 30,
                        child: Text(ref.watch(_emailControllerProvider)),
                      ),
                      const SizedBox(height: 20),
                      // SizedBox(
                      //   width: boxwidth - 30,
                      //   child: TextField(
                      //     onChanged: (password) =>
                      //         ref.watch(passwordProvider.notifier).state = password,
                      //     obscureText: ref.watch(passwordViewer),
                      //     decoration: InputDecoration(
                      //         hintText: 'change password',
                      //         suffixIcon: IconButton(
                      //           icon: const Icon(Icons.remove_red_eye),
                      //           onPressed: () {
                      //             ref.watch(passwordViewer)
                      //                 ? ref.watch(passwordViewer.notifier).state = false
                      //                 : ref.watch(passwordViewer.notifier).state = true;
                      //           },
                      //         ),
                      //         border: OutlineInputBorder(
                      //             borderRadius: BorderRadius.circular(12))),
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(children: [
                          const Spacer(),
                          CircleAvatar(
                              radius: screenwidth <= 500 ? 40 : 70,
                              backgroundImage: ref.watch(profilePicProvider) !=
                                      null
                                  ? NetworkImage(ref.watch(profilePicProvider)!)
                                  : ref.watch(selectedImage) != null
                                      ? NetworkImage(
                                          (ref.watch(selectedImage)!.path),
                                        )
                                      : null,
                              child: ref.watch(selectedImage) == null
                                  ? Icon(
                                      Icons.person,
                                      size: screenwidth <= 500 ? 48 : 96,
                                    )
                                  : null),
                          const Spacer(),
                          SizedBox(
                            width: screenwidth <= 500 ? 100 : 120,
                            height: screenwidth <= 500 ? 30 : 50,
                            child: FittedBox(
                                child: ElevatedButton(
                                    onPressed: () async {
                                      final ImagePicker picker = ImagePicker();
                                      // Pick an image
                                      final XFile? image =
                                          await picker.pickImage(
                                              source: ImageSource.gallery);
                                      ref.watch(selectedImage.notifier).state =
                                          image;
                                    },
                                    child: Text(ref.watch(selectedImage) == null
                                        ? "Select"
                                        : "Change"))),
                          ),
                          const Spacer(),
                        ]),
                      ),
                      SizedBox(
                        width: boxwidth,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: const [
                              Expanded(
                                child: Divider(),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Contact'),
                              ),
                              Expanded(
                                child: Divider(),
                              )
                            ],
                          ),
                        ),
                      ),

                      ref.watch(editingtitleProvider)
                          ? TextFieldWidget(
                              controller: titleProvider,
                              text: 'title',
                              status: editingtitleProvider)
                          : SizedBox(
                              width: boxwidth,
                              child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: ListTile(
                                      title: const Text("Title"),
                                      trailing: TextButton(
                                          onPressed: () => ref
                                              .watch(
                                                  editingtitleProvider.notifier)
                                              .state = true,
                                          child: const Text('edit')))),
                            ),
                      const SizedBox(
                        height: 20,
                      ),
                      ref.watch(editingFirstNameProviders)
                          ? TextFieldWidget(
                              controller: firstNameProvider,
                              text: 'First Name',
                              status: editingFirstNameProviders)
                          : SizedBox(
                              width: boxwidth,
                              child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: ListTile(
                                      title: const Text("First name"),
                                      trailing: TextButton(
                                          onPressed: () => ref
                                              .watch(editingFirstNameProviders
                                                  .notifier)
                                              .state = true,
                                          child: const Text('edit')))),
                            ),

                      const SizedBox(
                        height: 20,
                      ),
                      ref.watch(editingLastNameProvider)
                          ? TextFieldWidget(
                              controller: lastNameProvider,
                              text: 'Last Name',
                              status: editingLastNameProvider,
                            )
                          : SizedBox(
                              width: boxwidth,
                              child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: ListTile(
                                      title: const Text("Last name"),
                                      trailing: TextButton(
                                          onPressed: () => ref
                                              .watch(editingLastNameProvider
                                                  .notifier)
                                              .state = true,
                                          child: const Text('edit')))),
                            ),
                      Row(
                        children: [
                          ElevatedButton(
                              onPressed: () async {
                                var selectedDate_ = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1880),
                                    lastDate: DateTime.now());
                                ref.watch(selectedDate.notifier).state =
                                    selectedDate_;
                              },
                              child: Text(ref.watch(selectedDate) == null
                                  ? "Select date of birth"
                                  : ref
                                      .watch(selectedDate)
                                      .toString()
                                      .split(" ")[0])),
                        ],
                      ),
                      SizedBox(
                        width: boxwidth,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: const [
                              Expanded(
                                child: Divider(),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Occupation'),
                              ),
                              Expanded(
                                child: Divider(),
                              )
                            ],
                          ),
                        ),
                      ),
                      ref.watch(editingOrganizationNameProvider)
                          ? TextFieldWidget(
                              controller: organisationNameProvider,
                              status: editingOrganizationNameProvider,
                              text: 'Organisation Name')
                          : SizedBox(
                              width: boxwidth,
                              child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: ListTile(
                                      title: const Text("Organization Name"),
                                      trailing: TextButton(
                                          onPressed: () => ref
                                              .watch(
                                                  editingOrganizationNameProvider
                                                      .notifier)
                                              .state = true,
                                          child: const Text('edit')))),
                            ),

                      const SizedBox(
                        height: 20,
                      ),
                      ref.watch(editingPosiitonProvider)
                          ? TextFieldWidget(
                              controller: organisationPositionProvider,
                              status: editingPosiitonProvider,
                              text: 'Position title')
                          : SizedBox(
                              width: boxwidth,
                              child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: ListTile(
                                      title: const Text("Position title"),
                                      trailing: TextButton(
                                          onPressed: () => ref
                                              .watch(editingPosiitonProvider
                                                  .notifier)
                                              .state = true,
                                          child: const Text('edit')))),
                            ),

                      const SizedBox(
                        height: 20,
                      ),
                      TextButton(
                          onPressed: () {
                            ref
                                .read(controllerListProvider.notifier)
                                .addController();
                          },
                          child: const Text("Add phone")),
                      ...List.generate(ref.watch(controllerListProvider).length,
                          (index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              DropdownButton(
                                  hint: const Text("Select type"),
                                  borderRadius: BorderRadius.circular(10),
                                  underline: DecoratedBox(
                                      decoration: BoxDecoration(
                                          border: Border.all(),
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  value: phoneTypes.values.firstWhere(
                                      (element) =>
                                          describeEnum(element) ==
                                          ref
                                              .watch(
                                                  controllerListProvider)[index]
                                              .type, orElse: () {
                                    return phoneTypes.main;
                                  }),
                                  items: phoneTypes.values
                                      .map((e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(describeEnum(e))))
                                      .toList(),
                                  onChanged: (phoneTypes? selectedItem) {
                                    ref
                                        .watch(controllerListProvider.notifier)
                                        .changeText(
                                            index, describeEnum(selectedItem!));
                                  }),
                              const SizedBox(
                                width: 20,
                              ),
                              SizedBox(
                                width: boxwidth - 100,
                                child: TextField(
                                  controller: ref
                                      .watch(controllerListProvider)[index]
                                      .controller,
                                  onChanged: (phone) {
                                    // ???
                                  },
                                  decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                          onPressed: () {
                                            ref
                                                .watch(controllerListProvider
                                                    .notifier)
                                                .removeController(index);
                                          },
                                          icon: const Icon(Icons.cancel)),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      TextButton(
                          onPressed: () {
                            ref
                                .read(emailListProvider.notifier)
                                .addEmailController();
                          },
                          child: const Text("Add email")),
                      ...List.generate(ref.watch(emailListProvider).length,
                          (index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                DropdownButton(
                                    hint: const Text("Select type"),
                                    borderRadius: BorderRadius.circular(10),
                                    underline: DecoratedBox(
                                        decoration: BoxDecoration(
                                            border: Border.all(),
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    value: emailTypes.values.firstWhere(
                                        (element) =>
                                            describeEnum(element) ==
                                            ref
                                                .watch(emailListProvider)[index]
                                                .type, orElse: () {
                                      return emailTypes.home;
                                    }),
                                    items: emailTypes.values
                                        .map((e) => DropdownMenuItem(
                                            value: e,
                                            child: Text(describeEnum(e))))
                                        .toList(),
                                    onChanged: (emailTypes? selectedItem) {
                                      ref
                                          .watch(emailListProvider.notifier)
                                          .changeText(index,
                                              describeEnum(selectedItem!));
                                    }),
                                const SizedBox(
                                  width: 20,
                                ),
                                SizedBox(
                                  width: boxwidth - 100,
                                  child: TextField(
                                    controller: ref
                                        .watch(emailListProvider)[index]
                                        .controller,
                                    onChanged: (phone) {},
                                    decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                            onPressed: () {
                                              ref
                                                  .watch(emailListProvider
                                                      .notifier)
                                                  .removeEmailController(index);
                                            },
                                            icon: const Icon(Icons.cancel)),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                  ),
                                )
                              ]),
                        );
                      }),
                      TextButton(
                          onPressed: () {
                            ref
                                .read(websitecontrollerListProvider.notifier)
                                .addWebsiteController();
                          },
                          child: const Text("Add website")),
                      ...List.generate(
                          ref.watch(websitecontrollerListProvider).length,
                          (index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: boxwidth - 30,
                            child: TextField(
                              controller: ref
                                  .watch(websitecontrollerListProvider)[index],
                              onChanged: (phone) {},
                              decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        ref
                                            .watch(websitecontrollerListProvider
                                                .notifier)
                                            .removeWebsite(index);
                                      },
                                      icon: const Icon(Icons.cancel)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10))),
                            ),
                          ),
                        );
                      }),
                      TextButton(
                          onPressed: () {
                            ref
                                .read(addressListProvider.notifier)
                                .addAddressController();
                          },
                          child: const Text("Add address")),
                      ...List.generate(ref.watch(addressListProvider).length,
                          (index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: boxwidth - 30,
                            child: TextField(
                              controller: ref.watch(addressListProvider)[index],
                              onChanged: (phone) {},
                              decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        ref
                                            .watch(addressListProvider.notifier)
                                            .removeAddress(index);
                                      },
                                      icon: const Icon(Icons.cancel)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10))),
                            ),
                          ),
                        );
                      }),
                      ref.watch(editingNotesProvider)
                          ? TextFieldWidget(
                              status: editingNotesProvider,
                              controller: notesProvider,
                              text: 'Notes')
                          : SizedBox(
                              width: boxwidth,
                              child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: ListTile(
                                      title: const Text("Notes"),
                                      trailing: TextButton(
                                          onPressed: () => ref
                                              .watch(
                                                  editingNotesProvider.notifier)
                                              .state = true,
                                          child: const Text('edit')))),
                            ),

                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                          width: screenwidth <= 500 ? 125 : 200,
                          child: FittedBox(
                              child: ElevatedButton(
                            onPressed: () async {
                              String? url;
                              if (ref.watch(selectedImage) != null) {
                                url = await ref
                                    .watch(databaseProvider)
                                    .saveProfile(
                                        contact.id!,
                                        await ref
                                            .watch(selectedImage)!
                                            .readAsBytes(),
                                        ref.watch(selectedImage)!.name,
                                        ref
                                            .watch(selectedImage)!
                                            .name
                                            .split('.')[1]);
                              }

                              List<PhoneInfo>? phones;
                              List<EmailInfo>? emails;
                              List<String>? addresses;
                              List<String>? websites;
                              if (ref.read(controllerListProvider).isNotEmpty) {
                                phones = ref
                                    .read(controllerListProvider)
                                    .map((e) => PhoneInfo(
                                        type: phoneTypes.values.firstWhere(
                                            (element) =>
                                                describeEnum(element) ==
                                                e.type),
                                        value: e.controller!.text))
                                    .toList();
                              }

                              if (ref.read(emailListProvider).isNotEmpty) {
                                emails = ref
                                    .read(emailListProvider)
                                    .map((e) => EmailInfo(
                                        type: emailTypes.values.firstWhere(
                                            (element) =>
                                                describeEnum(element) ==
                                                e.type),
                                        value: e.controller!.text))
                                    .toList();
                              }

                              if (ref.read(addressListProvider).isNotEmpty) {
                                addresses = [];
                                for (var each
                                    in ref.read(addressListProvider)) {
                                  addresses.add(each.value.text);
                                }
                              }

                              if (ref
                                  .read(websitecontrollerListProvider)
                                  .isNotEmpty) {
                                websites = [];
                                for (var each in ref
                                    .read(websitecontrollerListProvider)) {
                                  websites.add(each.value.text);
                                }
                              }
                              final newContact = ContactInfo(
                                  email:
                                      FirebaseAuth.instance.currentUser!.email!,
                                  birthday: ref.read(selectedDate),
                                  organizationName:
                                      ref.read(organisationNameProvider).text,
                                  title: ref.read(titleProvider).text,
                                  positionTitle: ref
                                      .read(organisationPositionProvider)
                                      .text,
                                  addresses: addresses,
                                  websites: websites,
                                  firstName: ref
                                          .read(firstNameProvider)
                                          .text
                                          .isNotEmpty
                                      ? ref.read(firstNameProvider).text
                                      : '',
                                  lastName:
                                      ref.read(lastNameProvider).text.isNotEmpty
                                          ? ref.read(lastNameProvider).text
                                          : '',
                                  phones: phones,
                                  picType: ref
                                      .watch(selectedImage)!
                                      .name
                                      .split('.')[1],
                                  notes: ref.read(notesProvider).text,
                                  emails: emails);
                              var id = FirebaseAuth.instance.currentUser!.uid;
                              var contacter = await ref
                                  .watch(databaseProvider)
                                  .saveContact(
                                      newContact, contact.id!, url, id);
                              ref.watch(activeContact.notifier).state = contact;
                            },
                            child: const Text('Update Card'),
                          ))),
                      const SizedBox(
                        height: 75,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            var db = ref.read(databaseProvider);
                            db.downloadVCard(
                                db.createVCard(ref.watch(activeContact)!));
                          },
                          child: const Text("Download vcf"))
                    ]),
                  )));
            });
  }

  setValues(ContactInfo? contact, WidgetRef ref) {
    if (contact != null) {
      ref.watch(notesProvider.notifier).state.text = contact.notes ?? '';
      ref.watch(firstNameProvider.notifier).state.text = contact.firstName;
      ref.watch(lastNameProvider.notifier).state.text = contact.lastName;
      ref.watch(organisationNameProvider.notifier).state.text =
          contact.organizationName ?? "";
      ref.watch(titleProvider.notifier).state.text = contact.title ?? '';
      ref.watch(organisationPositionProvider.notifier).state.text =
          contact.positionTitle ?? '';
      // ref.watch(selectedDate.notifier).state = contact.birthday;
      ref.watch(profilePicProvider.notifier).state = contact.pictureURL;
      if (contact.phones != null) {
        ref.watch(controllerListProvider.notifier).state =
            List.generate(contact.phones!.length, (index) {
          return Details(
              controller:
                  TextEditingController(text: contact.phones![index].value),
              type: describeEnum(contact.phones![index].type));
        });
      }
      if (contact.emails != null) {
        ref.watch(emailListProvider.notifier).state =
            List.generate(contact.emails!.length, (index) {
          return Details(
              controller:
                  TextEditingController(text: contact.emails![index].value),
              type: describeEnum(contact.emails![index].type));
        });
      }
      if (contact.addresses != null) {
        ref.watch(addressListProvider.notifier).state =
            List.generate(contact.addresses!.length, (index) {
          return TextEditingController(text: contact.addresses![index]);
        });
      }
      if (contact.websites != null) {
        ref.watch(websitecontrollerListProvider.notifier).state =
            List.generate(contact.websites!.length, (index) {
          return TextEditingController(text: contact.websites![index]);
        });
      }
    }
  }
}

enum phoneTypes { main, home, work, cell, fax, other }

enum emailTypes { work, home, other }
