import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_do_it/blocs/states/todo_search_state.dart';
import 'package:just_do_it/blocs/todo_search_bloc.dart';
import 'package:just_do_it/providers/search_provider.dart';
import 'package:provider/provider.dart';

class ArrowBurger extends StatefulWidget {
  ToDoSearchState searchState;
  GlobalKey<ScaffoldState> scaffoldKey;
  AnimationController turnsAnimationController;
  ArrowBurger(
      {Key? key,
      required this.searchState,
      required this.scaffoldKey,
      required this.turnsAnimationController})
      : super(key: key);

  @override
  _ArrowBurgerState createState() => _ArrowBurgerState();
}

class _ArrowBurgerState extends State<ArrowBurger>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final toDoSearchBloc = BlocProvider.of<ToDoSearchBloc>(context);
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);

    return RotationTransition(
      alignment: Alignment.center,
      turns: widget.turnsAnimationController,
      child: IconButton(
          icon: widget.searchState.leftIcon,
          onPressed: () {
            if (widget.searchState is ToDoSearchStateFalse) {
              widget.scaffoldKey.currentState!.openDrawer();
            } else {
              widget.turnsAnimationController
                  .animateTo(0.25, curve: Curves.easeInOutQuart)
                  .whenComplete(() {
                toDoSearchBloc.add(ToDoSearchEvent.todoNotSearch);
                searchProvider.changeSearchValue(null);
                widget.turnsAnimationController
                    .animateTo(0.5, curve: Curves.easeInOutQuart);
              });
            }
          }),
    );
  }
}
