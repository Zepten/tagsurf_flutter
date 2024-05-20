part of 'file_bloc.dart';

abstract class FileEvent {
  const FileEvent();
}

class GetFileEvent extends FileEvent {
  const GetFileEvent();
}
