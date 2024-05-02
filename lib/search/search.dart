import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocer/services/state.dart';
import '../shared/styles.dart';

class SearchSection extends ConsumerWidget {
  const SearchSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchCtrl = ref.watch(searchControllerProvider);
    return Column(
      children: [
        Text(
          'Search Recent Items',
          style: Txt.h1,
        ),
        SizedBox(height: Gap.sml),
        TextField(
          controller: searchCtrl,
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
      ],
    );
  }
}
