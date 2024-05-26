import 'package:get_it/get_it.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/data_sources/database/app_database.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/data_sources/file_system/file_system_service.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/repository/file_repository_impl.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/repository/file_tag_link_repository_impl.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/repository/tag_repository_impl.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/repository/file_repository.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/repository/file_tag_link_repository.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/repository/tag_repository.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/files/get_tracked_files.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/files/get_all_files_from_directory.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/files/get_untracked_files.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/tags/create_tag.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/tags/create_tags.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/tags/delete_tag.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/tags/get_all_tags.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/tags/update_tag.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/files/track_file.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/files/track_files.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/files/untrack_file.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/bloc/file/file_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/bloc/tag/tag_bloc.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  //Database
  final database =
      await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  sl.registerSingleton<AppDatabase>(database);

  // Dependencies
  sl.registerSingleton<FileSystemService>(FileSystemServiceImpl());
  sl.registerSingleton<FileRepository>(FileRepositoryImpl(sl(), sl()));
  sl.registerSingleton<TagRepository>(TagRepositoryImpl(sl()));
  sl.registerSingleton<FileTagLinkRepository>(FileTagLinkRepositoryImpl(sl()));

  // File UseCases
  sl.registerSingleton<GetAllFilesFromDirectoryUseCase>(
      GetAllFilesFromDirectoryUseCase(sl()));
  sl.registerSingleton<GetTrackedFilesUseCase>(GetTrackedFilesUseCase(sl()));
  sl.registerSingleton<GetUnrackedFilesFromDirectoryUseCase>(
      GetUnrackedFilesFromDirectoryUseCase(sl()));
  sl.registerSingleton<TrackFileUseCase>(TrackFileUseCase(sl()));
  sl.registerSingleton<TrackFilesUseCase>(TrackFilesUseCase(sl()));
  sl.registerSingleton<UntrackFileUseCase>(UntrackFileUseCase(sl()));

  // Tag UseCases
  sl.registerSingleton<CreateTagUseCase>(CreateTagUseCase(sl()));
  sl.registerSingleton<CreateTagsUseCase>(CreateTagsUseCase(sl()));
  sl.registerSingleton<UpdateTagUseCase>(UpdateTagUseCase(sl()));
  sl.registerSingleton<DeleteTagUseCase>(DeleteTagUseCase(sl()));
  sl.registerSingleton<GetAllTagsUseCase>(GetAllTagsUseCase(sl()));

  // BloCs
  sl.registerFactory<FileBloc>(() => FileBloc(sl(), sl(), sl(), sl()));
  sl.registerFactory<TagBloc>(() => TagBloc(sl(), sl(), sl(), sl(), sl()));
}
