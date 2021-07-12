import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_do_it/blocs/states/todo_search_state.dart';

enum ToDoSearchEvent {
  todoSearch,
  todoNotSearch,
}

class ToDoSearchBloc extends Bloc<ToDoSearchEvent, ToDoSearchState> {
  ToDoSearchBloc(ToDoSearchState initialState) : super(initialState);

  @override
  Stream<ToDoSearchState> mapEventToState(ToDoSearchEvent event) async*{
    if (event == ToDoSearchEvent.todoSearch)
      yield ToDoSearchStateTrue();
    else
      yield ToDoSearchStateFalse();
  }
}
