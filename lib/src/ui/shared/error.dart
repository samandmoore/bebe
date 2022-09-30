import 'package:bebe/src/ui/shared/modal.dart';
import 'package:bebe/src/ui/shared/spacing.dart';
import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final Object error;
  final StackTrace? stackTrace;
  final VoidCallback? onRetry;

  const ErrorScreen({
    super.key,
    required this.error,
    this.stackTrace,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: ListView(
        children: [
          if (onRetry != null)
            TextButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ErrorView(error: error, stackTrace: stackTrace),
        ],
      ),
    );
  }
}

class ErrorView extends StatelessWidget {
  final Object? error;
  final StackTrace? stackTrace;

  const ErrorView({
    Key? key,
    required this.error,
    required this.stackTrace,
  }) : super(key: key);

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

class ErrorModal extends StatelessWidget {
  final bool isVisible;
  final VoidCallback onDismiss;
  final Widget child;

  const ErrorModal({
    super.key,
    required this.isVisible,
    required this.onDismiss,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Modal(
      visible: isVisible,
      modal: Center(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.unit * 4,
            vertical: Spacing.unit * 2,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('An error has occurred.'),
              const VSpace(),
              TextButton(
                onPressed: onDismiss,
                child: const Text('Try again'),
              ),
            ],
          ),
        ),
      ),
      child: child,
    );
  }
}
