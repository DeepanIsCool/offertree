import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:offertree/ui/screens/search/search.dart';

class HomeSearchField extends StatelessWidget {
  const HomeSearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15),
      child: Container(
        width: MediaQuery.of(context).size.width - 42,
        height: 56,
        alignment: AlignmentDirectional.center,
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey.withOpacity(0.7)),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
        ),
        child: TextFormField(
          readOnly: true,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchScreen()),
            );
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Search",
            hintStyle: TextStyle(
              color: Colors.grey.withOpacity(0.5),
            ),
            prefixIcon: Padding(
              padding: const EdgeInsetsDirectional.only(start: 12.0, end: 12),
              child: Icon(Iconsax.search_normal, color: Colors.grey),
            ),
            prefixIconConstraints: const BoxConstraints(minHeight: 5, minWidth: 5),
          ),
        ),
      ),
    );
  }
}
