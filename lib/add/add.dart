import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocer/services/services.dart';
import 'package:grocer/shared/styles.dart';

class AddSection extends ConsumerWidget {
  const AddSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txtCtrl = ref.watch(textControllerProvider);
    final storeCtrl = ref.watch(storeSelection);
    final writeData = ref.read(groceryData);

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add Grocery',
          style: Txt.h1,
        ),
        SizedBox(height: Gap.sml),
        TextField(
          controller: txtCtrl,
          style: Txt.label,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: Gap.sml),
            hintText: 'Enter item name',
            hintStyle: TextStyle(color: Col.highlight),
            filled: true,
            fillColor: Col.field,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        SizedBox(height: Gap.sml),
        const StoreDropdown(),
        SizedBox(height: Gap.xs),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: Gap.sml / 2),
                child: FilledButton(
                  onPressed: () {
                    if (txtCtrl.text.isEmpty || storeCtrl.value.isEmpty) {
                      return;
                    }
                    final itemText = txtCtrl.text;
                    writeData.addItem(itemText, storeCtrl.value);
                    ref.read(addVisible).toggle();
                    txtCtrl.clear();
                  },
                  style: FilledButton.styleFrom(
                      padding: EdgeInsets.all(Gap.sml / 2),
                      backgroundColor: Col.highlight,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      )),
                  child: Padding(
                    padding: EdgeInsets.all(Gap.xs / 2),
                    child: Text('Create', style: Txt.p),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: Gap.sml / 2),
                child: FilledButton(
                  onPressed: () {
                    ref.read(addVisible).toggle();
                    txtCtrl.clear();
                  },
                  style: FilledButton.styleFrom(
                      padding: EdgeInsets.all(Gap.sml / 2),
                      backgroundColor: Col.menu,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      )),
                  child: Padding(
                    padding: EdgeInsets.all(Gap.xs / 2),
                    child: Text('Cancel', style: Txt.p),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: Gap.sml / 2),
      ],
    );
  }
}

class StoreDropdown extends ConsumerWidget {
  const StoreDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storeCtrl = ref.watch(storeSelection);

    final writeData = ref.read(groceryData);
    final storeNames = writeData.getStoreNames();

    return Container(
          decoration: ShapeDecoration(
            color: Col.field,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              padding: EdgeInsets.only(left: Gap.sml),
              isExpanded: true,
              dropdownColor: Col.field,
              borderRadius: BorderRadius.circular(6),
              underline: null,
              style: Txt.label,
              items: [
                DropdownMenuItem(
                  value: null,
                  child: Text(
                    'Select Store',
                    style: TextStyle(color: Col.highlight),
                  ),
                ),
                ...storeNames.map((store) => DropdownMenuItem(
                      value: store,
                      child: Text(store),
                      onTap: () => storeCtrl.select(store),
                    )),
              ],
              value: storeCtrl.value.isNotEmpty ? storeCtrl.value : null,
              onChanged: (_) => {},
            ),
          ),
        );
  }
}