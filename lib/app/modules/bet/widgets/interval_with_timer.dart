import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IntervalWithTimer extends StatefulWidget {
  final String interval;
  final DateTime endDate;

  const IntervalWithTimer({
    super.key,
    required this.interval,
    required this.endDate,
  });

  @override
  State<IntervalWithTimer> createState() => _IntervalWithTimerState();
}

class _IntervalWithTimerState extends State<IntervalWithTimer> {
  late Duration _remaining;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _updateRemaining();
    _timer =
        Timer.periodic(const Duration(seconds: 1), (_) => _updateRemaining());
  }

  void _updateRemaining() {
    final now = DateTime.now();
    setState(() {
      _remaining = widget.endDate.difference(now);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  @override
  Widget build(BuildContext context) {
    final isClosed = _remaining.inSeconds <= 0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.repeat, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 4),
        Text(widget.interval, style: TextStyle(color: Colors.grey.shade600)),
        const SizedBox(width: 12),
        Icon(Icons.timer_outlined,
            size: 16, color: isClosed ? Colors.red : Colors.grey.shade600),
        const SizedBox(width: 4),
        Text(
          isClosed ? "베팅 마감" : _formatDuration(_remaining),
          style: TextStyle(
            color: isClosed ? Colors.red : Colors.grey.shade600,
            fontWeight: isClosed ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
