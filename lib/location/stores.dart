import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grocer/services/services.dart';
import 'package:grocer/shared/styles.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

enum Actions { toggle, delete }

class StoreListWidget extends ConsumerWidget {
  const StoreListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final readData = ref.watch(groceryData).value;
    final writeData = ref.read(groceryData);

    List<StoreSchema> allStores = readData;

    void handleClick(StoreSchema store) {
      final isEditMode = ref.watch(editModeProvider).value;
      final toggleEditMode = ref.read(editModeProvider).toggle();
      if (!isEditMode) {
        toggleEditMode;
      } else if (ref.watch(storeSelection).value == store.name) {
        toggleEditMode;
        ref.read(textControllerProvider).text = '';
        ref.read(colorSelection).reset();
        return;
      }
      ref.read(storeSelection).select(store.name);
      ref.read(textControllerProvider).text = store.name;
      ref.read(colorSelection).select(store.toColor());
    }

    return Expanded(
      child: SlidableAutoCloseBehavior(
        closeWhenOpened: true,
        closeWhenTapped: true,
        child: ListView.builder(
          itemCount: allStores.length,
          itemBuilder: (context, index) {
            final store = allStores[index];
            return Column(
              children: [
                Slidable(
                  startActionPane: ActionPane(
                    motion: const StretchMotion(),
                    extentRatio: 0.185,
                    children: [
                      SlidableAction(
                        spacing: Gap.sml,
                        autoClose: true,
                        borderRadius: BorderRadius.circular(bdrRad),
                        backgroundColor: Col.error,
                        foregroundColor: _textColor(Col.error),
                        icon: FontAwesomeIcons.trash,
                        label: 'Del',
                        onPressed: (context) => _onDismissed(
                            allStores,
                            index,
                            Actions.delete,
                            writeData,
                            context),
                      ),
                    ],
                  ),
                  endActionPane: ActionPane(
                    motion: const StretchMotion(),
                    extentRatio: 0.185,
                    children: [
                      SlidableAction(
                        spacing: Gap.sml,
                        autoClose: true,
                        borderRadius: BorderRadius.circular(bdrRad),
                        backgroundColor: Col.error,
                        foregroundColor: _textColor(Col.error),
                        icon: FontAwesomeIcons.trash,
                        label: 'Del',
                        // onPressed: (context) => {},
                        onPressed: (context) => _onDismissed(
                            allStores,
                            index,
                            Actions.delete,
                            writeData,
                            context),
                      ),
                    ],
                  ),
                  child: InkWell(
                    child: GroceryStoreWidget(store: store.toStore()),
                    onTap: () => handleClick(store),
                  ),
                ),
                SizedBox(height: Gap.sml),
              ],
            );
          },
        ),
      ),
    );
  }

  Color _textColor(Color surface) {
    return surface.computeLuminance() > 0.5 ? Col.bg : Col.text;
  }

  void _onDismissed(List<StoreSchema> read, int index, Actions action,
      Data write, BuildContext context) {
    final store = read[index];

    write.removeStore(store);
    String message = ' deleted';
    Color color = Col.error;
    _showSnackBar(
        context, '${store.name} $message', color, action, write, store);
  }

  void _showSnackBar(BuildContext context, String message, Color color,
      Actions action, Data write, StoreSchema store) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          write.addStore(store.name, store.color);
          if (store.groceries?.isNotEmpty == true) {
            for (Grocery grocery in store.groceries!) {
              write.addItem(grocery.name, grocery.store);
            }
          }
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

class GroceryStoreWidget extends ConsumerWidget {
  const GroceryStoreWidget({super.key, required this.store});

  final GroceryStore store;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.all(Gap.sml),
      decoration: ShapeDecoration(
        color: store.toColor(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(bdrRad),
        ),
      ),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 0.75 * rem + Gap.sml),
            Text(store.name, style: Txt.p),
            SizedBox(
              width: 0.75 * rem + Gap.sml,
              child: Icon(
                FontAwesomeIcons.pencil,
                color: Col.text,
              ),
            )
          ]),
    );
  }
}
