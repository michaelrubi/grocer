import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocer/location/color_picker.dart';
import 'package:grocer/services/services.dart';
import 'package:grocer/shared/shared.dart';

import 'stores.dart';

class LocationPage extends StatelessWidget {
  const LocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StoreForm(),
        StoreListWidget(),
      ],
    );
  }
}

class StoreForm extends ConsumerWidget {
  const StoreForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txtCtrl = ref.watch(textControllerProvider);
    final colorCtrl = ref.watch(colorSelection);
    final editMode = ref.watch(editModeProvider);
    final writeData = ref.read(groceryData);

    void submit() {
      if (txtCtrl.text.isEmpty) {
        return;
      }
      final storeText = txtCtrl.text;
      final storeColor = colorCtrl.value.toString();

      editMode.value
          ? writeData.updateStore(storeText, storeColor)
          : writeData.addStore(storeText, storeColor);
      txtCtrl.clear();
      colorCtrl.reset();
      ref.read(editModeProvider).reset();
      ref.read(storeSelection).reset();
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    }

    void showColorPicker() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            backgroundColor: Col.surface,
            shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(bdrRad)),
            content: ColorPicker(
                onColorSelected: (selectedColor) {
                  ref.read(colorSelection).select(selectedColor);
                },
                initialColor: colorCtrl.value),
          );
        },
      ).then((selectedColor) {
      });
    }

    return Expanded(
      flex: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(editMode.value ? 'Update Store' : 'Add Store', style: Txt.h1),
          SizedBox(height: Gap.sml),
          Row(
            children: [
              Expanded(
                child: TextField(
                  // Store Name Field
                  controller: txtCtrl,
                  style: Txt.label,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: Gap.sml),
                      hintText: 'Enter Store Name',
                      hintStyle: TextStyle(color: Col.highlight),
                      filled: true,
                      fillColor: Col.field,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide.none,
                      )),
                ),
              ),
              SizedBox(width: Gap.sml),
              Expanded(
                flex: 0,
                child: SizedBox(
                  height: 48,
                  width: 48,
                  child: FloatingActionButton(
                    onPressed: () => showColorPicker(),
                    backgroundColor: colorCtrl.value,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(bdrRad)),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: Gap.xs),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  //Submit Button (Create or Update)
                  onPressed: () {
                    submit();
                  },
                  style: FilledButton.styleFrom(
                      padding: EdgeInsets.all(Gap.sml / 2),
                      backgroundColor: Col.highlight,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      )),
                  child: Padding(
                    padding: EdgeInsets.all(Gap.xs / 2),
                    child: Text(editMode.value ? 'Update' : 'Create',
                        style: Txt.p),
                  ),
                ),
              ),
              SizedBox(width: Gap.sml),
              Expanded(
                child: FilledButton(
                  // Cancel Button
                  onPressed: () {
                    txtCtrl.clear();
                    colorCtrl.reset();
                    editMode.value ? ref.read(editModeProvider).toggle() : {};
                    SystemChannels.textInput.invokeMethod('TextInput.hide');
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
            ],
          ),
          SizedBox(height: Gap.xs),
        ],
      ),
    );
  }
}
