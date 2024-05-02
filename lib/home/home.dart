import 'package:flutter/material.dart' show Scaffold;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocer/add/add.dart';
import 'package:grocer/groceries/groceries.dart';
import 'package:grocer/location/location.dart';
import 'package:grocer/search/search.dart' show SearchSection;
import 'package:grocer/services/services.dart';
import 'package:grocer/shared/shared.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Col.bg,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: EdgeInsets.all(Gap.sml),
                child: ref.watch(locationVisible).value
                    ? const LocationPage()
                    : const HomeContent(),
              ),
            ),
            const BottomNav(),
          ],
        ),
      ),
    );
  }
}

class HomeContent extends ConsumerWidget {
  const HomeContent({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (ref.watch(addVisible).value) const AddSection(),
        if (ref.watch(searchVisible).value) const SearchSection(),
        const GroceryListWidget(),
      ],
    );
  }
}
