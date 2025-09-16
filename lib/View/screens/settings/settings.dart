import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import '../../../Model/widgets/common_app_bar.dart';
import '../../../ViewModel/settings/settings.dart';

part 'settings_modal.dart';
part 'settings_keyboard.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late TextEditingController _countController;
  late TextEditingController _eraController;
  late FocusNode _countFocusNode;
  late FocusNode _eraFocusNode;

  @override
  void initState() {
    super.initState();
    _eraController = TextEditingController(text: "");
    final initialNullCount = ref.read(settingsNotifierProvider).nullCount;
    _countController = TextEditingController(text: initialNullCount.toString());
    _countFocusNode = FocusNode();
    _eraFocusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _countFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _countController.dispose();
    _eraController.dispose();
    _countFocusNode.dispose();
    _eraFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nullCount = ref.watch(settingsNotifierProvider).nullCount;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(
        title: '設定',
        leadingIconPath: 'assets/arrow_back_ios.svg',
        onLeadingPressed: () => _handleBackButton(
          context,
          _countController,
          nullCount,
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 103,
            child: KeyboardActions(
              config: _buildKeyboardActionsConfig(
                _countFocusNode,
                _countController,
                context,
                ref,
                nullCount,
              ),
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
                          controller: _countController,
                          focusNode: _countFocusNode,
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
          SizedBox(
            height: 103,
            child: KeyboardActions(
              config: _buildKeyboardActionsConfig(
                _eraFocusNode,
                _eraController,
                context,
                ref,
                nullCount,
              ),
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
                        '新規カードの時代',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(
                        width: 50,
                        height: 36,
                        child: TextField(
                          controller: _eraController,
                          focusNode: _eraFocusNode,
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
        ],
      ),
    );
  }
}
