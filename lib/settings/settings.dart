import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grocer/services/state.dart';
import 'package:grocer/shared/shared.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  get userNameController => null;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Settings', style: Txt.h1),
        SizedBox(
          height: Gap.sml,
        ),
        const Expanded(
          child: Column(
            children: [
              SettingWidget(
                text: 'Delete All Groceries',
              ),
              SettingWidget(
                text: 'Delete All Data',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SettingWidget extends ConsumerWidget {
  const SettingWidget({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void handleClick(String fnName) {
      var write = ref.read(groceryData);
      Function fn; // Make fn nullable

      switch (fnName) {
        case 'Delete All Groceries':
          fn = write.deleteAllItems;
          break;
        case 'Delete All Data':
          fn = write.deleteAllData;
          break;
        default:
          fn = () => {}; // Assign a default value
      }

      if (fn != () => {}) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              contentPadding: EdgeInsets.zero,
              backgroundColor: Col.menu,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(bdrRad),
              ),
              content: DeleteAlert(text: text, fn: fn),
            );
          },
        );
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text, style: Txt.p),
        IconButton(
          highlightColor: Col.error,
          color: Col.text,
          onPressed: () => handleClick(text),
          icon: const Icon(FontAwesomeIcons.trash),
        ),
      ],
    );
  }
}

class DeleteAlert extends ConsumerWidget {
  const DeleteAlert({super.key, required this.text, required this.fn});

  final String text;
  final Function fn;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: Container(
            padding: EdgeInsets.all(Gap.sml),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text, style: Txt.h2),
                SizedBox(height: Gap.sml),
                Text('Are you sure you want to $text?', style: Txt.alert),
                SizedBox(height: Gap.sml),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FilledButton(
                      style: FilledButton.styleFrom(
                          padding: EdgeInsets.all(Gap.sml / 2),
                          backgroundColor: Col.error,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          )),
                      child: Text('Ok', style: Txt.p),
                      onPressed: () {
                        fn(); // Call the function
                        Navigator.pop(context);
                        ref.read(storeSelection).reset();
                      },
                    ),
                    TextButton(
                      child: Text('Cancel', style: Txt.p),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
