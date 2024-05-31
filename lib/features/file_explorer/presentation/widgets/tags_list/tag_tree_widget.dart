import 'package:flutter/material.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/widgets/common/tag_chip_widget.dart';

class TagTreeWidget extends StatelessWidget {
  final List<TagEntity> tags;
  final Set<TagEntity> filters;
  final Function(TagEntity, bool) onTagSelected;

  const TagTreeWidget(
      {super.key,
      required this.tags,
      required this.filters,
      required this.onTagSelected});

  @override
  Widget build(BuildContext context) {
    final tagTree = _buildTagTree(tags);
    final List<TreeNode> treeNodes = tagTree.keys
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
        tag: tag,
        isSelected: filters.contains(tag),
        onTagSelected: onTagSelected,
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
        tagTree[tag] = [];
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
