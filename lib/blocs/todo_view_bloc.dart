import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_do_it/blocs/states/todo_event_state.dart';

enum ToDoViewEvent { list_event, grid_event }

class ToDoViewBloc extends Bloc<ToDoViewEvent, ToDoEventState> {
  ToDoViewBloc(ToDoEventState initialState) : super(initialState);

  @override
  Stream<ToDoEventState> mapEventToState(ToDoViewEvent event) async* {
    if (event == ToDoViewEvent.list_event)
      yield ToDoEventStateList();
    else
      yield ToDoEventStateGrid();
  }
}
