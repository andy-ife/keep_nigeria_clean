import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keep_nigeria_clean/services/bin_data_service.dart';
import 'package:keep_nigeria_clean/utils/helpers.dart';

class UploadIntervalDialog extends StatefulWidget {
  const UploadIntervalDialog({super.key});

  @override
  State<UploadIntervalDialog> createState() => _UploadIntervalDialogState();
}

class _UploadIntervalDialogState extends State<UploadIntervalDialog> {
  final TextEditingController _controller = TextEditingController();
  bool _loading = true;
  String? _errorMessage;
  int? _currentInterval;

  final _service = BinDataService();

  @override
  void initState() {
    super.initState();
    _loadCurrentInterval();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentInterval() async {
    if (_loading) return;
    try {
      setState(() {
        _loading = true;
        _errorMessage = null;
      });

      final interval = await _service.getUploadInterval();

      setState(() {
        _currentInterval = interval;
        _controller.text = interval.toString();
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load current interval: $e';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _saveInterval() async {
    if (_loading) return;

    final inputText = _controller.text.trim();

    if (inputText.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a frequency value';
      });
      return;
    }

    final interval = int.tryParse(inputText);
    if (interval == null || interval <= 0) {
      setState(() {
        _errorMessage = 'Please enter a valid positive number';
      });
      return;
    }

    if (interval < 10000) {
      setState(() {
        _errorMessage = 'Minimum interval is 10000ms (10 seconds)';
      });
      return;
    }

    try {
      setState(() {
        _loading = true;
        _errorMessage = null;
      });

      await _service.setUploadInterval(interval);

      if (mounted) {
        setState(() {
          _currentInterval = interval;
        });
        Navigator.of(context).pop(interval);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Upload frequency updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to update interval: $e';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.schedule, color: Colors.blue),
          SizedBox(width: 8),
          Text('Upload Frequency'),
        ],
      ),
      content: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Configure how often smart waste bins upload data to the server. The frequency is set in milliseconds.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            if (_loading) ...[
              const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 12),
                    Text('Loading current settings...'),
                  ],
                ),
              ),
            ] else ...[
              if (_currentInterval != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        size: 16,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Current: ${Helper.formatInterval(_currentInterval!)}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                enabled: !_loading,
                decoration: InputDecoration(
                  labelText: 'Frequency (milliseconds)',
                  hintText: 'e.g., 30000 for 30 seconds',
                  prefixIcon: const Icon(Icons.timer),
                  border: const OutlineInputBorder(),
                  errorText: _errorMessage,
                  helperText:
                      _controller.text.isNotEmpty &&
                          int.tryParse(_controller.text) != null
                      ? 'Equivalent to: ${Helper.formatInterval(int.parse(_controller.text))}'
                      : null,
                ),
              ),

              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.warning_amber, size: 16, color: Colors.orange),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Minimum interval: 1000ms (1 second)',
                        style: TextStyle(fontSize: 12, color: Colors.orange),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _loading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: (_loading || _loading) ? null : _saveInterval,
          child: _loading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Update'),
        ),
      ],
    );
  }
}
