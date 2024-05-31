import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/bloc/file/file_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/bloc/tag/tag_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/color_code.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';

class TagTreeWidget extends StatelessWidget {
  final List<TagEntity> tags;

  const TagTreeWidget({super.key, required this.tags});

  @override
  Widget build(BuildContext context) {
    Map<TagEntity, List<TagEntity>> tagTree = {};
    for (final tag in tags) {
      if (tag.parentTagName == null) {
        tagTree[tag] = [];
      } else {
        var parent = tags.firstWhere(
          (t) => t.name == t.parentTagName,
          orElse: () => const TagEntity(
              name: '',
              colorCode: ColorCode(
                red: 0,
                green: 0,
                blue: 0,
              )),
        );
        if (!tagTree.containsKey(parent)) {
          tagTree[parent] = [];
        }
        tagTree[parent]!.add(tag);
      }
    }
    return ListView(
      children: tagTree.keys
          .map((tag) => _buildTagTile(context, tag, tagTree))
          .toList(),
    );
  }

  Widget _buildTagTile(BuildContext context, TagEntity tag,
      Map<TagEntity, List<TagEntity>> tagTree) {
    return ExpansionTile(
      title: InkWell(
        onTap: () =>
            context.read<FileBloc>().add(GetFilesByTagEvent(tag: tag)),
        child: Container(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Color.fromARGB(
              255,
              tag.colorCode.red,
              tag.colorCode.green,
              tag.colorCode.blue,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.black, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tag.name,
                style: const TextStyle(
                  // TODO: contrast tag name color
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (tag.parentTagName != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    'Parent: ${tag.parentTagName}',
                    // Цвет текста, выбрать контрастирующий с цветом тега
                    style: const TextStyle(
                      color: Colors.black,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              IconButton(
                  onPressed: () {
                    context.read<TagBloc>().add(DeleteTagEvent(tag: tag));
                    context.read<FileBloc>().add(GetTrackedFilesEvent());
                  },
                  icon: const Icon(Icons.delete)),
            ],
          ),
        ),
      ),
      children: (tagTree[tag] ?? [])
          .map((childTag) => _buildTagTile(context, childTag, tagTree))
          .toList(),
    );
  }
}
