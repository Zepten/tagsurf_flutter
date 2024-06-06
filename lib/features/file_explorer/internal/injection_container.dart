import 'package:get_it/get_it.dart';
import 'package:tagsurf_flutter/config/constants/app_database.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/data_sources/database/app_database.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/data_sources/file_system/file_system_service.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/data_sources/file_system/file_system_service_impl.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/repository/file_repository_impl.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/repository/file_tag_link_repository_impl.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/repository/tag_repository_impl.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/repository/file_repository.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/repository/file_tag_link_repository.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/repository/tag_repository.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/file_tag_links/get_files_by_tags.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/file_tag_links/get_tags_by_file.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/file_tag_links/get_untagged_files.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/file_tag_links/link_file_and_tag.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/file_tag_links/link_or_create_tag.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/file_tag_links/unlink_file_and_tag.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/files/get_tracked_files.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/files/get_all_files_from_directory.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/files/open_file.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/files/update_file.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/tags/change_tag_color.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/tags/create_tag.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/tags/delete_tag.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/tags/get_all_tags.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/tags/rename_tag.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/tags/set_parent.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/files/track_files.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/files/untrack_file.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/bloc/file/file_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/bloc/tag/tag_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features: File Explorer
  //? BLoCs
  sl.registerFactory<FileBloc>(() => FileBloc(sl(), sl(), sl(), sl(), sl(), sl(), sl()));
  sl.registerFactory<TagBloc>(() => TagBloc(sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl()));

  //? Use cases
  // File Use cases
  sl.registerLazySingleton<GetAllFilesFromDirectoryUseCase>(() => GetAllFilesFromDirectoryUseCase(sl()));
  sl.registerLazySingleton<GetTrackedFilesUseCase>(() => GetTrackedFilesUseCase(sl()));
  sl.registerLazySingleton<UpdateFileUseCase>(() => UpdateFileUseCase(sl()));
  sl.registerLazySingleton<TrackFilesUseCase>(() => TrackFilesUseCase(sl()));
  sl.registerLazySingleton<UntrackFileUseCase>(() => UntrackFileUseCase(sl()));
  sl.registerLazySingleton<OpenFileUseCase>(() => OpenFileUseCase(sl()));
  // Tag Use cases
  sl.registerLazySingleton<CreateTagUseCase>(() => CreateTagUseCase(sl()));
  sl.registerLazySingleton<RenameTagUseCase>(() => RenameTagUseCase(sl()));
  sl.registerLazySingleton<ChangeTagColorUseCase>(() => ChangeTagColorUseCase(sl()));
  sl.registerLazySingleton<DeleteTagUseCase>(() => DeleteTagUseCase(sl()));
  sl.registerLazySingleton<GetAllTagsUseCase>(() => GetAllTagsUseCase(sl()));
  sl.registerLazySingleton<SetParentTagUseCase>(() => SetParentTagUseCase(sl()));
  // File-tag association (linking) Use cases
  sl.registerLazySingleton<LinkFileAndTagUseCase>(() => LinkFileAndTagUseCase(sl()));
  sl.registerLazySingleton<LinkOrCreateTagUseCase>(() => LinkOrCreateTagUseCase(sl()));
  sl.registerLazySingleton<UnlinkFileAndTagUseCase>(() => UnlinkFileAndTagUseCase(sl()));
  sl.registerLazySingleton<GetFilesByTagsUseCase>(() => GetFilesByTagsUseCase(sl()));
  sl.registerLazySingleton<GetTagsByFileUseCase>(() => GetTagsByFileUseCase(sl()));
  sl.registerLazySingleton<GetUntaggedFilesUseCase>(() => GetUntaggedFilesUseCase(sl()));

  //? Repository
  sl.registerLazySingleton<FileRepository>(() => FileRepositoryImpl(sl(), sl()));
  sl.registerLazySingleton<TagRepository>(() => TagRepositoryImpl(sl()));
  sl.registerLazySingleton<FileTagLinkRepository>(() => FileTagLinkRepositoryImpl(sl()));

  //? Data sources
  final database = await $FloorAppDatabase.databaseBuilder(DATABASE_NAME).build();
  sl.registerLazySingleton<AppDatabase>(() => database);
  sl.registerLazySingleton<FileSystemService>(() => FileSystemServiceImpl());
}
