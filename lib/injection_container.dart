import 'package:get_it/get_it.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/data_sources/database/app_database.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/data_sources/file_system/file_system_service.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/repository/file_repository_impl.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/repository/file_repository.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/get_tracked_files.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/bloc/file/file_bloc.dart';

import 'features/file_explorer/domain/usecases/get_untracked_files.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  //Database
  final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  sl.registerSingleton<AppDatabase>(database);

  // Dependencies
  sl.registerSingleton<FileSystemService>(FileSystemServiceImpl(sl()));
  sl.registerSingleton<FileRepository>(FileRepositoryImpl(sl(), sl()));

  // UseCases
  sl.registerSingleton<GetTrackedFilesUseCase>(GetTrackedFilesUseCase(sl()));
  sl.registerSingleton<GetUnrackedFilesUseCase>(GetUnrackedFilesUseCase(sl()));

  // BloCs
  sl.registerFactory<FileBloc>(() => FileBloc(sl()));
}
