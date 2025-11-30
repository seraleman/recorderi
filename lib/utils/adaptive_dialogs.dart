import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'platform_utils.dart';

/// Shows an adaptive confirmation dialog based on the platform
Future<T?> showAdaptiveConfirmDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required String cancelText,
  required String confirmText,
  bool isDestructive = false,
  VoidCallback? onConfirm,
}) {
  if (PlatformUtils.useCupertino) {
    return showCupertinoDialog<T>(
      context: context,
      builder:
          (context) => CupertinoAlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              CupertinoDialogAction(
                onPressed: () => Navigator.pop(context),
                child: Text(cancelText),
              ),
              CupertinoDialogAction(
                isDestructiveAction: isDestructive,
                onPressed: () {
                  onConfirm?.call();
                  Navigator.pop(context);
                },
                child: Text(confirmText),
              ),
            ],
          ),
    );
  }

  return showDialog<T>(
    context: context,
    builder:
        (context) => AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(cancelText),
            ),
            FilledButton(
              onPressed: () {
                onConfirm?.call();
                Navigator.pop(context);
              },
              style:
                  isDestructive
                      ? FilledButton.styleFrom(backgroundColor: Colors.red)
                      : null,
              child: Text(confirmText),
            ),
          ],
        ),
  );
}

/// Shows an adaptive input dialog with a single text field
Future<String?> showAdaptiveInputDialog({
  required BuildContext context,
  required String title,
  required String label,
  required String hint,
  required String cancelText,
  required String confirmText,
  String? initialValue,
}) {
  final controller = TextEditingController(text: initialValue);

  if (PlatformUtils.useCupertino) {
    return showCupertinoDialog<String>(
      context: context,
      builder:
          (context) => CupertinoAlertDialog(
            title: Text(title),
            content: Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: CupertinoTextField(
                controller: controller,
                placeholder: hint,
                autofocus: true,
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    Navigator.pop(context, value.trim());
                  }
                },
              ),
            ),
            actions: [
              CupertinoDialogAction(
                onPressed: () => Navigator.pop(context),
                child: Text(cancelText),
              ),
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () {
                  if (controller.text.trim().isNotEmpty) {
                    Navigator.pop(context, controller.text.trim());
                  }
                },
                child: Text(confirmText),
              ),
            ],
          ),
    );
  }

  return showDialog<String>(
    context: context,
    builder:
        (context) => AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: label, hintText: hint),
            autofocus: true,
            onSubmitted: (value) {
              if (value.trim().isNotEmpty) {
                Navigator.pop(context, value.trim());
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(cancelText),
            ),
            FilledButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  Navigator.pop(context, controller.text.trim());
                }
              },
              child: Text(confirmText),
            ),
          ],
        ),
  );
}

/// Shows an adaptive dialog with two text fields
Future<Map<String, String>?> showAdaptiveMultiInputDialog({
  required BuildContext context,
  required String title,
  required String field1Label,
  required String field1Hint,
  required String field2Label,
  required String field2Hint,
  required String cancelText,
  required String confirmText,
  String? field1InitialValue,
  String? field2InitialValue,
  int? field2MaxLines,
}) {
  final controller1 = TextEditingController(text: field1InitialValue);
  final controller2 = TextEditingController(text: field2InitialValue);

  if (PlatformUtils.useCupertino) {
    return showCupertinoDialog<Map<String, String>>(
      context: context,
      builder:
          (context) => CupertinoAlertDialog(
            title: Text(title),
            content: Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CupertinoTextField(
                    controller: controller1,
                    placeholder: field1Hint,
                    autofocus: true,
                  ),
                  const SizedBox(height: 12),
                  CupertinoTextField(
                    controller: controller2,
                    placeholder: field2Hint,
                    maxLines: field2MaxLines ?? 3,
                  ),
                ],
              ),
            ),
            actions: [
              CupertinoDialogAction(
                onPressed: () => Navigator.pop(context),
                child: Text(cancelText),
              ),
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () {
                  if (controller1.text.trim().isNotEmpty &&
                      controller2.text.trim().isNotEmpty) {
                    Navigator.pop(context, {
                      'field1': controller1.text.trim(),
                      'field2': controller2.text.trim(),
                    });
                  }
                },
                child: Text(confirmText),
              ),
            ],
          ),
    );
  }

  return showDialog<Map<String, String>>(
    context: context,
    builder:
        (context) => AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller1,
                decoration: InputDecoration(
                  labelText: field1Label,
                  hintText: field1Hint,
                ),
                autofocus: true,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller2,
                decoration: InputDecoration(
                  labelText: field2Label,
                  hintText: field2Hint,
                ),
                maxLines: field2MaxLines ?? 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(cancelText),
            ),
            FilledButton(
              onPressed: () {
                if (controller1.text.trim().isNotEmpty &&
                    controller2.text.trim().isNotEmpty) {
                  Navigator.pop(context, {
                    'field1': controller1.text.trim(),
                    'field2': controller2.text.trim(),
                  });
                }
              },
              child: Text(confirmText),
            ),
          ],
        ),
  );
}

/// Shows an adaptive information dialog (no cancel button)
Future<void> showAdaptiveInfoDialog({
  required BuildContext context,
  required String title,
  required Widget content,
  required String buttonText,
}) {
  if (PlatformUtils.useCupertino) {
    return showCupertinoDialog(
      context: context,
      builder:
          (context) => CupertinoAlertDialog(
            title: Text(title),
            content: content,
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () => Navigator.pop(context),
                child: Text(buttonText),
              ),
            ],
          ),
    );
  }

  return showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: Text(title),
          content: content,
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: Text(buttonText),
            ),
          ],
        ),
  );
}
