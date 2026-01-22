import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../ViewModel/bottom_nav_notifier.dart'; // bottomNavProvider を含む
import 'package:flutter_svg/flutter_svg.dart';
import '../Model/Color/app_colors.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'package:japanese_history_app/constant/app_strings.dart';
import 'screens/data.dart';

class BottomNavView extends ConsumerWidget {
  const BottomNavView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 現在のタブのインデックスを取得
    final state = ref.watch(bottomNavProvider);

    // 一度だけインスタンスを作るように保持
    final List<Widget> screens = [HomeScreen(), DataScreen(), ProfileScreen()];

    return Scaffold(
      body: IndexedStack(index: state.selectedIndex, children: screens),
      bottomNavigationBar: Theme(
        data: Theme.of(
          context,
        ).copyWith(splashColor: Colors.transparent, highlightColor: Colors.transparent),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Divider(height: 0.5, thickness: 0.5, color: AppColors().grey),
            BottomNavigationBar(
              selectedItemColor: AppColors().primaryRed,
              unselectedItemColor: AppColors().grey,
              backgroundColor: Colors.white,

              // その他のプロパティ
              enableFeedback: false,
              type: BottomNavigationBarType.fixed,
              selectedFontSize: 11.0,
              unselectedFontSize: 11.0,
              currentIndex: state.selectedIndex,
              onTap: (index) {
                ref.read(bottomNavProvider.notifier).updateIndex(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: SizedBox(
                    width: 40,
                    height: 40,
                    child: Icon(
                      Icons.home,
                      size: 32,
                      color: state.selectedIndex == 0 ? AppColors().primaryRed : AppColors().grey,
                    ),
                  ),
                  label: Strings.home,
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/data.svg',
                    color: state.selectedIndex == 1 ? AppColors().primaryRed : AppColors().grey,
                  ),
                  label: Strings.data,
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/tab_usericon.svg',
                    color: state.selectedIndex == 2 ? AppColors().primaryRed : AppColors().grey,
                  ),
                  label: Strings.profile,
                ),
              ],
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
        return HomeScreen();
      case 1:
        return DataScreen();
      case 2:
        return ProfileScreen();
      default:
        return Center(child: Text("未定義の画面"));
    }
  }
}
