import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/bloc/tag/tag_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/widgets/common/confirmations/delete_tag_confirmation.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/widgets/common/dialogs/pick_color_dialog.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/widgets/common/dialogs/rename_dialog.dart';

enum TagContextMenuActions { changeColor, copyName, rename, moveToRoot, delete }

showTagContextMenu(
  BuildContext context,
  Offset position,
  TagEntity tag,
  Function(TagEntity, bool) onTagSelected,
  List<String> existingTagsNames,
) async {
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
  if (context.mounted && result != null) {
    switch (result) {
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
        final newName = await showRenameTagDialog(context, tag, existingTagsNames);
        if (context.mounted && newName != null && newName.isNotEmpty) {
          context
              .read<TagBloc>()
              .add(RenameTagEvent(tag: tag, newName: newName));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              showCloseIcon: true,
              elevation: 10.0,
              content: Text('Тег "${tag.name}" переименован в "$newName"'),
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
        final shouldDelete = await showTagDeleteConfirmation(context, tag);
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
    }
  }
}
