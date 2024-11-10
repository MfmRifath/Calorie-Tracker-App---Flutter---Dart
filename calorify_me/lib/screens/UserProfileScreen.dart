import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import '../modals/Food.dart';
import '../sevices/UserProvider.dart';
import 'EditProfileScreen.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool _isFoodLogExpanded = false; // Track Food Log expansion state

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          // Vibrant Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFfbc2eb), Color(0xFFa6c1ee)], // Pink to blue gradient
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
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
                    return Center(
                      child: Text(
                        'Error loading user data',
                        style: GoogleFonts.poppins(color: Colors.white, fontSize: 18),
                      ),
                    );
                  }

                  final user = userProvider.user;

                  if (user == null) {
                    return Center(
                      child: Text(
                        'No user data available',
                        style: GoogleFonts.poppins(color: Colors.white, fontSize: 18),
                      ),
                    );
                  }

                  return Column(
                    children: [
                      // Profile Card
                      FadeInDown(
                        duration: Duration(milliseconds: 800),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10.0,
                                spreadRadius: 2.0,
                              ),
                            ],
                          ),
                          padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 16.0),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // Navigate to profile picture update section
                                },
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundImage: AssetImage('assets/profile_placeholder.png'),
                                  backgroundColor: Colors.grey[200],
                                ),
                              ),
                              SizedBox(height: 12),
                              Text(
                                user.name,
                                style: GoogleFonts.poppins(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF333333),
                                ),
                              ),
                              Text(
                                user.email,
                                style: GoogleFonts.poppins(
                                  fontSize: 16.0,
                                  color: Colors.grey[600],
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
                                  backgroundColor: Color(0xFF27AE60), // Vibrant green
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 24),

                      // Settings Section
                      _buildListTile(
                        context,
                        icon: Icons.settings,
                        title: 'Settings',
                        color: Color(0xFF2F80ED),
                        onTap: () {
                          // Placeholder for settings navigation
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Navigate to Settings')),
                          );
                        },
                      ),

                      // Log Out Section
                      _buildListTile(
                        context,
                        icon: Icons.logout,
                        title: 'Log Out',
                        color: Color(0xFFEB5757),
                        onTap: () async {
                          await userProvider.logout();
                          Navigator.pushNamed(context, '/login');
                        },
                      ),

                      SizedBox(height: 16),

                      // Food Log Section
                      Expanded(
                        child: ListView(
                          children: [
                            _buildMinimizableFoodLogSection(userProvider.foodLog),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(BuildContext context,
      {required IconData icon,
        required String title,
        required Color color,
        required VoidCallback onTap}) {
    return FadeInLeft(
      duration: Duration(milliseconds: 1200),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        elevation: 5,
        shadowColor: Colors.blueGrey.withOpacity(0.3),
        child: ListTile(
          leading: Icon(icon, color: color, size: 28.0),
          title: Text(
            title,
            style: GoogleFonts.poppins(fontSize: 16.0, color: Color(0xFF333333)),
          ),
          trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16.0),
          onTap: onTap,
        ),
      ),
    );
  }

  Widget _buildMinimizableFoodLogSection(List<Food> foodLog) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            spreadRadius: 2.0,
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
                leading: Icon(Icons.fastfood, color: Color(0xFF2F80ED)),
                title: Text(
                  'Food Log',
                  style: GoogleFonts.poppins(fontSize: 18.0, fontWeight: FontWeight.bold),
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
                return BounceInUp(
                  duration: Duration(milliseconds: 500 + index * 100),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 6,
                    margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: ListTile(
                      leading: Icon(Icons.restaurant, color: Color(0xFFf2994a)),
                      title: Text(
                        food.foodName,
                        style: GoogleFonts.poppins(fontSize: 16.0, color: Color(0xFF333333)),
                      ),
                      subtitle: Text(
                        '${food.calories} kcal',
                        style: GoogleFonts.poppins(fontSize: 14.0, color: Colors.grey[600]),
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
                style: GoogleFonts.poppins(fontSize: 14.0, color: Colors.grey[600]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
