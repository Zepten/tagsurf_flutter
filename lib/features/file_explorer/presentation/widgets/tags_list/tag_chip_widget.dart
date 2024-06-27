import 'package:flutter/material.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/widgets/common/tag_context_menu.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/widgets/util/color_util.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';

class TagChipWidget extends StatelessWidget {
  final TagEntity tag;
  final bool isSelected;
  final Function(TagEntity, bool) onTagSelected;
  final Function(BuildContext, TagEntity, TagEntity) onTagDropped;
  final List<String> existingTagsNames;

  const TagChipWidget({
    super.key,
    required this.tag,
    required this.isSelected,
    required this.onTagSelected,
    required this.onTagDropped,
    required this.existingTagsNames,
  });

  @override
  Widget build(BuildContext context) {
    return DragTarget<TagEntity>(
      onAcceptWithDetails: (details) {
        onTagDropped(context, details.data, tag);
      },
      builder: (context, candidateData, rejectedData) {
        return GestureDetector(
          onSecondaryTapDown: (TapDownDetails details) {
            showTagContextMenu(context, details.globalPosition, tag,
                onTagSelected, existingTagsNames);
          },
          child: Draggable<TagEntity>(
            data: tag,
            feedback: Material(
              elevation: 10.0,
              borderRadius: BorderRadius.circular(100),
              child: _buildFilterChip(context, isDragging: true),
            ),
            childWhenDragging: _buildFilterChip(context),
            child: _buildFilterChip(context),
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(BuildContext context, {bool isDragging = false}) {
    return Opacity(
      opacity: isDragging ? 0.5 : 1.0,
      child: FilterChip(
        elevation: 5.0,
        shadowColor: Colors.black,
        label: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            tag.name,
            style: TextStyle(
              color: ColorUtil.getDarkShade(tag.color),
            ),
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100.0),
        ),
        side: const BorderSide(color: Colors.transparent),
        selected: isSelected,
        onSelected: (bool value) {
          onTagSelected(tag, value);
        },
        backgroundColor: ColorUtil.getLightShade(tag.color),
      ),
    );
  }
}
