import 'package:get_it/get_it.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/data_sources/database/app_database.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/data_sources/file_system/file_system_service.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/repository/file_repository_impl.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/repository/file_tag_repository_impl.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/repository/tag_repository_impl.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/repository/file_repository.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/repository/file_tag_repository.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/repository/tag_repository.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/get_tracked_files.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/get_untracked_files.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/track_file.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/untrack_file.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/bloc/file/file_bloc.dart';

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
  sl.registerSingleton<FileTagRepository>(FileTagRepositoryImpl(sl()));

  // UseCases
  sl.registerSingleton<GetTrackedFilesUseCase>(GetTrackedFilesUseCase(sl()));
  sl.registerSingleton<GetUnrackedFilesUseCase>(GetUnrackedFilesUseCase(sl()));
  sl.registerSingleton<TrackFileUseCase>(TrackFileUseCase(sl()));
  sl.registerSingleton<UntrackFileUseCase>(UntrackFileUseCase(sl()));

  // BloCs
  sl.registerFactory<FileBloc>(() => FileBloc(sl()));
}
