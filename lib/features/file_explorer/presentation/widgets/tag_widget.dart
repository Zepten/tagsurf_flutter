import 'package:flutter/material.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';

class TagWidget extends StatelessWidget {
  final TagEntity tag;

  const TagWidget({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
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
        children: <Widget>[
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
        ],
      ),
    );
  }
}
