import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/bloc/tag/tag_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/widgets/common/delete_tag_confirmation.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/widgets/common/pick_color_dialog.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/widgets/common/rename_dialog.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/widgets/tags_list/tag_chip_widget.dart';

class TagTreeWidget extends StatelessWidget {
  final List<TagEntity> tags;
  final Set<String> filters;
  final Function(TagEntity, bool) onTagSelected;
  final Function(BuildContext, TagEntity, TagEntity) onTagDropped;

  const TagTreeWidget({
    super.key,
    required this.tags,
    required this.filters,
    required this.onTagSelected,
    required this.onTagDropped,
  });

  @override
  Widget build(BuildContext context) {
    final tagTree = _buildTagTree(tags);
    final List<TreeNode> treeNodes = tagTree.keys
        .where((tag) => tag.parentTagName == null)
        .map((tag) => _buildTreeNode(context, tag, tagTree))
        .toList();
    return TreeView(
      nodes: treeNodes,
      treeController: TreeController(allNodesExpanded: true),
    );
  }

  TreeNode _buildTreeNode(BuildContext context, TagEntity tag,
      Map<TagEntity, List<TagEntity>> tagTree) {
    return TreeNode(
      content: TagChipWidget(
        key: ValueKey(tag.name),
        tag: tag,
        isSelected: filters.contains(tag.name),
        onTagSelected: onTagSelected,
        onTagDropped: onTagDropped,
        onContextMenuAction: (action, tag) async {
          switch (action) {
            case TagContextMenuActions.changeColor:
              final currentColor = tag.color;
              final color = await showPickColorDialog(context, currentColor);
              if (context.mounted && color != null) {
                context
                    .read<TagBloc>()
                    .add(ChangeTagColorEvent(tag: tag, color: color));
              }
              break;
            case TagContextMenuActions.rename:
              final newName = await showRenameTagDialog(context, tag);
              if (context.mounted && newName != null && newName.isNotEmpty) {
                context
                    .read<TagBloc>()
                    .add(RenameTagEvent(tag: tag, newName: newName));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    showCloseIcon: true,
                    elevation: 10.0,
                    content:
                        Text('Тег "${tag.name}" переименован в "$newName"'),
                    backgroundColor: Colors.blue,
                    duration: const Duration(seconds: 3),
                  ),
                );
              }
              break;
            case TagContextMenuActions.copyName:
              await Clipboard.setData(ClipboardData(text: tag.name));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    showCloseIcon: true,
                    elevation: 10.0,
                    content: Text('Скопировано в буфер обмена: "${tag.name}"'),
                    backgroundColor: Colors.blue,
                    duration: const Duration(seconds: 3),
                  ),
                );
              }
              break;
            case TagContextMenuActions.moveToRoot:
              context
                  .read<TagBloc>()
                  .add(SetParentTagEvent(tag: tag, parentTag: null));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  showCloseIcon: true,
                  elevation: 10.0,
                  content: Text('Тег "${tag.name}" перемещён в корень'),
                  backgroundColor: Colors.blue,
                  duration: const Duration(seconds: 3),
                ),
              );
              break;
            case TagContextMenuActions.delete:
              final shouldDelete =
                  await showTagDeleteConfirmation(context, tag);
              if (context.mounted && shouldDelete) {
                onTagSelected(tag, false);
                context.read<TagBloc>().add(DeleteTagEvent(tag: tag));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    showCloseIcon: true,
                    elevation: 10.0,
                    content: Text('Тег удален: "${tag.name}"'),
                    backgroundColor: Colors.blue,
                    duration: const Duration(seconds: 3),
                  ),
                );
              }
              break;
            default:
              break;
          }
        },
      ),
      children: (tagTree[tag] ?? [])
          .map((childTag) => _buildTreeNode(context, childTag, tagTree))
          .toList(),
    );
  }

  Map<TagEntity, List<TagEntity>> _buildTagTree(List<TagEntity> tags) {
    final Map<String, TagEntity> tagByName = {
      for (var tag in tags) tag.name: tag
    };
    Map<TagEntity, List<TagEntity>> tagTree = {};
    for (final tag in tags) {
      if (tag.parentTagName == null) {
        tagTree.putIfAbsent(tag, () => []);
      } else {
        final parent = tagByName[tag.parentTagName];
        if (parent != null) {
          tagTree.putIfAbsent(parent, () => []);
        }
        tagTree[parent]!.add(tag);
      }
    }
    return tagTree;
  }
}
