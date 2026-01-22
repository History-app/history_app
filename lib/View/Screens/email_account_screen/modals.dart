part of './email_account_screen.dart';

class _DeleteAccountModal extends HookConsumerWidget {
  const _DeleteAccountModal();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDeleteAccountCheck = ref.watch(
      emailAccountViewModelProvider.select((state) => state.isDeleteAccountCheck),
    );
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(10),
      child: Container(
        width: double.infinity,
        height: 274,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColor.white),
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Text(
              Strings.accountDeletedModalTitle,
              style: TextStyle(
                fontSize: 20,
                color: Colors.deepOrangeAccent.withValues(alpha: 0.89),
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(top: 32, bottom: 14),
              child: Text(Strings.delete, textAlign: TextAlign.center),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  activeColor: const Color.fromARGB(255, 203, 201, 201).withValues(alpha: 0.89),
                  value: isDeleteAccountCheck,
                  onChanged: (value) => ref
                      .read(emailAccountViewModelProvider.notifier)
                      .setIsDeleteAccountCheck(value: value),
                ),
                Text(Strings.accountDeleteModalCheck),
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 14)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    ref
                        .read(emailAccountViewModelProvider.notifier)
                        .setIsDeleteAccountCheck(value: false);
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: 150,
                    height: 51,
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      border: Border.all(color: AppColor.gray.shade300),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      Strings.cancel,
                      style: TextStyle(
                        color: AppColor.gray.shade400,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    if (isDeleteAccountCheck) {
                      Navigator.of(context).pop();
                      await showDialog<dynamic>(
                        context: context,
                        builder: (_) => DeletedAccountLoadingModal(),
                      );
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: 150,
                    height: 51,
                    decoration: BoxDecoration(
                      color: isDeleteAccountCheck
                          ? Colors.deepOrangeAccent.withValues(alpha: 0.89)
                          : AppColor.gray.shade300,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      Strings.delete,
                      style: const TextStyle(
                        color: AppColor.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NotExistsUserModal extends HookConsumerWidget {
  const _NotExistsUserModal();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(10),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColor.white),
        padding: const EdgeInsets.only(top: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "未登録のメールアドレスです",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColor.black),
            ),
            const Padding(padding: EdgeInsets.only(top: 15)),
            const Text(
              "初めての方は「アカウント登録せずに始める」を選択後\n設定画面からアカウントを登録できます。",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SecondaryButton(
                width: double.infinity,
                height: 55,
                text: "トップに戻る",
                onPressed: () async {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ),
            const Gap(20),
          ],
        ),
      ),
    );
  }
}
