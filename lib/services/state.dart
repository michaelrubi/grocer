import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocer/services/models.dart';
import 'package:grocer/shared/styles.dart' show Col;

final groceryDataProvider = 
  FutureProvider<Data?>((ref) => loadData());

final groceryData = ChangeNotifierProvider((ref) {
  return ref.watch(groceryDataProvider).value ?? Data([], []);
});

final addVisible = ChangeNotifierProvider((ref) {
  return IsTrue(value: false);
});

final textControllerProvider =
    Provider.autoDispose<TextEditingController>((ref) {
  return TextEditingController();
});

final storeSelection = ChangeNotifierProvider((ref) {
  return StoreSelection(value: '');
});

final searchVisible = ChangeNotifierProvider((ref) {
  return IsTrue(value: false);
});

final searchControllerProvider =
    Provider.autoDispose<TextEditingController>((ref) {
  return TextEditingController();
});

final colorSelection = ChangeNotifierProvider((ref) {
  return ColorSelection(value: Col.noStore);
});

final locationVisible = ChangeNotifierProvider((ref) {
  return IsTrue(value: false);
});

final swipeState = ChangeNotifierProvider((ref) {
  return SwipeState();
});

final editModeProvider = ChangeNotifierProvider((ref) {
  return IsTrue(value: false);
});