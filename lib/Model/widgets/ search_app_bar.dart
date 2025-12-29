import 'package:flutter/material.dart';
import '../color/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:japanese_history_app/constant/app_strings.dart';

// StatelessWidgetからStatefulWidgetに変更
class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  final TextEditingController controller;
  final VoidCallback? onBackPressed;

  const SearchAppBar({
    super.key,
    required this.controller,
    this.onBackPressed,
  });

  @override
  State<SearchAppBar> createState() => _SearchAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 0.5);
}

class _SearchAppBarState extends State<SearchAppBar> {
  // 元のテキストを保持する変数
  late String _originalText;

  @override
  void initState() {
    super.initState();
    _originalText = widget.controller.text;
  }

  // テキストが変更されたかチェックするメソッド
  bool _isTextChanged() {
    return widget.controller.text != _originalText;
  }

  // 確認ダイアログを表示するメソッド
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
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      Strings.confirmDiscardSearch,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors().primaryRed,
                        decoration: TextDecoration.none,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 編集を続けるボタン
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
                            child: Text(
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
                        // 破棄するボタン
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(true),
                          child: Container(
                            width: 150,
                            height: 51,
                            decoration: BoxDecoration(
                              color: AppColors().primaryRed,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
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

  // 戻るボタンの処理
  void _handleBackButton() async {
    // テキストが変更されている場合
    if (_isTextChanged()) {
      final shouldDiscard = await _showConfirmationDialog();
      if (!shouldDiscard) {
        return; // キャンセルされた場合は戻らない
      }
      widget.controller.clear();
    }

    // 変更がないか、破棄が確認された場合は戻る
    if (widget.onBackPressed != null) {
      widget.onBackPressed!();
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: SvgPicture.asset(
          'assets/arrow_back_ios.svg',
          width: 24,
          height: 24,
        ),
        onPressed: _handleBackButton,
      ),
      title: Container(
        height: 32,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: TextField(
            controller: widget.controller,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'キーワードを入力',
              hintStyle: TextStyle(color: Colors.grey),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey,
                size: 20,
              ),
              prefixIconConstraints: BoxConstraints(
                minWidth: 32,
                minHeight: 32,
              ),
            ),
          ),
        ),
      ),
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0.5),
        child: Container(
          color: AppColors().grey,
          height: 0.5,
        ),
      ),
    );
  }
}
