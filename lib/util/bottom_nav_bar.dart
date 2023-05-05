import 'package:flutter/material.dart';

import 'navbar_item.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({
    Key? key,
    required this.onItemSelected,
  }) : super(key: key);

  final ValueChanged<int> onItemSelected;

  @override
  State createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  var selectedIndex = 0;

  void handleItemSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
    widget.onItemSelected(index);
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return Card(
      color: (brightness == Brightness.light) ? Colors.white : null,
      elevation: 1,
      margin: const EdgeInsets.all(0),
      child: SafeArea(
        top: false,
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.only(top: 16, left: 8, right: 8, bottom: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              NavigationBarItem(
                index: 0,
                icon: Icons.home_outlined,
                selectedIcon: Icons.home,
                isSelected: (selectedIndex == 0),
                onTap: handleItemSelected,
              ),
              NavigationBarItem(
                index: 1,
                icon: Icons.search,
                selectedIcon: Icons.search_outlined,
                isSelected: (selectedIndex == 1),
                onTap: handleItemSelected,
              ),
              NavigationBarItem(
                index: 2,
                icon: Icons.mic_outlined,
                selectedIcon: Icons.mic,
                isSelected: (selectedIndex == 2),
                onTap: handleItemSelected,
              ),
              NavigationBarItem(
                index: 3,
                icon: Icons.notifications_outlined,
                selectedIcon: Icons.notifications,
                isSelected: (selectedIndex == 3),
                onTap: handleItemSelected,
              ),
              NavigationBarItem(
                index: 4,
                icon: Icons.email_outlined,
                selectedIcon: Icons.email,
                isSelected: (selectedIndex == 4),
                onTap: handleItemSelected,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
