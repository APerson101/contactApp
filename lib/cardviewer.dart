import 'package:contactapp/database/databasehelper.dart';
import 'package:contactapp/model/contact_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CardView extends ConsumerWidget {
  const CardView({Key? key, required this.cardId}) : super(key: key);
  // final ContactInfo contact;
  final String cardId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var retriever = ref.watch(getCard(cardId));
    return retriever.when(data: (contact) {
      return contact != null
          ? Material(
              child: Column(
                children: [
                  //image, first name, last name, title, organization name, position
                  ElevatedButton(
                      onPressed: () {
                        GoRouter.of(context).push('/', extra: contact);
                      },
                      child: const Text("Edit this card")),
                  Expanded(child: image(contact)),
                  contact.emails != null
                      ? Expanded(child: multipleData('Email', contact.emails!))
                      : Container(),
                  contact.phones != null
                      ? Expanded(
                          child: multiplePhones('Phones', contact.phones!))
                      : Container(),
                  contact.addresses != null
                      ? Expanded(
                          child:
                              multipleString('Addresses', contact.addresses!))
                      : Container(),
                  contact.websites != null
                      ? Expanded(
                          child: multipleString('Websites', contact.addresses!))
                      : Container(),
                  contact.notes != null
                      ? Expanded(child: Text(contact.notes!))
                      : Container()
                ],
              ),
            )
          : const Material(
              child: Center(
                child: Text("No such contact found"),
              ),
            );
    }, loading: () {
      return const Material(
          child: Center(child: CircularProgressIndicator.adaptive()));
    }, error: (obj, str) {
      return Material(
        child: Center(child: Text(str.toString())),
      );
    });
  }

  Widget image(ContactInfo? contact) {
    if (contact != null) {
      NetworkImage? image;
      if (contact.pictureURL != null) {
        image = NetworkImage(contact.pictureURL!);
      }

      return Row(
        children: [
          const Spacer(),
          CircleAvatar(
            backgroundImage: image,
            child: image == null
                ? const Icon(
                    Icons.person,
                    size: 48,
                  )
                : null,
          ),
          const Spacer(),
          SizedBox(
            height: 100,
            width: 300,
            child: Column(
              children: [
                Text(
                    '${contact.title} ${contact.firstName} ${contact.lastName}'),
                Text('${contact.organizationName}'),
                Text('${contact.positionTitle}'),
                Text('${contact.birthday?.toLocal()}'),
              ],
            ),
          ),
          const Spacer(),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget multipleData(String type, List<EmailInfo> items) {
    return Column(
      children: [
        const Divider(),
        Text(type),
        ...items.map((e) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              // leading: const Icon(Icons.email),
              title: Text(e.value, style: const TextStyle(fontSize: 18)),
              subtitle: Text(
                describeEnum(e.type),
                style: const TextStyle(fontSize: 18),
              ),
              trailing: IconButton(
                  onPressed: () {
                    //copy to clipboard
                    Clipboard.setData(ClipboardData(text: e.value));
                  },
                  icon: const Icon(Icons.copy)),
            ),
          );
        }).toList()
      ],
    );
  }
}

Widget multiplePhones(String type, List<PhoneInfo> items) {
  return Column(
    children: [
      const Divider(),
      Text(type),
      ...items.map((e) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: const Icon(Icons.phone),
            title: Text(e.value),
            subtitle: Text(describeEnum(e.type)),
            trailing: IconButton(
                onPressed: () {
                  //copy to clipboard
                  Clipboard.setData(ClipboardData(text: e.value));
                },
                icon: const Icon(Icons.copy)),
          ),
        );
      }).toList()
    ],
  );
}

Widget multipleString(String type, List<String> items) {
  return Column(
    children: [
      const Divider(),
      Text(type),
      ...items.map((e) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Text(e),
            trailing: IconButton(
                onPressed: () {
                  //copy to clipboard
                  Clipboard.setData(ClipboardData(text: e));
                },
                icon: const Icon(Icons.copy)),
          ),
        );
      }).toList()
    ],
  );
}

final getCard =
    FutureProvider.family<ContactInfo?, String>((ref, cardId) async {
  return await ref.watch(databaseProvider).retrieveCardDetails(cardId: cardId);
});
