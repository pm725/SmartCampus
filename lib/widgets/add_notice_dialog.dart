import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/notice_provider.dart';

class AddNoticeDialog extends StatefulWidget {
  const AddNoticeDialog({super.key});

  @override
  State<AddNoticeDialog> createState() => _AddNoticeDialogState();
}

class _AddNoticeDialogState extends State<AddNoticeDialog> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String _category = 'General';
  String _priority = 'normal';
  bool _isUrgent = false;

  final List<String> _categories = const [
    'General',
    'Academic',
    'Event',
    'Sports',
    'Administrative'
  ];

  final List<Map<String, dynamic>> _priorities = const [
    {'value': 'low', 'label': '🟢 Low', 'color': 0xFF4CAF50},
    {'value': 'medium', 'label': '🟡 Medium', 'color': 0xFFFF9800},
    {'value': 'high', 'label': '🔴 High', 'color': 0xFFF44336},
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.add_circle_outline, color: Colors.blue),
          SizedBox(width: 8),
          Text('Add New Notice'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title *',
                hintText: 'Enter notice title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Content
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: 'Content *',
                hintText: 'Enter notice details',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 16),

            // Category Dropdown
            DropdownButtonFormField<String>(
              initialValue: _category,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: _categories.map<DropdownMenuItem<String>>((String cat) {
                return DropdownMenuItem<String>(
                  value: cat,
                  child: Text(cat),
                );
              }).toList(),
              onChanged: (String? val) {
                if (val != null) {
                  setState(() => _category = val);
                }
              },
            ),
            const SizedBox(height: 16),

            // Priority Dropdown
            DropdownButtonFormField<String>(
              initialValue: _priority,
              decoration: const InputDecoration(
                labelText: 'Priority',
                border: OutlineInputBorder(),
              ),
              items: _priorities
                  .map<DropdownMenuItem<String>>((Map<String, dynamic> p) {
                return DropdownMenuItem<String>(
                  value: p['value'] as String,
                  child: Text(
                    p['label'] as String,
                    style: TextStyle(color: Color(p['color'] as int)),
                  ),
                );
              }).toList(),
              onChanged: (String? val) {
                if (val != null) {
                  setState(() => _priority = val);
                }
              },
            ),
            const SizedBox(height: 16),

            // Urgent Switch
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Switch(
                    value: _isUrgent,
                    onChanged: (bool val) => setState(() => _isUrgent = val),
                    activeColor: Colors.red,
                    activeThumbColor:
                        Colors.red, // ✅ Fixed: use activeThumbColor
                  ),
                  const Text(
                    'Mark as Urgent',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  if (_isUrgent)
                    Container(
                      margin: const EdgeInsets.only(left: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '⚠️',
                        style:
                            TextStyle(fontSize: 14, color: Colors.red.shade700),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton.icon(
          onPressed: _submitNotice,
          icon: const Icon(Icons.send),
          label: const Text('Add Notice'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  void _submitNotice() async {
    if (_titleController.text.isEmpty) {
      _showSnackbar('Please enter a title');
      return;
    }

    if (_contentController.text.isEmpty) {
      _showSnackbar('Please enter content');
      return;
    }

    final provider = context.read<NoticeProvider>();
    final success = await provider.addNotice(
      title: _titleController.text,
      content: _contentController.text,
      category: _category,
      priority: _priority,
      isUrgent: _isUrgent,
    );

    if (success && mounted) {
      Navigator.pop(context);
      _showSnackbar('✅ Notice added successfully!');
    } else if (mounted) {
      _showSnackbar('❌ Failed to add notice');
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}
