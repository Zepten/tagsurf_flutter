import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'tag_event.dart';
part 'tag_state.dart';

class TagBloc extends Bloc<TagEvent, TagState> {
  TagBloc() : super(TagInitial()) {
    on<TagEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
