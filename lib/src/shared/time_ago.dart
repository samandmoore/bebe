import 'package:flutter/material.dart';

class TimeAgo extends StatefulWidget {
  final DateTime? time;

  const TimeAgo(this.time, {super.key});

  @override
  State<TimeAgo> createState() => _TimeAgoState();
}

class _TimeAgoState extends State<TimeAgo> with TickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    controller.repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget? child) {
        return Text(timeAgo(widget.time));
      },
    );
  }
}

String timeAgo(DateTime? time) {
  if (time == null) {
    return '';
  }

  final now = DateTime.now();
  final diff = now.difference(time);
  final days = diff.inDays;
  final hours = diff.inHours % 24;
  final minutes = diff.inMinutes % 60;
  final seconds = diff.inSeconds % 60 % 60;

  if (days > 0) {
    return '${days}d ${hours}h ago';
  }

  if (hours > 0) {
    return '${hours}h ${minutes}m ago';
  }

  if (minutes > 0) {
    return '${minutes}m ${seconds}s ago';
  }

  if (seconds > 0) {
    return '${seconds}s ago';
  }

  return 'now';
}
