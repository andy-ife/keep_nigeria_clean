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
  bool _loading = false;
  bool _saving = false;
  String? _error;
  int? _currentInterval;

  final _service = BinDataService();

  @override
  void initState() {
    super.initState();
    _loadCurrentInterval();
  }

  @override
  void dispose() {
    _controller.clear();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentInterval() async {
    if (_loading) return;
    _controller.clear();

    try {
      setState(() {
        _loading = true;
        _error = null;
      });

      final interval = await _service.getUploadInterval();

      setState(() {
        _currentInterval = interval;
        _controller.text = interval.toString();
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load current interval: $e';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _saveInterval() async {
    if (_saving) return;

    final inputText = _controller.text.trim();

    if (inputText.isEmpty) {
      setState(() {
        _error = 'Please enter a frequency value';
      });
      return;
    }

    final interval = int.tryParse(inputText);
    if (interval == null || interval <= 0) {
      setState(() {
        _error = 'Please enter a valid positive number';
      });
      return;
    }

    if (interval < 10000) {
      setState(() {
        _error = 'Minimum interval is 10000ms (10 seconds)';
      });
      return;
    }

    try {
      setState(() {
        _saving = true;
        _error = null;
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
      _controller.clear();
      setState(() {
        _currentInterval = null;
        _error = 'Failed to update interval: $e';
      });
    } finally {
      setState(() {
        _saving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      backgroundColor: theme.colorScheme.surface,
      icon: Icon(Icons.schedule, color: Colors.blue),
      title: const Text('Upload Frequency'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Configure how often smart bins upload data to the server. The frequency is set in milliseconds.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium!.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),

            if (_loading || _saving) ...[
              Center(
                child: Column(
                  children: [
                    SizedBox.square(
                      dimension: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 3.0,
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      _loading
                          ? 'Loading current settings...'
                          : 'Saving settings...',
                      style: theme.textTheme.bodySmall,
                    ),
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
                enabled: !(_loading || _saving),
                decoration: InputDecoration(
                  labelText: 'Frequency (milliseconds)',
                  hintText: 'e.g., 30000 for 30 seconds',
                  prefixIcon: const Icon(Icons.timer),
                  border: const OutlineInputBorder(),
                  errorText: _error,
                  helperText:
                      _controller.text.isNotEmpty &&
                          int.tryParse(_controller.text) != null
                      ? 'Equivalent to: ${Helper.formatInterval(int.parse(_controller.text))}'
                      : null,
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: (_loading || _saving)
                ? null
                : (_error != null && _error!.contains("Failed to load"))
                ? _loadCurrentInterval
                : _saveInterval,
            child: _error != null && _error!.contains("Failed to load")
                ? const Text('Retry')
                : const Text('Update'),
          ),
        ),
      ],
    );
  }
}
