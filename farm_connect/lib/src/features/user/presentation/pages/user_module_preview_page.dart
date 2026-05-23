import 'package:farm_connect/src/core/common_widgets/app_shell_controls.dart';
import 'package:farm_connect/src/core/theme/app_theme.dart';
import 'package:farm_connect/src/core/theme/app_theme_controller.dart';
import 'package:farm_connect/src/core/theme/app_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class UserModulePreviewPage extends ConsumerStatefulWidget {
  const UserModulePreviewPage({super.key});

  @override
  ConsumerState<UserModulePreviewPage> createState() =>
      _UserModulePreviewPageState();
}

class _UserModulePreviewPageState extends ConsumerState<UserModulePreviewPage> {
  int selectedTab = 0;

  static const _tabs = <_PreviewTab>[
    _PreviewTab(label: 'Auth', icon: Icons.lock_rounded),
    _PreviewTab(label: 'Home', icon: Icons.chat_bubble_rounded),
    _PreviewTab(label: 'Workers', icon: Icons.groups_2_rounded),
    _PreviewTab(label: 'Jobs', icon: Icons.add_box_rounded),
    _PreviewTab(label: 'Profile', icon: Icons.person_rounded),
    _PreviewTab(label: 'Settings', icon: Icons.settings_rounded),
  ];

  static const _pages = <_PreviewRoute>[
    _PreviewRoute(
      title: 'Splash Screen',
      subtitle: 'Premium animated app launch experience',
      path: '/splash',
      icon: Icons.auto_awesome_rounded,
      tabIndex: 0,
      badge: 'Launch',
    ),
    _PreviewRoute(
      title: 'Login',
      subtitle: 'Role based email and password login screen',
      path: '/preview/auth/login',
      icon: Icons.login_rounded,
      tabIndex: 0,
      badge: 'Auth',
    ),
    _PreviewRoute(
      title: 'Signup',
      subtitle: 'Create farmer or worker account',
      path: '/preview/auth/signup',
      icon: Icons.person_add_rounded,
      tabIndex: 0,
      badge: 'New',
    ),
    _PreviewRoute(
      title: 'Forgot Password',
      subtitle: 'Request password reset email',
      path: '/preview/auth/forgot-password',
      icon: Icons.lock_reset_rounded,
      tabIndex: 0,
      badge: 'Help',
    ),
    _PreviewRoute(
      title: 'Reset Password',
      subtitle: 'Token based password reset form',
      path: '/preview/auth/reset-password',
      icon: Icons.password_rounded,
      tabIndex: 0,
      badge: 'Token',
    ),
    _PreviewRoute(
      title: 'Verify Email',
      subtitle: 'Email verification token screen',
      path: '/preview/auth/verify-email',
      icon: Icons.mark_email_read_rounded,
      tabIndex: 0,
      badge: 'Email',
    ),
    _PreviewRoute(
      title: 'Farmer Dashboard',
      subtitle: 'Main farmer workflow with action cards',
      path: '/farmer-dashboard',
      icon: Icons.dashboard_rounded,
      tabIndex: 1,
      badge: 'Home',
    ),
    _PreviewRoute(
      title: 'Active Workers',
      subtitle: 'Filter and browse available workers',
      path: '/active-users',
      icon: Icons.people_alt_rounded,
      tabIndex: 2,
      badge: 'Live',
    ),
    _PreviewRoute(
      title: 'Post Job',
      subtitle: 'Create a lightweight farm job post',
      path: '/post-job',
      icon: Icons.work_rounded,
      tabIndex: 3,
      badge: 'New',
    ),
    _PreviewRoute(
      title: 'Manage Jobs',
      subtitle: 'Track active, past and upcoming jobs',
      path: '/manage-jobs',
      icon: Icons.list_alt_rounded,
      tabIndex: 3,
      badge: 'Board',
    ),
    _PreviewRoute(
      title: 'Profile Screen',
      subtitle: 'Completion, details and role profile access',
      path: '/profile',
      icon: Icons.person_rounded,
      tabIndex: 4,
      badge: 'Me',
    ),
    _PreviewRoute(
      title: 'Edit Profile',
      subtitle: 'Personal details, address, bio and language',
      path: '/profile/edit',
      icon: Icons.edit_rounded,
      tabIndex: 4,
      badge: 'Edit',
    ),
    _PreviewRoute(
      title: 'Worker Details',
      subtitle: 'Skills, wage, radius and availability',
      path: '/profile/worker',
      icon: Icons.engineering_rounded,
      tabIndex: 4,
      badge: 'Skill',
    ),
    _PreviewRoute(
      title: 'Farmer Details',
      subtitle: 'Farm type, land size and hiring preferences',
      path: '/profile/farmer',
      icon: Icons.agriculture_rounded,
      tabIndex: 4,
      badge: 'Farm',
    ),
    _PreviewRoute(
      title: 'Skill Selection',
      subtitle: 'Chip based worker skill picker',
      path: '/profile/worker/skills',
      icon: Icons.handyman_rounded,
      tabIndex: 4,
      badge: 'Pick',
    ),
    _PreviewRoute(
      title: 'Public Profile',
      subtitle: 'Profile preview with skill showcase',
      path: '/profile/public/preview-user',
      icon: Icons.badge_rounded,
      tabIndex: 4,
      badge: 'Public',
    ),
    _PreviewRoute(
      title: 'Settings',
      subtitle: 'Notification, privacy and logout controls',
      path: '/settings',
      icon: Icons.settings_rounded,
      tabIndex: 5,
      badge: 'Safe',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final lightMode = themeMode == ThemeMode.light;
    final desktopMode = ref.watch(desktopModeProvider);
    final palette = AppTheme.palette(context);
    final pages = _pages
        .where((page) => page.tabIndex == selectedTab)
        .toList(growable: false);

    return Scaffold(
      backgroundColor: palette.pageBackground,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: palette.outerGradient,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOutCubic,
              width: desktopMode ? double.infinity : 430,
              height: desktopMode ? double.infinity : 860,
              constraints: BoxConstraints(
                maxWidth: desktopMode ? 1180 : 430,
                maxHeight: desktopMode ? double.infinity : 860,
              ),
              margin: EdgeInsets.symmetric(
                horizontal: desktopMode ? 24 : 14,
                vertical: desktopMode ? 18 : 12,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(desktopMode ? 16 : 34),
                border: Border.all(
                  color: AppTheme.metallicGold.withValues(alpha: 0.48),
                  width: desktopMode ? 1 : 2,
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: palette.shellGradient,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.55),
                    blurRadius: 28,
                    offset: const Offset(0, 16),
                  ),
                  BoxShadow(
                    color: AppTheme.forestGreen.withValues(alpha: 0.20),
                    blurRadius: 42,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: _PreviewShell(
                iconUrl: AppTheme.appIconUrlFor(context),
                tabs: _tabs,
                pages: pages,
                selectedTab: selectedTab,
                desktopMode: desktopMode,
                lightMode: lightMode,
                palette: palette,
                onTabChanged: (index) => setState(() => selectedTab = index),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PreviewShell extends StatelessWidget {
  final String iconUrl;
  final List<_PreviewTab> tabs;
  final List<_PreviewRoute> pages;
  final int selectedTab;
  final bool desktopMode;
  final bool lightMode;
  final AppPalette palette;
  final ValueChanged<int> onTabChanged;

  const _PreviewShell({
    required this.iconUrl,
    required this.tabs,
    required this.pages,
    required this.selectedTab,
    required this.desktopMode,
    required this.lightMode,
    required this.palette,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _PreviewAppBar(
          iconUrl: iconUrl,
          lightMode: lightMode,
        ),
        _PreviewToggleBar(
          tabs: tabs,
          selectedTab: selectedTab,
          palette: palette,
          onChanged: onTabChanged,
        ),
        Expanded(
          child: desktopMode
              ? _DesktopPageGrid(pages: pages, palette: palette)
              : _MobilePageList(pages: pages, palette: palette),
        ),
        _PreviewBottomBar(
          tabs: tabs,
          selectedTab: selectedTab,
          palette: palette,
          onChanged: onTabChanged,
        ),
      ],
    );
  }
}

class _PreviewAppBar extends StatelessWidget {
  final String iconUrl;
  final bool lightMode;

  const _PreviewAppBar({
    required this.iconUrl,
    required this.lightMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 12, 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: lightMode
              ? [
                  const Color(0xFF8B6429),
                  AppTheme.earthBrown,
                  const Color(0xFFD8B46F),
                ]
              : [
                  AppTheme.forestGreen,
                  const Color(0xFF0B3B1A),
                  AppTheme.earthBrown.withValues(alpha: 0.88),
                ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.28),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFFFF6D0),
                  Color(0xFFB8842D),
                  Color(0xFFFFFFFF),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.28),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.network(
                iconUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const ColoredBox(
                  color: Colors.white,
                  child: Icon(Icons.eco_rounded, color: AppTheme.forestGreen),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'FarmConnect',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'User module preview',
                  style: TextStyle(
                    color: Color(0xFFE7F4DF),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.search_rounded,
            color: lightMode ? const Color(0xFF173F1D) : Colors.white,
          ),
          const SizedBox(width: 10),
          Icon(
            Icons.more_vert_rounded,
            color: lightMode ? const Color(0xFF173F1D) : Colors.white,
          ),
          const SizedBox(width: 8),
          const AppShellControls(),
        ],
      ),
    );
  }
}

class _PreviewToggleBar extends StatelessWidget {
  final List<_PreviewTab> tabs;
  final int selectedTab;
  final AppPalette palette;
  final ValueChanged<int> onChanged;

  const _PreviewToggleBar({
    required this.tabs,
    required this.selectedTab,
    required this.palette,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: palette.tabBackground,
        border: Border(bottom: BorderSide(color: palette.divider)),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final selected = selectedTab == index;
          return Expanded(
            child: InkWell(
              onTap: () => onChanged(index),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    tabs[index].label,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: selected
                          ? palette.primaryText
                          : palette.secondaryText,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 11),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: selected ? 38 : 0,
                    height: 3,
                    decoration: BoxDecoration(
                      color:
                          selected ? AppTheme.metallicGold : Colors.transparent,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _MobilePageList extends StatelessWidget {
  final List<_PreviewRoute> pages;
  final AppPalette palette;

  const _MobilePageList({
    required this.pages,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
      itemCount: pages.length,
      separatorBuilder: (_, __) => Divider(
        height: 1,
        indent: 76,
        color: palette.divider,
      ),
      itemBuilder: (context, index) {
        return _WhatsAppPageTile(page: pages[index], palette: palette);
      },
    );
  }
}

class _DesktopPageGrid extends StatelessWidget {
  final List<_PreviewRoute> pages;
  final AppPalette palette;

  const _DesktopPageGrid({
    required this.pages,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 360,
        mainAxisExtent: 116,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: pages.length,
      itemBuilder: (context, index) => _DesktopPageCard(
        page: pages[index],
        palette: palette,
      ),
    );
  }
}

class _WhatsAppPageTile extends StatelessWidget {
  final _PreviewRoute page;
  final AppPalette palette;

  const _WhatsAppPageTile({
    required this.page,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => context.push(page.path),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Row(
            children: [
              _MetallicAvatar(icon: page.icon, palette: palette),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            page.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: palette.primaryText,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Text(
                          page.badge,
                          style: const TextStyle(
                            color: Color(0xFFD7BE79),
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      page.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: palette.secondaryText,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DesktopPageCard extends StatelessWidget {
  final _PreviewRoute page;
  final AppPalette palette;

  const _DesktopPageCard({
    required this.page,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: palette.card,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => context.push(page.path),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.metallicGold.withValues(alpha: 0.42),
            ),
            gradient: LinearGradient(
              colors: [
                (palette.lightMode
                        ? const Color(0xFFFFE7B8)
                        : const Color(0xFFBEE8B1))
                    .withValues(alpha: palette.lightMode ? 0.42 : 0.06),
                AppTheme.forestGreen.withValues(alpha: 0.18),
                Colors.black.withValues(alpha: palette.lightMode ? 0.02 : 0.20),
              ],
            ),
          ),
          child: Row(
            children: [
              _MetallicAvatar(icon: page.icon, palette: palette),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      page.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: palette.primaryText,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      page.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: palette.secondaryText,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetallicAvatar extends StatelessWidget {
  final IconData icon;
  final AppPalette palette;

  const _MetallicAvatar({
    required this.icon,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.95),
            AppTheme.metallicGold,
            AppTheme.earthBrown,
            AppTheme.forestGreen,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Icon(icon, color: palette.iconActive, size: 25),
    );
  }
}

class _PreviewBottomBar extends StatelessWidget {
  final List<_PreviewTab> tabs;
  final int selectedTab;
  final AppPalette palette;
  final ValueChanged<int> onChanged;

  const _PreviewBottomBar({
    required this.tabs,
    required this.selectedTab,
    required this.palette,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: palette.bottomBar,
        border: Border(
          top: BorderSide(
            color: AppTheme.metallicGold.withValues(alpha: 0.26),
          ),
        ),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final tab = tabs[index];
          final selected = selectedTab == index;
          return Expanded(
            child: InkWell(
              onTap: () => onChanged(index),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    tab.icon,
                    size: 25,
                    color: selected ? palette.iconActive : palette.iconInactive,
                  ),
                  const SizedBox(height: 4),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: selected ? 20 : 4,
                    height: 3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      color:
                          selected ? AppTheme.metallicGold : Colors.transparent,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _PreviewTab {
  final String label;
  final IconData icon;

  const _PreviewTab({
    required this.label,
    required this.icon,
  });
}

class _PreviewRoute {
  final String title;
  final String subtitle;
  final String path;
  final IconData icon;
  final int tabIndex;
  final String badge;

  const _PreviewRoute({
    required this.title,
    required this.subtitle,
    required this.path,
    required this.icon,
    required this.tabIndex,
    required this.badge,
  });
}
