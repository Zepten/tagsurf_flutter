import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tagsurf_flutter/config/theme/app_themes.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/bloc/file/file_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/bloc/tag/tag_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/pages/home/file_explorer.dart';
import 'package:tagsurf_flutter/features/file_explorer/internal/injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const TagsurfApp());
}

class TagsurfApp extends StatelessWidget {
  const TagsurfApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FileBloc>(
            create: (context) => di.sl<FileBloc>()
              ..add(GetFilesEvent(
                isFiltering: false,
                filters: List.empty(),
                searchQuery: '',
              ))),
        BlocProvider<TagBloc>(
            create: (context) => di.sl<TagBloc>()..add(GetAllTagsEvent())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tagsurf',
        theme: theme(),
        home: const FileExplorer(),
      ),
    );
  }
}
