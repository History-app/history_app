part of 'settings.dart';

KeyboardActionsConfig _buildKeyboardActionsConfig(
  FocusNode focusNode,
  TextEditingController controller,
  BuildContext context,
  WidgetRef ref,
  // int fallbackNullCount,
) {
  return KeyboardActionsConfig(
    keyboardBarColor: Colors.grey[200],
    actions: [
      KeyboardActionsItem(
        focusNode: focusNode,
        toolbarButtons: [
          (node) {
            return GestureDetector(
              onTap: () async {
                final notifier = ref.read(settingsNotifierProvider.notifier);
                final controllerText = int.parse(controller.text);

                await notifier.updateTodayCard(controllerText);
                node.unfocus();

                await notifier.updateNullCount(controllerText);
                Navigator.pop(context);
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  Strings.completedLabel,
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            );
          }
        ],
      ),
    ],
  );
}

void _handleBackButton(
  BuildContext context,
  TextEditingController controller,
  int originalNullCount, {
  TextEditingController? eraController,
  String? originalEra,
}) async {
  final isCountChanged = controller.text != originalNullCount.toString();
  final isEraChanged =
      eraController != null && originalEra != null && eraController.text != originalEra;
  if (isCountChanged || isEraChanged) {
    final shouldDiscard = await _showConfirmationDialog(context);
    if (!shouldDiscard) return;

    if (isCountChanged) controller.clear();
    if (isEraChanged) eraController.clear();
  }

  Navigator.pop(context);
}
