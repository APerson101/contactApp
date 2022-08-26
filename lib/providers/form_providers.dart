import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TextEditingControllers extends StateNotifier<List<Details>> {
  TextEditingControllers() : super([]);

  void addController() {
    state = [
      ...state,
      Details(controller: TextEditingController(), type: "main")
    ];
  }

  void changeText(int index, String text) {
    state[index].type = text;
    state = [...state];
  }

  void removeController(int index) {
    state.removeAt(index);
    state = [...state];
  }
}

class EmailEditingControllers extends StateNotifier<List<Details>> {
  EmailEditingControllers() : super([]);

  void addEmailController() {
    state = [
      ...state,
      Details(controller: TextEditingController(), type: "home")
    ];
  }

  void removeEmailController(int index) {
    state.removeAt(index);
    state = [...state];
  }

  void changeText(int index, String text) {
    state[index].type = text;
    state = [...state];
  }
}

class WebsiteEditingControllers
    extends StateNotifier<List<TextEditingController>> {
  WebsiteEditingControllers() : super([]);

  void addWebsiteController() {
    state = [...state, TextEditingController()];
  }

  void removeWebsite(int index) {
    state.removeAt(index);
    state = [...state];
  }
}

class AddressEditingControllers
    extends StateNotifier<List<TextEditingController>> {
  AddressEditingControllers() : super([]);

  void addAddressController() {
    state = [...state, TextEditingController()];
  }

  void removeAddress(int index) {
    state.removeAt(index);
    state = [...state];
  }
}

final addressListProvider = StateNotifierProvider.autoDispose<
    AddressEditingControllers,
    List<TextEditingController>>((ref) => AddressEditingControllers());

final controllerListProvider =
    StateNotifierProvider.autoDispose<TextEditingControllers, List<Details>>(
        (ref) => TextEditingControllers());

final emailListProvider =
    StateNotifierProvider.autoDispose<EmailEditingControllers, List<Details>>(
        (ref) => EmailEditingControllers());
final websitecontrollerListProvider = StateNotifierProvider.autoDispose<
    WebsiteEditingControllers,
    List<TextEditingController>>((ref) => WebsiteEditingControllers());

class Details {
  TextEditingController? controller;
  String? type;
  Details({
    this.controller,
    this.type,
  });

  Details copyWith({
    TextEditingController? controller,
    String? type,
  }) {
    return Details(
      controller: controller ?? this.controller,
      type: type ?? this.type,
    );
  }
}
