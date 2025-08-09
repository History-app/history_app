import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import '../../Model/widgets/common_app_bar.dart';
import '../../ViewModel/settings/settings.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(settingsNotifierProvider);
    final TextEditingController _controller =
        TextEditingController(text: user.nullCount.toString());
    final nullCount = user.nullCount;
    final FocusNode _focusNode = FocusNode();

    bool _isTextChanged() => _controller.text != user.nullCount.toString();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
    Future<bool> _showConfirmationDialog() async {
      return await showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return UnconstrainedBox(
                child: Container(
                  width: 360,
                  padding: const EdgeInsets.fromLTRB(24, 30, 24, 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x80374142),
                        offset: Offset(0, 4),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        '変更を破棄しますか？',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(false),
                            child: Container(
                              width: 150,
                              height: 51,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                '編集を続ける',
                                style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(true),
                            child: Container(
                              width: 150,
                              height: 51,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                '破棄',
                                style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ) ??
          false;
    }

    void _handleBackButton() async {
      if (_isTextChanged()) {
        final shouldDiscard = await _showConfirmationDialog();
        if (!shouldDiscard) return;

        _controller.clear();
      }

      Navigator.pop(context);
    }

    KeyboardActionsConfig _buildKeyboardActionsConfig() {
      return KeyboardActionsConfig(
        keyboardBarColor: Colors.grey[200],
        actions: [
          KeyboardActionsItem(
            focusNode: _focusNode,
            toolbarButtons: [
              (node) {
                return GestureDetector(
                  onTap: () async {
                    final notifier =
                        ref.read(settingsNotifierProvider.notifier);
                    final newCount =
                        int.tryParse(_controller.text) ?? nullCount;
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(
        title: '設定',
        leadingIconPath: 'assets/arrow_back_ios.svg',
        onLeadingPressed: _handleBackButton,
      ),
      body: SizedBox(
        height: 103,
        child: KeyboardActions(
          config: _buildKeyboardActionsConfig(),
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(24),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '一日の新規学習カード',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    width: 50,
                    height: 36,
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.blue, fontSize: 16),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
