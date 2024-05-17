import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grocer/services/services.dart';
import 'package:grocer/shared/styles.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

enum Actions { toggle, delete }

class GroceryListWidget extends ConsumerWidget {
  const GroceryListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ignore: unused_local_variable
    final readData = ref.watch(groceryData).value; // Required for refresh
    final writeData = ref.read(groceryData);
    final txtCtrl = ref.watch(textControllerProvider);
    final groceries = writeData.getGroceries();
    final filtered = writeData.filter(txtCtrl);
    bool filterable = ref.watch(addVisible).value || ref.watch(searchVisible).value;

    return Expanded(
      child: SlidableAutoCloseBehavior(
      closeWhenOpened: true,
      closeWhenTapped: true,
      child: ListView.builder(
        itemCount:
            // groceries.length,
            !filterable ? groceries.length : filtered.length,
        itemBuilder: (context, index) {
          // final grocery = groceries[index];
          final grocery = !filterable ? groceries[index] : filtered[index];
          return Column(
            children: [
              Slidable(
                startActionPane: ActionPane(
                  motion: const StretchMotion(),
                  extentRatio: 0.185,
                  children: [
                    SlidableAction(
                      flex: 2,
                      spacing: Gap.sml,
                      autoClose: true,
                      borderRadius: BorderRadius.circular(bdrRad),
                      backgroundColor: _getSurface(grocery.purchased),
                      foregroundColor:
                          _textColor(_getSurface(grocery.purchased)),
                      icon: _getIcon(grocery.purchased),
                      label: grocery.purchased ? 'Del' : 'Buy',
                      onPressed: (context) => _onDismissed(
                          groceries,
                          index,
                          grocery.purchased ? Actions.delete : Actions.toggle,
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
                      // flex: 2,
                      spacing: Gap.sml,
                      autoClose: true,
                      borderRadius: BorderRadius.circular(bdrRad),
                      backgroundColor: _getSurface(grocery.purchased),
                      foregroundColor:
                          _textColor(_getSurface(grocery.purchased)),
                      icon: _getIcon(grocery.purchased),
                      label: grocery.purchased ? 'Del' : 'Buy',
                      onPressed: (context) => _onDismissed(
                          groceries,
                          index,
                          grocery.purchased ? Actions.delete : Actions.toggle,
                          writeData,
                          context),
                    ),
                  ],
                ),
                child: InkWell(
                  child: GroceryItemWidget(item: grocery),
                  onTap: () => grocery.purchased
                      ? _onDismissed(
                          groceries,
                          index,
                          Actions.toggle,
                          writeData,
                          context)
                      : () {},
                ),
              ),
                index != groceries.length - 1
                    ? SizedBox(height: Gap.sml)
                    : SizedBox(height: Gap.med * 3.25),
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

  Color _getSurface(bool purchased) {
    return purchased ? Col.error : Col.highlight;
  }

  IconData _getIcon(bool purchased) {
    return purchased ? FontAwesomeIcons.trash : FontAwesomeIcons.cartShopping;
  }

  void _onDismissed(List<Grocery> read, int index, Actions action, Data write,
      BuildContext context) {
    final grocery = read[index];

    switch (action) {
      case Actions.toggle:
        write.togglePurchased(grocery);
        String message = grocery.purchased ? ' purchased' : ' listed';
        Color color = grocery.purchased ? Col.highlight : Col.noStore;
        _showSnackBar(
            context, '${grocery.name} $message', color, action, write, grocery);
        break;
      case Actions.delete:
        write.deleteItem(grocery);
        String message = ' deleted';
        Color color = Col.error;
        _showSnackBar(
            context, '${grocery.name} $message', color, action, write, grocery);
        break;
    }
  }

  void _showSnackBar(BuildContext context, String message, Color color,
      Actions action, Data write, Grocery grocery) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          switch (action) {
            case Actions.toggle:
              write.togglePurchased(grocery);
              break;
            case Actions.delete:
              write.addItem(grocery.name, grocery.store,
                  isPurchased: grocery.purchased);
              break;
          }
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

class GroceryItemWidget extends ConsumerWidget {
  const GroceryItemWidget({super.key, required this.item});

  final Grocery item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stores = ref.watch(groceryData).value;
    late int storeIndex =
        stores.indexOf(stores.firstWhere((store) => store.name == item.store));

    getColor() {
      if (item.purchased) {
        return Col.highlight;
      } else {
        return stores[storeIndex].toColor();
      }
    }

    return Container(
      padding: EdgeInsets.all(Gap.sml),
      decoration: ShapeDecoration(
        color: getColor(),
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
            Text(item.name),
            item.purchased
                ? SizedBox(
                    width: 0.75 * rem + Gap.sml,
                    child: Icon(FontAwesomeIcons.plus, color: Col.text))
                : SizedBox(width: 0.75 * rem + Gap.sml),
          ]),
    );
  }
}
