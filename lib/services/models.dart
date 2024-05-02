import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocer/shared/styles.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'models.g.dart';

late Box groceryBox;
late Box groceryStoreBox;

class Data extends ChangeNotifier {
  List<GroceryStore> stores;
  List<Grocery> groceries;
  List<StoreSchema> value;

  factory Data(List<GroceryStore> stores, List<Grocery> groceries) {
    final storeMap = <String, StoreSchema>{};
    final schema = stores.map((store) => store.toSchema()).toList();

    for (final store in schema) {
      storeMap[store.name] = store..groceries = [];
    }
    for (final grocery in groceries) {
      storeMap[grocery.store]?.groceries?.add(grocery);
    }
    return Data._internal(stores, groceries, storeMap.values.toList());
  }

  Data._internal(this.stores, this.groceries, this.value);

  StoreSchema toSchema(GroceryStore oldStore) {
    return StoreSchema(name: oldStore.name, color: oldStore.color);
  }

  List<GroceryStore> toStores(List<StoreSchema> schemas) {
    return schemas
        .map((schema) => GroceryStore(name: schema.name, color: schema.color))
        .toList();
  }

  void addItem(String itemName, String storeName, {bool? isPurchased}) {
    if (value.any((store) => store.name == storeName)) {
      final item = Grocery(
          name: itemName, store: storeName, purchased: isPurchased ?? false);
      final store = value.firstWhere((store) => store.name == storeName);
      store.groceries?.add(item);
      groceryBox.put(item.name, item);
      notifyListeners();
    }
  }

  void togglePurchased(Grocery item) {
    StoreSchema store = value.firstWhere((store) => store.name == item.store);
    item.purchased = !item.purchased;
    int index = store.groceries!.indexOf(item);

    if (index == -1) {
      addItem(item.name, item.store, isPurchased: item.purchased);
    } else {
      store.groceries![index] = item;
      groceryBox.put(item.key, item);
      notifyListeners();
    }
  }

  void deleteItem(Grocery item) {
    StoreSchema store = value.firstWhere((store) => store.name == item.store);
    store.groceries!.remove(item);
    groceryBox.delete(item.key);
    notifyListeners();
  }

  GroceryStore getStore(String name) {
    return getSchema(name).toStore();
  }

  StoreSchema getSchema(String name) {
    final schema = value.firstWhere((store) => store.name == name);
    notifyListeners();
    return schema;
  }

  List<String> getStoreNames() {
    return value.map((store) => store.name).toList();
  }

  void addStore(String name, String color) {
    if (value.any((store) => store.name == name)) {
      return;
    }
    final superStore = StoreSchema(name: name, color: color);

    stores.add(superStore.toStore());
    value.add(superStore);
    groceryStoreBox.put(name.toLowerCase(), superStore.toStore());
    notifyListeners();
  }

  void updateStore(String name, String color) {
    StoreSchema superStore = value.firstWhere((store) => store.name == name);
    superStore.color = color;
    int index = value.indexOf(superStore);
    if (index == -1) {
      return;
    }

    value[index] = superStore;
    GroceryStore store = superStore.toStore();
    stores[index] = store;
    groceryStoreBox.put(store.name.toLowerCase(), store);
    notifyListeners();
  }

  void removeStore(StoreSchema schema) {
    StoreSchema store = value.firstWhere((store) => store.name == schema.name);

    value.remove(store);
    groceryStoreBox.delete(store.name.toLowerCase());
    for (Grocery item in store.groceries!) {
      groceryBox.delete(item.key);
    }
    notifyListeners();
  }
}

class StoreSchema {
  String name;
  String color;
  List<Grocery>? groceries = [];

  StoreSchema({required this.name, required this.color});

  Color toColor() {
    return Color(int.parse(color.substring(6, color.length - 1)));
  }

  GroceryStore toStore() {
    return GroceryStore(name: name, color: color);
  }
}

@HiveType(typeId: 0)
class Grocery extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  String store;
  @HiveField(2)
  bool purchased;

  Grocery({required this.name, required this.store, this.purchased = false});
}

@HiveType(typeId: 1)
class GroceryStore {
  @HiveField(0)
  String name;
  @HiveField(1)
  String color;

  GroceryStore({required this.name, required this.color});

  Color toColor() {
    return Color(int.parse(color.substring(6, color.length - 1)));
  }

  StoreSchema toSchema() {
    return StoreSchema(name: name, color: color);
  }
}

class IsTrue extends ChangeNotifier {
  bool value;
  IsTrue({
    required this.value,
  });

  void toggle() {
    value = !value;
    notifyListeners();
  }

  void reset() {
    value = false;
    notifyListeners();
  }
}

class NewStoreController extends StateNotifier<String> {
  NewStoreController() : super('');

  void setText(String newText) {
    state = newText;
  }
}

class StoreSelection extends ChangeNotifier {
  String value;

  StoreSelection({required this.value});

  void select(String store) {
    value = store;
    notifyListeners();
  }

  void reset() {
    value = '';
    notifyListeners();
  }
}

class ColorSelection extends ChangeNotifier {
  Color value;

  ColorSelection({required this.value});

  void select(Color color) {
    value = color;
    notifyListeners();
  }

  void reset() {
    value = Col.noStore;
    notifyListeners();
  }
}

class SwipeState extends ChangeNotifier {
  final Map<dynamic, double> _offsets = {}; // Use a Map

  double getOffset(dynamic itemId) => _offsets[itemId] ?? 0.0;

  void updateOffset(dynamic itemId, double newOffset) {
    _offsets[itemId] = newOffset;
    notifyListeners();
  }

  void resetOffset(dynamic itemId) {
    _offsets[itemId] = 0.0;
    notifyListeners();
  }
}

Future<void> initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(GroceryStoreAdapter());
  Hive.registerAdapter(GroceryAdapter());
  groceryBox = await Hive.openBox<Grocery>('grocery');
  groceryStoreBox = await Hive.openBox<GroceryStore>('stores');
}

Future<Data> loadData() async {
  if (!Hive.isAdapterRegistered(0) ||
      !Hive.isBoxOpen('grocery') ||
      !Hive.isBoxOpen('stores') ||
      !Hive.isAdapterRegistered(1)) {
    await initHive();
  }
  final storesFromHive = groceryStoreBox.values.toList() as List<GroceryStore>;
  final groceriesFromHive = groceryBox.values.toList() as List<Grocery>;
  return Data(storesFromHive, groceriesFromHive);
}

void save({dynamic element, isNew = true, bool isItem = true}) async {
  if (!Hive.isAdapterRegistered(0) ||
      !Hive.isBoxOpen('grocery') ||
      !Hive.isBoxOpen('stores') ||
      !Hive.isAdapterRegistered(1)) {
    await initHive();
  }
  store() async {}
}
