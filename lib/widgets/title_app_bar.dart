import 'package:flutter/material.dart';
import 'package:just_do_it/blocs/states/todo_search_state.dart';
import 'package:just_do_it/providers/search_provider.dart';
import 'package:provider/provider.dart';

class TitleAppBar extends StatelessWidget {
  final ToDoSearchState state;
  final String title;
  const TitleAppBar({
    Key? key,
    required this.state,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);

    return AnimatedSwitcher(
      transitionBuilder: (child, animation) => FadeTransition(
        child: child,
        opacity: animation,
      ),
      duration: Duration(milliseconds: 400),
      child: state.searchWidget(
        searchProvider.searchValue ?? title,
      ),
    );
  }
}
