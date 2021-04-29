import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:tk8/config/app_config.dart';
import 'package:tk8/config/styles.config.dart';
import 'package:tk8/services/services.dart';
import 'package:tk8/ui/screens/academy/academy.screen.dart';
import 'package:tk8/ui/screens/debug/debug.screen.dart';
import 'package:tk8/ui/screens/home_stream/home_stream.screen.dart';
import 'package:tk8/ui/screens/profile/me/view/my_profile.screen.dart';
import 'package:tk8/ui/widgets/widgets.dart';

const _tabs = [
  AppTab.home,
  AppTab.categories,
  AppTab.profile,
  AppTab.debug,
];

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  final _appConfig = getIt<AppConfig>();
  final _navigator = getIt<NavigationService>();
  int _selectedIndex = 0;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _appConfig.showDebugScreen ? 4 : 3,
      vsync: this,
    );
    _tabController.addListener(() {
      setState(() => _selectedIndex = _tabController.index);
      _navigator.setActiveTab(_tabs[_selectedIndex]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomeStreamScreen(),
          const AcademyScreen(),
          const MyProfileScreen(),
          if (_appConfig.showDebugScreen) DebugScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: TK8Colors.white,
          boxShadow: [
            BoxShadow(color: TK8Colors.grey.withOpacity(0.3), blurRadius: 10),
          ],
        ),
        child: SafeArea(
          child: TabBar(
            controller: _tabController,
            indicator: const LabelTagBackgroundDecoration(
              color: TK8Colors.ocean,
              insets: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 70.0),
            ),
            labelColor: TK8Colors.black,
            unselectedLabelColor: TK8Colors.grey,
            labelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontFamily: "Gotham",
                fontStyle: FontStyle.normal,
                fontSize: 12.0),
            tabs: [
              Tab(
                  icon: _svgIcon('iconHome', _selectedIndex == 0),
                  text: translate('screens.main.tabs.home.title'),
                  iconMargin: const EdgeInsets.only(bottom: 8.0)),
              Tab(
                  icon: _svgIcon('iconFootball', _selectedIndex == 1),
                  text: translate('screens.main.tabs.academy.title'),
                  iconMargin: const EdgeInsets.only(bottom: 8.0)),
              Tab(
                  icon: _svgIcon('iconUser', _selectedIndex == 2),
                  text: translate('screens.main.tabs.profile.title'),
                  iconMargin: const EdgeInsets.only(bottom: 8.0)),
              if (_appConfig.showDebugScreen)
                const Tab(
                    icon: Icon(Icons.bug_report),
                    text: "Debug",
                    iconMargin: EdgeInsets.only(bottom: 4.0)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _svgIcon(String iconName, bool isActive) {
    return SvgPicture.asset(
      'assets/svg/$iconName.svg',
      height: 20,
      width: 20,
      color: isActive ? TK8Colors.black : TK8Colors.grey,
    );
  }
}
