import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyMenuBarApp extends StatefulWidget {
  const MyMenuBarApp({super.key});

  @override
  State<MyMenuBarApp> createState() => _MyMenuBarAppState();
}
enum MenuSelection {
  about,
  showMessage,
}

class _MyMenuBarAppState extends State<MyMenuBarApp> {
  String _message = 'Hello';
  bool _showMessage = false;

  void _handleMenuSelection(MenuSelection value) {
    switch (value) {
      case MenuSelection.about:
        showAboutDialog(
          context: context,
          applicationName: 'MenuBar Sample',
          applicationVersion: '1.0.0',
        );
        break;
      case MenuSelection.showMessage:
        setState(() {
          _showMessage = !_showMessage;
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    ////////////////////////////////////
    // THIS SAMPLE ONLY WORKS ON MACOS.

    ////////////////////////////////////

    // This builds a menu hierarchy that looks like this:
    // Flutter API Sample
    //  ├ About
    //  ├ ────────  (group divider)
    //  ├ Hide/Show Message
    //  ├ Messages
    //  │  ├ I am not throwing away my shot.
    //  │  └ There's a million things I haven't done, but just you wait.
    //  └ Quit
    return PlatformMenuBar(
      menus: <MenuItem>[
        PlatformMenu(
          label: 'Flutter API Sample',
          menus: <MenuItem>[
            PlatformMenuItemGroup(
              members: <MenuItem>[
                PlatformMenuItem(
                  label: 'About',
                  onSelected: () {
                    _handleMenuSelection(MenuSelection.about);
                  },
                ),
              ],
            ),
            PlatformMenuItemGroup(
              members: <MenuItem>[
                PlatformMenuItem(
                  onSelected: () {
                    _handleMenuSelection(MenuSelection.showMessage);
                  },
                  shortcut: const CharacterActivator('m'),
                  label: _showMessage ? 'Hide Message' : 'Show Message',
                ),
                PlatformMenu(
                  label: 'Messages',
                  menus: <MenuItem>[
                    PlatformMenuItem(
                      label: 'I am not throwing away my shot.',
                      shortcut: const SingleActivator(LogicalKeyboardKey.digit1,
                          meta: true),
                      onSelected: () {
                        setState(() {
                          _message = 'I am not throwing away my shot.';
                        });
                      },
                    ),
                    PlatformMenuItem(
                      label:
                      "There's a million things I haven't done, but just you wait.",
                      shortcut: const SingleActivator(LogicalKeyboardKey.digit2,
                          meta: true),
                      onSelected: () {
                        setState(() {
                          _message =
                          "There's a million things I haven't done, but just you wait.";
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            if (PlatformProvidedMenuItem.hasMenu(
                PlatformProvidedMenuItemType.quit))
              const PlatformProvidedMenuItem(
                  type: PlatformProvidedMenuItemType.quit),
          ],
        ),
      ],
      body: MaterialApp(
          builder: (context, child) =>  Scaffold(
          body: Center(
            child: Text(_showMessage
                ? _message
                : 'This space intentionally left blank.\n'
                'Show a message here using the menu.'),
          ),
        ),
      ),
    );
  }
}