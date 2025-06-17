import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_document/config/app_constant.dart';
import 'package:med_document/provider/dashboard_provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Scaffold(
        body: Consumer(
          builder: (_, ref, __) {
            final int navIndex = ref.watch(dashboardProvider);
            return AppConstant.dashboardMenu[navIndex]['route'] as Widget;
          },
        ),
        bottomNavigationBar: SafeArea(
          child: Consumer(
            builder: (_, ref, __) {
              int navIndex = ref.watch(dashboardProvider);
              return Container(
                child: BottomNavigationBar(
                  items:
                      AppConstant.dashboardMenu
                          .map(
                            (e) => BottomNavigationBarItem(
                              icon: Icon(e['icon'] as IconData),
                              label: e['title'] as String,
                            ),
                          )
                          .toList(),
                  currentIndex: navIndex,
                  onTap: (index) {
                    ref.read(dashboardProvider.notifier).state = index;
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
