import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:services_app/src/features/auth/registration_page.dart';
import 'package:services_app/src/features/auth/service%20giver.dart';
import '../../features/settings/providers/app_settings.dart';

class ChooseRoleScreen extends StatefulWidget {
  final VoidCallback onAuthenticated;
  const ChooseRoleScreen({Key? key, required this.onAuthenticated}) : super(key: key);



  @override
  State<ChooseRoleScreen> createState() => _ChooseRoleScreenState();
}

class _ChooseRoleScreenState extends State<ChooseRoleScreen> {
  bool isServiceGiver = true;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final appColor = Provider.of<AppSettings>(context).currentColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          child: Column(
            children: [
              // Header with logo and title
              Container(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? appColor.withOpacity(0.2) : Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.people_alt_rounded,
                        size: 48,
                        color: appColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Choose Your Role',
                      style: TextStyle(
                        color: appColor,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),

              // Toggle buttons
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: appColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() => isServiceGiver = true);
                            _pageController.animateToPage(0,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 12),
                            decoration: BoxDecoration(
                              color: isServiceGiver ? appColor : Colors.transparent,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              'SERVICE GIVER',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color:
                                isServiceGiver ? Colors.white : appColor,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() => isServiceGiver = false);
                            _pageController.animateToPage(1,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 12),
                            decoration: BoxDecoration(
                              color: !isServiceGiver ? appColor : Colors.transparent,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              'SERVICE SEEKER',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color:
                                !isServiceGiver ? Colors.white : appColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // PageView for Role Selection
              Expanded(
                child: Container(
                  margin:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? appColor.withOpacity(0.15) : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() => isServiceGiver = index == 0);
                    },
                    children: [
                      _RoleCard(
                        title: "I want to offer my services",
                        description:
                        "Register as a service giver and showcase your skills to customers.",
                        icon: Icons.build_rounded,
                        color: appColor,
                        onSelect: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ServiceGiverRegisterScreen(onRegistered: widget.onAuthenticated),
                            ),
                          );
                        },
                      ),
                      _RoleCard(
                        title: "I want to request a service",
                        description:
                        "Find trusted professionals and request services easily.",
                        icon: Icons.handshake_rounded,
                        color: appColor,
                        onSelect: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AuthScreen(
                                onAuthenticated: widget.onAuthenticated,
                              ),
                            ),
                          );

                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onSelect;

  const _RoleCard({
    Key? key,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 80, color: color),
        const SizedBox(height: 16),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          description,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onSelect,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("CONTINUE"),
          ),
        ),
      ],
    );
  }
}
