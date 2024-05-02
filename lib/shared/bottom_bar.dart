import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grocer/services/services.dart';
import 'package:grocer/shared/styles.dart';
import 'package:logger/logger.dart';

const navItems = [
  {
    'icon': FontAwesomeIcons.plus,
    'label': 'Add',
    'key': 'add',
  },
  {
    'icon': FontAwesomeIcons.locationPin,
    'label': 'Location',
    'key': 'location',
  },
  // {
  //   'icon': FontAwesomeIcons.magnifyingGlass,
  //   'label': 'Search',
  //   'key': 'search',
  // },
  // {
  //   'icon': FontAwesomeIcons.gear,
  //   'label': 'Settings',
  //   'key': 'settings',
  // },
];

class BottomNav extends ConsumerWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Logger().i(MediaQuery.of(context).systemGestureInsets);

    bool gestureBarDisabled = MediaQuery.of(context).viewInsets.left > 0.0;
    double systemNavBarHeight = gestureBarDisabled
        ? MediaQuery.of(context).systemGestureInsets.bottom : Gap.sml;

    Map<String, dynamic> functions = {
      'add': () => {
            // ref.read(textControllerProvider).text = '',
            ref.read(addVisible).toggle(),
          },
      'location': () => {
            // ref.read(textControllerProvider).text = '',
            // ref.read(editModeProvider).reset(),
            ref.read(locationVisible).toggle(),
          },
      'search': () => ref.read(searchVisible).toggle(),
      'settings': () {},
    };

    bool isSelected(String key) {
      switch (key) {
        case 'add':
          return ref.watch(addVisible).value;
        case 'location':
          return ref.watch(locationVisible).value;
        case 'search':
          return ref.watch(searchVisible).value;
        case 'settings':
          return false;
        default:
          return false;
      }
    }

    void toggleSelected(dynamic current) {
      if (!isSelected(current)) {
        for (var item in navItems) {
          if (item['key'] != current && isSelected(item['key'] as String)) {
            functions[item['key']]!();
          }
        }
      }
      functions[current]!();
    }

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: IntrinsicHeight(
        child: Container(
          padding: EdgeInsets.only(
            left: Gap.med,
            right: Gap.med,
            top: Gap.xs,
            bottom: systemNavBarHeight,
          ),
          decoration: ShapeDecoration(
            color: Col.menu,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(bdrRad),
                  topRight: Radius.circular(bdrRad)),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    for (var item in navItems)
                      appBarBtn(
                          item['icon'] as IconData,
                          item['label'] as String,
                          isSelected(item['key'] as String),
                          () => toggleSelected(item['key'])),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InkWell appBarBtn(
      IconData icon, String label, bool selection, dynamic toggle) {
    return InkWell(
      onTap: toggle,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: Gap.sml),
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                    width: rem * 2,
                    height: rem * 1.5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(bdrRad),
                        color: selection ? Col.highlight : Colors.transparent)),
                Padding(
                  padding: EdgeInsets.only(top: Gap.xs),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        icon,
                        size: rem,
                        color: Col.text,
                      ),
                      SizedBox(height: Gap.sml),
                      Text(
                        label,
                        style: Txt.label,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
