part of './email_account_screen.dart';

class _EmailInputArea extends StatelessWidget {
  const _EmailInputArea({
    required this.activeType,
    required this.validator,
    required this.onChanged,
    required this.initialValue,
    required this.emailTextEditingController,
    required this.formKey,
    required this.focusNode,
  });

  final EmailAccountActiveType activeType;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String> onChanged;
  final String initialValue;
  final TextEditingController emailTextEditingController;
  final GlobalKey<FormState> formKey;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(getInputDescText(context, activeType), style: const TextStyle(fontSize: 14)),
        const Padding(padding: EdgeInsets.only(top: 27)),
        Text(getMailInputFormTitle(context, activeType), style: const TextStyle(fontSize: 14)),
        const Padding(padding: EdgeInsets.only(top: 6)),
        Theme(
          data: Theme.of(context).copyWith(
            textSelectionTheme: TextSelectionThemeData(
              selectionColor: Theme.of(context).primaryColor.withValues(alpha: 0.5),
              selectionHandleColor: Theme.of(context).primaryColor,
              cursorColor: Theme.of(context).primaryColor,
            ),
            cupertinoOverrideTheme: CupertinoThemeData(
              primaryColor: Theme.of(context).primaryColor,
            ),
          ),
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: TextFormField(
              focusNode: focusNode,
              initialValue: initialValue,
              validator: validator,
              onChanged: onChanged,
              keyboardType: TextInputType.emailAddress,
              minLines: null,
              maxLines: 1,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xffF8FAFA),
                hintMaxLines: null,
                hintText: 'example@email.com',
                contentPadding: const EdgeInsets.only(top: 14, left: 15, bottom: 14),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
              ),
              style: const TextStyle(fontSize: 16, color: Colors.black, height: 1.65),
              obscureText: false,
              cursorColor: Theme.of(context).primaryColor,
              selectionControls: CustomColorSelectionHandle(Theme.of(context).primaryColor),
            ),
          ),
        ),
      ],
    );
  }

  String getInputDescText(BuildContext context, EmailAccountActiveType value) {
    switch (value) {
      case EmailAccountActiveType.signUp:
      case EmailAccountActiveType.updateEmail:
        return Strings.mailSignUpText;
      case EmailAccountActiveType.signIn:
        return Strings.mailSignInText;

      case EmailAccountActiveType.delete:
        return Strings.mailDeleteText;
    }
  }

  String getMailInputFormTitle(BuildContext context, EmailAccountActiveType value) {
    switch (value) {
      case EmailAccountActiveType.signUp:
      case EmailAccountActiveType.updateEmail:
        return Strings.mailInputFormTItle;
      case EmailAccountActiveType.signIn:
        return "Stockrアカウントのメールアドレス";
      case EmailAccountActiveType.delete:
        return Strings.mailInputFormTItle;
    }
  }
}

class _SendMainArea extends StatelessWidget {
  const _SendMainArea({required this.emailText});
  final String emailText;

  @override
  Widget build(BuildContext context) {
    const double verticalPadding = 28;
    const double horizontalPadding = 12;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        // color: AppColor.background,
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: verticalPadding),
          Text(
            emailText,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            Strings.mailSendedTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 14),
          const Text(
            'メール内のURLから\nブラウザアプリ(ChromeまたはSafari)で\n開いてください。',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, height: 1.65),
          ),
          const SizedBox(height: 14),
          const Text(
            'メールが見当たらない場合、\n迷惑メールフォルダに振り分けられている\n可能性がありますので、ご確認ください。',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, height: 1.65),
          ),
          const SizedBox(height: verticalPadding),
        ],
      ),
    );
  }
}
