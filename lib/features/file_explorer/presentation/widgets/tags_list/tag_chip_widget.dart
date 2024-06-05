import 'package:flutter/material.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/widgets/util/color_util.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';

enum TagContextMenuActions { changeColor, copyName, rename, moveToRoot, delete }

class TagChipWidget extends StatelessWidget {
  final TagEntity tag;
  final bool isSelected;
  final Function(TagEntity, bool) onTagSelected;
  final Function(BuildContext, TagEntity, TagEntity) onTagDropped;
  final Function(TagContextMenuActions, TagEntity) onContextMenuAction;

  const TagChipWidget({
    super.key,
    required this.tag,
    required this.isSelected,
    required this.onTagSelected,
    required this.onTagDropped,
    required this.onContextMenuAction,
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
            _showContextMenu(context, details.globalPosition);
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

  _showContextMenu(BuildContext context, Offset position) async {
    final result = await showMenu(
      context: context,
      elevation: 10.0,
      position: RelativeRect.fromLTRB(
          position.dx, position.dy, position.dx, position.dy),
      items: [
        const PopupMenuItem(
          value: TagContextMenuActions.changeColor,
          child: ListTile(
              leading: Icon(Icons.color_lens, color: Colors.blue),
              title: Text('Изменить цвет')),
        ),
        const PopupMenuItem(
          value: TagContextMenuActions.rename,
          child: ListTile(
              leading: Icon(Icons.edit, color: Colors.blue),
              title: Text('Переименовать')),
        ),
        const PopupMenuItem(
          value: TagContextMenuActions.copyName,
          child: ListTile(
              leading: Icon(Icons.copy_outlined, color: Colors.blue),
              title: Text('Копировать имя')),
        ),
        const PopupMenuItem(
          value: TagContextMenuActions.moveToRoot,
          child: ListTile(
              leading: Icon(Icons.move_up_outlined, color: Colors.blue),
              title: Text('Переместить в корень')),
        ),
        const PopupMenuItem(
          value: TagContextMenuActions.delete,
          child: ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text('Удалить тег')),
        ),
      ],
    );
    if (result != null) {
      onContextMenuAction(result, tag);
    }
  }
}
