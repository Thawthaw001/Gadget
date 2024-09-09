// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class CustomTagInput extends StatefulWidget {
  final List<String> tags;
  final Function(List<String>) onTagsChanged;
  final String hintText;

  const CustomTagInput({
    super.key,
    required this.tags,
    required this.onTagsChanged,
    this.hintText = '', required String labelText,
  });

  @override
  _CustomTagInputState createState() => _CustomTagInputState();
}

class _CustomTagInputState extends State<CustomTagInput> {
  final TextEditingController _controller = TextEditingController();
  List<String> _tags = [];

  @override
  void initState() {
    super.initState();
    _tags = widget.tags;
  }

  void _addTag(String tag) {
    setState(() {
      _tags.add(tag);
    });
    widget.onTagsChanged(_tags);
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
    widget.onTagsChanged(_tags);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: _tags.map((tag) {
            return Chip(
              label: Text(tag),
              onDeleted: () => _removeTag(tag),
            );
          }).toList(),
        ),
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: widget.hintText,
          ),
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              _addTag(value);
              _controller.clear();
            }
          },
        ),
      ],
    );
  }
}
