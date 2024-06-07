import 'package:application_budget_app/pages/page-contenue-app/page-parametre/page-Apropos.dart';
import 'package:application_budget_app/pages/page-contenue-app/page-parametre/page-profil.dart';
import 'package:flutter/material.dart';
import 'package:application_budget_app/pages/page-authentification/page-social.dart';
import 'package:application_budget_app/pages/services/UserService.dart';
import 'package:flutter/cupertino.dart';
import 'package:application_budget_app/pages/page-contenue-app/page-parametre/page-notifications.dart';
import 'package:application_budget_app/base-de-donnees/page-profil-controlleur.dart';
import 'package:application_budget_app/pages/page-contenue-app/page-parametre/page-aide.dart';

class Page_parametre_principal extends StatefulWidget {
  const Page_parametre_principal({super.key});

  @override
  State<Page_parametre_principal> createState() =>
      _Page_parametre_principalState();
}

class _Page_parametre_principalState extends State<Page_parametre_principal> {
  final UserService _userService = UserService();
  bool _isDark = false;

  final _firstNameController = TextEditingController();
  final PageProfilController _controller = PageProfilController();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    UserProfile? profileData = await _controller.getProfile();
    if (profileData != null) {
      setState(() {
        _firstNameController.text = profileData.prenom;
      });
    }
  }

  Widget build(BuildContext context) {
    final double appBarHeight = MediaQuery.of(context).size.height * 0.30;

    return Theme(
      data: _isDark ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(appBarHeight),
          child: ClipPath(
            clipper: AppBarClipper(),
            child: AppBar(
              automaticallyImplyLeading: false,
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF2196F3),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 50.0),
                      child: Text(
                        'Paramètres',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 90.0),
                      child: Text(
                        _firstNameController.text.isNotEmpty
                            ? 'Veuillez configurer votre compte' //${_firstNameController.text}
                            : 'Veuillez configurer votre compte',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              backgroundColor: const Color(0xFF2196F3),
            ),
          ),
        ),
        body: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: ListView(
              children: [
                _SingleSection(
                  title: "Général",
                  children: [
                    /*_CustomListTile(
                        title: "Mode sombre",
                        icon: Icons.dark_mode_outlined,
                        trailing: Switch(
                            value: _isDark,
                            onChanged: (value) {
                              setState(() {
                                _isDark = value;
                              });
                            })),*/
                    _CustomListTile(
                        title: "Notifications",
                        icon: Icons.notifications_none_rounded,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const pageNotifications()),
                          );
                        }),
                  ],
                ),
                const Divider(),
                _SingleSection(
                  title: "Organisation",
                  children: [
                    _CustomListTile(
                        title: "Profil",
                        icon: Icons.person_outline_rounded,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PageProfil()),
                          );
                        }),
                  ],
                ),
                const Divider(),
                _SingleSection(
                  children: [
                    _CustomListTile(
                      title: "Aide & commentaires",
                      icon: Icons.help_outline_rounded,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PageAide()),
                        );
                      },
                    ),
                    _CustomListTile(
                      title: "À propos",
                      icon: Icons.info_outline_rounded,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PageAPropos()),
                        );
                      },
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () async {
                    await _userService.signOut();

                    Navigator.pushAndRemoveUntil(
                        // ignore: use_build_context_synchronously
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PageSocial(),
                        ),
                        (route) => false);
                  },
                  child: const Text('Déconnexion',
                      style: TextStyle(color: Colors.black, fontSize: 20.0)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _CustomListTile({
    Key? key,
    required this.title,
    required this.icon,
    this.trailing,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon),
      trailing: trailing,
      onTap: onTap,
    );
  }
}

class _SingleSection extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  const _SingleSection({
    Key? key,
    this.title,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title!,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        Column(
          children: children,
        ),
      ],
    );
  }
}

class AppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 80);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
