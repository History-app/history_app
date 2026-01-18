import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import '../../../Model/widgets/common_app_bar.dart';
import 'package:japanese_history_app/Model/Color/app_colors.dart';
import 'package:japanese_history_app/Model/ era/ eras.dart';
import 'package:japanese_history_app/constant/app_strings.dart';
import '../../../ViewModel/settings/settings.dart';
import '../../../providers/user_provider.dart';
import 'package:flutter/cupertino.dart';

part 'settings_modal.dart';
part 'settings_keyboard.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

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

    _eraController = TextEditingController();

    _countController = TextEditingController(text: "");
    ref.read(settingsNotifierProvider);
    _countFocusNode = FocusNode();
    _eraFocusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _countFocusNode.requestFocus();
      final user = ref.read(userModelProvider);
      if (mounted) _countController.text = user.nullCount.toString();
      if (mounted) _eraController.text = user.startEra;
      print('コレが新時代');
      print(_eraController.text);
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
    final user = ref.watch(settingsNotifierProvider);
    if (mounted) _eraController.text = user.startEra;
    final nullCount = user.nullCount;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(
        icon: SizedBox(
          width: 40,
          height: 40,
          child: IconButton(
            icon: Icon(Icons.chevron_left, size: 32, color: AppColors().primaryRed),
            onPressed: () {
              _handleBackButton(
                context,
                _countController,
                nullCount,
                eraController: _eraController,
                originalEra: _eraController.text,
              );
            },
          ),
        ),
        title: '設定',
      ),
      body: Column(
        children: [
          SizedBox(
            height: 103,
            child: KeyboardActions(
              config: _buildKeyboardActionsConfig(_countFocusNode, _countController, context, ref),
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(24),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(Strings.dailyNewLearningCards, style: TextStyle(fontSize: 16)),
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
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(24),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(Strings.newCardEra, style: TextStyle(fontSize: 16)),
                    SizedBox(
                      width: 80,
                      height: 36,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () async {
                          final eras = kEras;
                          final currentValue = _eraController.text.isNotEmpty
                              ? _eraController.text
                              : eras[0];
                          int selectedIndex = eras.indexOf(currentValue);
                          final result = await showCupertinoModalPopup<String>(
                            context: context,
                            builder: (ctx) {
                              int tempIndex = selectedIndex;
                              return Container(
                                color: Colors.white,
                                height: 280,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 6,
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          CupertinoButton(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
                                            onPressed: () async {
                                              final chosen = eras[tempIndex];
                                              await ref
                                                  .read(settingsNotifierProvider.notifier)
                                                  .updateStartEra(chosen);
                                              final notifier = ref.read(
                                                settingsNotifierProvider.notifier,
                                              );
                                              await notifier.updateTodaysEra(
                                                int.parse(_countController.text),
                                              );
                                              Navigator.of(ctx).pop(chosen);
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              Strings.completedLabel,
                                              style: TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: CupertinoPicker(
                                        itemExtent: 32,
                                        scrollController: FixedExtentScrollController(
                                          initialItem: selectedIndex,
                                        ),
                                        onSelectedItemChanged: (i) => tempIndex = i,
                                        children: eras.map((e) => Center(child: Text(e))).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );

                          if (result != null) {
                            _eraController.text = result;
                            setState(() {});
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _eraController.text,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.blue, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
