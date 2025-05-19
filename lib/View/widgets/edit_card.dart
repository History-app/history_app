part of '../screens/studying_screen.dart';

class EditCard extends ConsumerStatefulWidget {
  final String? question;
  final String? answer;
  final String? memo;
  final String cardId;
  final VoidCallback? onTap;

  const EditCard({
    super.key,
    this.question,
    this.answer,
    this.memo,
    required this.cardId,
    this.onTap,
  });

  @override
  ConsumerState<EditCard> createState() => _EditCardState();
}

class _EditCardState extends ConsumerState<EditCard> {
  // メモ編集用の状態変数
  late TextEditingController _memoController;
  bool _isEditingMemo = false;
  final FocusNode _memoFocusNode = FocusNode();
  //元のメモを保持する変数
  late String _originalMemo;

  // メモが変更されたかチェックするメソッド
  bool _isMemoChanged() {
    return _memoController.text != _originalMemo;
  }

  Future<bool> _showConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            // Dialog/AlertDialogを使わず、直接UnconstrainedBoxを返す
            return UnconstrainedBox(
              child: Container(
                width: 360, // ここで幅を固定
                padding: const EdgeInsets.fromLTRB(24, 30, 24, 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x80374142), // 半透明のグレー
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
                      '変更を破棄しますか？',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
// ボタンをRowで並べる
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 編集を続けるボタン
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(false),
                          child: Container(
                            width: 150,
                            height: 51,
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 24),
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
                    // ボタンをRowで並べる
                  ],
                ),
              ),
            );
          },
        ) ??
        false;
  }

// 戻るボタンの処理を変更
  void _handleBackButton() async {
    // 編集中ならキーボードを閉じる
    if (_isEditingMemo) {
      setState(() {
        _isEditingMemo = false;
      });
      FocusScope.of(context).unfocus();
      return; // 編集モードを終了するだけで戻らない
    }

    // メモが変更されている場合
    if (_isMemoChanged()) {
      final shouldDiscard = await _showConfirmationDialog();
      if (!shouldDiscard) {
        return; // キャンセルされた場合は戻らない
      }
    }

    // 変更がないか、破棄が確認された場合は戻る
    Navigator.pop(context);
  }

  // _EditCardState クラスに追加
  KeyboardActionsConfig _buildKeyboardActionsConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.IOS,
      keyboardBarColor: Colors.grey[200],
      nextFocus: false,
      actions: [
        KeyboardActionsItem(
          focusNode: _memoFocusNode,
          toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _isEditingMemo = false;
                  });

                  print('メモが保存されました: ${_memoController.text}');
                  node.unfocus(); // キーボードを閉じる
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    "完了",
                    style: TextStyle(
                      color: AppColors().primaryRed,
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

  @override
  void initState() {
    super.initState();
    // 初期値を保存（比較用）
    _originalMemo = widget.memo ?? '';
    _memoController = TextEditingController(text: _originalMemo);
  }

  @override
  void dispose() {
    _memoController.dispose();
    _memoFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(
        title: '編集',
        leadingIconPath: 'assets/arrow_back_ios.svg',
        actionIconPath: 'assets/保存.svg',
        onActionPressed: () {
          final memo = _memoController.text;
          ref.read(cardsDataNotifierProvider.notifier).saveMemo(
                cardId: widget.cardId,
                memo: memo,
              );

          print('保存ボタンが押されました: メモ=${_memoController.text}');

          Navigator.pop(context);
        },
        onLeadingPressed: _handleBackButton
        // Navigator.pop(context);
        ,
      ),
      body: KeyboardActions(
        config: _buildKeyboardActionsConfig(context),
        child: SingleChildScrollView(
            child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    // 問題文セクション（変更なし）
                    Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 23,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '問題文',
                              style: AppTextStyles.sfProSemibold24.copyWith(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Gap(8),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: 347.0,
                                minHeight: 67.0,
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 10,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColors().grey,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(3.0),
                                ),
                                child: widget.question != null
                                    ? Text(
                                        widget.question!,
                                        style: AppTextStyles.notoSansDisplay
                                            .copyWith(
                                          fontSize: 20,
                                          color: Colors.black87,
                                        ),
                                      )
                                    : null,
                              ),
                            )
                          ],
                        )),

                    // 答えセクション（変更なし）
                    Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 23,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '答え',
                              style: AppTextStyles.sfProSemibold24.copyWith(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Gap(8),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: 347.0,
                                minHeight: 67.0,
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 10,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColors().grey,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(3.0),
                                ),
                                child: widget.answer != null
                                    ? Text(
                                        widget.answer!,
                                        style: AppTextStyles.notoSansDisplay
                                            .copyWith(
                                          fontSize: 20,
                                          color: Colors.black87,
                                        ),
                                      )
                                    : null,
                              ),
                            )
                          ],
                        )),

                    // メモセクション（編集可能に変更）
                    Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 23,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'メモ',
                              style: AppTextStyles.sfProSemibold24.copyWith(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Gap(8),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: 347.0,
                                minHeight: 67.0,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  // タップ時に編集モードに切り替え
                                  setState(() {
                                    _isEditingMemo = true;
                                  });
                                  // キーボードを表示
                                  Future.delayed(Duration(milliseconds: 50),
                                      () {
                                    FocusScope.of(context)
                                        .requestFocus(_memoFocusNode);
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppColors().grey,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(3.0),
                                  ),
                                  child: _isEditingMemo
                                      ? TextField(
                                          controller: _memoController,
                                          focusNode: _memoFocusNode,
                                          maxLines: null,
                                          style: AppTextStyles.notoSansDisplay
                                              .copyWith(
                                            fontSize: 20,
                                            color: Colors.black87,
                                          ),
                                          onSubmitted: (text) {
                                            // 入力完了時の処理
                                            setState(() {
                                              _isEditingMemo =
                                                  false; // 編集モードを終了
                                            });
                                            print('メモが保存されました: $text');
                                            // キーボードを閉じる
                                            FocusScope.of(context).unfocus();
                                          },
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'メモを入力...',
                                            contentPadding:
                                                EdgeInsets.zero, // パディングを0に設定
                                            isDense: true, // より密集したレイアウト
                                            hintStyle: AppTextStyles
                                                .notoSansDisplay
                                                .copyWith(
                                              fontSize: 20,
                                              color: Colors.black38,
                                            ),
                                          ),
                                        )
                                      // 通常時はテキスト表示
                                      : Text(
                                          _memoController.text.isNotEmpty
                                              ? _memoController.text
                                              : 'タップしてメモを入力',
                                          style: AppTextStyles.notoSansDisplay
                                              .copyWith(
                                            fontSize: 20,
                                            color:
                                                _memoController.text.isNotEmpty
                                                    ? Colors.black87
                                                    : Colors.black38,
                                          ),
                                        ),
                                ),
                              ),
                            )
                          ],
                        )),
                  ],
                ))),
      ),
    );
  }
}
