import 'package:flutter/material.dart';
import 'package:just_do_it/providers/search_provider.dart';
import 'package:provider/provider.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);
    return Container(
        child: TextField(
      decoration: InputDecoration(hintText: 'Input text'),
      onChanged: (value) {
        searchProvider.changeSearchValue(value);
      },
    ));
  }
}
