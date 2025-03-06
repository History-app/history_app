import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../ViewModel/bottom_nav_notifier.dart'; // bottomNavProvider を含む
import 'package:flutter_svg/flutter_svg.dart';
import'../Model/Color/app_colors.dart';
class BottomNavView extends ConsumerWidget {
  const BottomNavView({Key? key}) : super(key: key);

  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 現在のタブのインデックスを取得
    final state = ref.watch(bottomNavProvider);

    return Scaffold(
  body: _getBody(state.selectedIndex),
  bottomNavigationBar: Theme(
    data: Theme.of(context).copyWith(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
    ),
    child: BottomNavigationBar(
 
      selectedItemColor: AppColors().primaryRed,
      unselectedItemColor: AppColors().grey,
      
      

  
  // その他のプロパティ
      enableFeedback: false,
      type: BottomNavigationBarType.fixed,
      selectedFontSize:11.0,
      unselectedFontSize:11.0,
      currentIndex: state.selectedIndex,
      onTap: (index) {
        ref.read(bottomNavProvider.notifier).updateIndex(index);
      },
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset('assets/Mask.svg',
          color: state.selectedIndex == 0 ? AppColors().primaryRed : AppColors().grey,),
          label: "ホーム",
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset('assets/data.svg',
          color: state.selectedIndex == 1 ? AppColors().primaryRed : AppColors().grey,),
          label: "データ",
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset('assets/tab_usericon.svg',
          color: state.selectedIndex == 2 ? AppColors().primaryRed : AppColors().grey,),
          label: "プロフィール",
        ),
      ],
    ),
  ),
);

  }

  // 選択されたインデックスに応じたウィジェットを返す
  Widget _getBody(int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return Center(child: Text("ホーム画面"));
      case 1:
        return Center(child: Text("検索画面"));
      case 2:
        return Center(child: Text("プロフィール画面"));
      default:
        return Center(child: Text("未定義の画面"));
    }
  }
}
