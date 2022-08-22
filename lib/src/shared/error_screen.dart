import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final Object error;
  final StackTrace? stackTrace;

  const ErrorScreen({
    super.key,
    required this.error,
    this.stackTrace,
  });

  @override
  Widget build(BuildContext context) {
    return ErrorView(error: error, stackTrace: stackTrace);
  }
}

class ErrorView extends StatelessWidget {
  const ErrorView({
    Key? key,
    required this.error,
    required this.stackTrace,
  }) : super(key: key);

  final Object error;
  final StackTrace? stackTrace;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Error: $error\n$stackTrace',
        textAlign: TextAlign.center,
      ),
    );
  }
}
