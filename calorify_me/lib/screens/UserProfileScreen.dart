import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import '../modals/Food.dart';
 // Import ThemeProvider
import '../sevices/ThameProvider.dart';
import '../sevices/UserProvider.dart';
import 'EditProfileScreen.dart';
import 'UserSettingScreen.dart';


class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool _isFoodLogExpanded = false;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context); // Access ThemeProvider
    final theme = themeProvider.getTheme(); // Get current theme

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Background Gradient
          AnimatedContainer(
            duration: Duration(seconds: 2),
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topRight,
                radius: 1.5,
                colors: themeProvider.isDarkMode
                    ? [Colors.black, Colors.green.shade900]
                    : [Colors.white, Colors.green.shade100],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FutureBuilder(
                future: userProvider.loadUserData(),
                builder: (context, snapshot) {

                  if (snapshot.hasError) {
                    return _buildErrorState('Error loading user data', theme);
                  }

                  final user = userProvider.user;
                  if (user == null) {
                    return _buildErrorState('No user data available', theme);
                  }

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildProfileHeader(user, theme),
                        SizedBox(height: 20),
                        _buildListTile(
                          context,
                          icon: Icons.settings,
                          title: 'Settings',
                          color: theme.hintColor,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserSettingsScreen(),
                              ),
                            );
                          },
                        ),
                        _buildListTile(
                          context,
                          icon: Icons.logout,
                          title: 'Log Out',
                          color: Colors.redAccent,
                          onTap: () async {
                            await userProvider.logout();
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                        ),
                        SizedBox(height: 20),
                        _buildFoodLogSection(userProvider.foodLog, theme),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message, ThemeData theme) {
    return Center(
      child: Text(
        message,
        style: GoogleFonts.poppins(
          color: theme.colorScheme.error,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildProfileHeader(user, ThemeData theme) {
    return FadeInDown(
      duration: Duration(milliseconds: 800),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: theme.primaryColor.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {},
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/profile_placeholder.png'),
                backgroundColor: theme.hintColor,
              ),
            ),
            SizedBox(height: 12),
            Text(
              user.name,
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: theme.hintColor,
              ),
            ),
            Text(
              user.email,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: theme.hintColor,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfileScreen(user: user),
                  ),
                );
              },
              icon: Icon(Icons.edit, size: 20),
              label: Text('Edit Profile'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.hintColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(
      BuildContext context, {
        required IconData icon,
        required String title,
        required Color color,
        required VoidCallback onTap,
      }) {
    final theme = Theme.of(context);
    return FadeInLeft(
      duration: Duration(milliseconds: 1000),
      child: Card(
        color: theme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 5,
        child: ListTile(
          leading: Icon(icon, color: color, size: 28),
          title: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: theme.textTheme.bodyLarge!.color,
            ),
          ),
          trailing: Icon(Icons.arrow_forward_ios, color: theme.hintColor, size: 16),
          onTap: onTap,
        ),
      ),
    );
  }

  Widget _buildFoodLogSection(List<Food> foodLog, ThemeData theme) {
    return BounceInUp(
      duration: Duration(milliseconds: 900),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: theme.hintColor.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ExpansionPanelList(
          elevation: 0,
          expandedHeaderPadding: EdgeInsets.symmetric(vertical: 5),
          animationDuration: Duration(milliseconds: 500),
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              _isFoodLogExpanded = !_isFoodLogExpanded;
            });
          },
          children: [
            ExpansionPanel(
              isExpanded: _isFoodLogExpanded,
              headerBuilder: (context, isExpanded) {
                return ListTile(
                  leading: Icon(Icons.fastfood, color: theme.hintColor),
                  title: Text(
                    'Food Log',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.hintColor,
                    ),
                  ),
                );
              },
              body: foodLog.isNotEmpty
                  ? ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: foodLog.length,
                itemBuilder: (context, index) {
                  final food = foodLog[index];
                  return Card(
                    color: theme.colorScheme.background,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 6,
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      leading: Icon(Icons.restaurant, color: theme.hintColor),
                      title: Text(
                        food.foodName,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: theme.hintColor,
                        ),
                      ),
                      subtitle: Text(
                        '${food.calories} kcal',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: theme.hintColor,
                        ),
                      ),
                    ),
                  );
                },
              )
                  : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'No food logged yet.',
                  style: GoogleFonts.poppins(fontSize: 14.0, color: theme.hintColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
