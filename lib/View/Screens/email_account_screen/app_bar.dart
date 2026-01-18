part of './email_account_screen.dart';

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar({required this.activeType, required this.isSended, required this.onPressed});

  final EmailAccountActiveType activeType;
  final bool isSended;
  final VoidCallback onPressed;

  static const _headerHeight = 70.0;

  @override
  Size get preferredSize => const Size.fromHeight(_headerHeight);

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;

    String appBarTextWithActiveType(BuildContext context, EmailAccountActiveType value) {
      switch (value) {
        case EmailAccountActiveType.signUp:
          return Strings.registerNewAccountLabel;
        case EmailAccountActiveType.signIn:
          return Strings.loginText;
        case EmailAccountActiveType.updateEmail:
          return 'メールアドレス登録';
        case EmailAccountActiveType.delete:
          return Strings.mailAppBarDelete;
      }
    }

    final isSendText = Strings.mailAppBarSended;

    return Container(
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(color: AppColors().preGrey, blurRadius: 1, offset: const Offset(0, 1)),
        ],
        color: Colors.white,
      ),
      height: _headerHeight + padding.top,
      child: Padding(
        padding: EdgeInsets.only(top: padding.top),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 20),
            SizedBox(
              height: 44,
              width: 44,
              child: GestureDetector(
                onTap: onPressed,
                behavior: HitTestBehavior.opaque,
                child: Icon(Icons.chevron_left, size: 32, color: AppColors().primaryRed),
              ),
            ),
            const SizedBox(width: 18.5),
            Text(
              isSended ? isSendText : appBarTextWithActiveType(context, activeType),
              style: TextStyle(
                color: AppColors().primaryRed,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            const SizedBox(width: 27.5),
          ],
        ),
      ),
    );
  }
}
