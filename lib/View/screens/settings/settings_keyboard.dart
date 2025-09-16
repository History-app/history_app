part of 'settings.dart';

KeyboardActionsConfig _buildKeyboardActionsConfig(
  FocusNode focusNode,
  TextEditingController controller,
  BuildContext context,
  WidgetRef ref,
  int fallbackNullCount,
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
                final newCount = int.tryParse(controller.text);
                print('newcount, $newCount');
                await notifier.updateTodayCard(newCount);

                node.unfocus();
                Navigator.pop(context);
                await notifier.updateNullCount(newCount);
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  '完了',
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
  int originalNullCount,
) async {
  final isTextChanged = controller.text != originalNullCount.toString();

  if (isTextChanged) {
    final shouldDiscard = await _showConfirmationDialog(context);
    if (!shouldDiscard) return;

    controller.clear();
  }

  Navigator.pop(context);
}
