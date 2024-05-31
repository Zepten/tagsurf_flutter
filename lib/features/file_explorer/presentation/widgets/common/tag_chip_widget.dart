import 'package:flutter/material.dart';
import 'package:tagsurf_flutter/config/util/color_code.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';

class TagChipWidget extends StatelessWidget {
  final TagEntity tag;
  final bool isSelected;
  final Function(TagEntity, bool) onTagSelected;

  const TagChipWidget(
      {super.key,
      required this.tag,
      required this.isSelected,
      required this.onTagSelected});

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(tag.name,
          style: TextStyle(
            color: getContrastColorFromColorCode(tag.colorCode),
          )),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100.0),
      ),
      side: const BorderSide(
        color: Colors.transparent,
      ),
      selected: isSelected,
      selectedShadowColor:
          getLightShadeFromColorCode(tag.colorCode).withOpacity(0.5),
      onSelected: (bool value) {
        onTagSelected(tag, value);
      },
      backgroundColor: getLightShadeFromColorCode(tag.colorCode),
    );
  }
}
