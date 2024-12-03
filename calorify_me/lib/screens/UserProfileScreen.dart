import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import '../modals/Food.dart';
import '../modals/Users.dart';
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = themeProvider.getTheme();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          AnimatedContainer(
            duration: Duration(seconds: 2),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: themeProvider.isDarkMode
                    ? [Colors.black, Colors.green.shade900]
                    : [Colors.white, Colors.teal.shade100],
              ),
            ),
          ),
          SafeArea(
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildProfileHeader(user, theme),
                        SizedBox(height: 20),
                        _buildUserDetails(user, theme),
                        SizedBox(height: 20),
                        _buildActionButtons(theme, userProvider),
                        SizedBox(height: 20),
                        _buildFoodLogSection(userProvider.foodLog, theme),
                      ],
                    ),
                  ),
                );
              },
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

  Widget _buildProfileHeader(CustomUser user, ThemeData theme) {
    return SlideInDown(
      duration: Duration(milliseconds: 800),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.green.shade400,
              Colors.green.shade700,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.green.shade900.withOpacity(0.2),
              blurRadius: 15,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {},
              child: CircleAvatar(
                radius: 60,
                backgroundImage: user.profileImageUrl == null
                    ? AssetImage('assets/profile_placeholder.png')
                    : NetworkImage(user.profileImageUrl!) as ImageProvider,
                backgroundColor: Colors.green.shade100,
              ),
            ),
            SizedBox(height: 10),
            Text(
              user.name,
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 4),
            Text(
              user.email,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfileScreen(user: user),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.green.shade600,
                      Colors.green.shade800,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.edit, size: 20, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Edit Profile',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildUserDetails(CustomUser user, ThemeData theme) {
    return SlideInLeft( // Changed animation for a smoother entry
      duration: Duration(milliseconds: 1000),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.green.shade400,
              Colors.green.shade600,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.green.shade900.withOpacity(0.2),
              blurRadius: 15,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User Details',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Divider(
              color: Colors.white70,
              thickness: 1.2,
            ),
            SizedBox(height: 16),
            _buildDetailRow('Name:', user.name, theme, Colors.white),
            _buildDetailRow('Age:', '${user.age}', theme, Colors.white),
            _buildDetailRow('Weight:', '${user.weight} kg', theme, Colors.white),
            _buildDetailRow('Height:', '${user.height} m', theme, Colors.white70),
            _buildDetailRow('BMI:', '${user.calculateBMI().toStringAsFixed(2)}', theme, Colors.white),
            _buildDetailRow('BMI Category:', user.getBMICategory(), theme, Colors.white70),
            _buildDetailRow('Target Calories:', '${user.targetCalories} kcal', theme, Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value, ThemeData theme, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white70,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildActionButtons(ThemeData theme, UserProvider userProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserSettingsScreen(),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.primaryColor.withOpacity(0.8),
                  theme.primaryColorDark,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: theme.primaryColor.withOpacity(0.3),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              children: [
                Icon(Icons.settings, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  'Settings',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            await userProvider.logout();
            Navigator.pushReplacementNamed(context, '/login');
          },
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.redAccent.withOpacity(0.8),
                  Colors.red,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.3),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              children: [
                Icon(Icons.logout, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  'Log Out',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFoodLogSection(List<Food> foodLog, ThemeData theme) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInOut,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.greenAccent.shade200,
              Colors.teal.shade400,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.teal.shade900.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ExpansionPanelList(
          elevation: 1,
          expandedHeaderPadding: EdgeInsets.symmetric(vertical: 8),
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
                  leading: AnimatedRotation(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeOut,
                    turns: isExpanded ? 0.5 : 0.0,
                    child: Icon(Icons.fastfood, color: Colors.white),
                  ),
                  title: Text(
                    'Food Log',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade900,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.add_circle, color: Colors.amberAccent),
                    onPressed: () {
                      _showAddFoodDialog(
                          context, Provider.of<UserProvider>(context, listen: false));
                    },
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
                  return FadeInUp(
                    delay: Duration(milliseconds: 100 * index),
                    duration: Duration(milliseconds: 500),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 6,
                      margin:
                      EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.lightGreenAccent.shade100,
                              Colors.green.shade300,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: Icon(Icons.restaurant,
                              color: Colors.teal.shade800),
                          title: Text(
                            food.foodName,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.teal.shade900,
                            ),
                          ),
                          subtitle: Text(
                            '${food.calories} kcal',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.teal.shade700,
                            ),
                          ),
                          trailing: IconButton(
                            icon:
                            Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () {
                              _showDeleteConfirmationDialog(
                                  context, food.id!);
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
                  : FadeIn(
                duration: Duration(milliseconds: 500),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.fastfood,
                          size: 48, color: Colors.tealAccent.shade100),
                      SizedBox(height: 8),
                      Text(
                        'No food logged yet.',
                        style: GoogleFonts.poppins(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _showDeleteConfirmationDialog(BuildContext context, String foodId) {
    print("Opening delete confirmation dialog for foodId: $foodId"); // Debug log
    final theme = Theme.of(context);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: theme.cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 28),
                  SizedBox(width: 8),
                  Text(
                    'Delete Food',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.bodyLarge!.color,
                    ),
                  ),
                ],
              ),
              content: Text(
                'Are you sure you want to delete this food item? This action cannot be undone.',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: theme.hintColor,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                    setState(() {
                      isLoading = true;
                    });
                    await userProvider.deleteFood(foodId);
                    setState(() {
                      isLoading = false;
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: isLoading
                      ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : Text(
                    'Delete',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
  void _showAddFoodDialog(BuildContext context, UserProvider userProvider) {
    final theme = Theme.of(context);
    final TextEditingController foodNameController = TextEditingController();
    final TextEditingController caloriesController = TextEditingController();
    final TextEditingController proteinController = TextEditingController();
    final TextEditingController fatController = TextEditingController();
    final TextEditingController foodWeightController = TextEditingController();
    final TextEditingController carbsController = TextEditingController();


    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: theme.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Add Food',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: theme.textTheme.bodyLarge!.color,
            ),
          ),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextField(
                    controller: foodNameController,
                    label: 'Food Name',
                    hint: 'Enter the name of the food',
                    theme: theme,
                    validator: (value) => value!.isEmpty ? 'Food Name is required' : null,
                  ),
                  SizedBox(height: 10),
                  _buildTextField(
                    controller: caloriesController,
                    label: 'Calories',
                    hint: 'Enter calories (e.g., 200)',
                    theme: theme,
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                    value!.isEmpty || int.tryParse(value) == null ? 'Enter valid calories' : null,
                  ),
                  SizedBox(height: 10),
                  _buildTextField(
                    controller: proteinController,
                    label: 'Protein',
                    hint: 'Enter protein (g)',
                    theme: theme,
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                    value!.isEmpty || double.tryParse(value) == null ? 'Enter valid protein' : null,
                  ),
                  SizedBox(height: 10),
                  _buildTextField(
                    controller: fatController,
                    label: 'Fat',
                    hint: 'Enter fat (g)',
                    theme: theme,
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                    value!.isEmpty || double.tryParse(value) == null ? 'Enter valid fat' : null,
                  ),
                  SizedBox(height: 10),
                  _buildTextField(
                    controller: carbsController,
                    label: 'Carbs',
                    hint: 'Enter Carbs (g)',
                    theme: theme,
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                    value!.isEmpty || double.tryParse(value) == null ? 'Enter valid fat' : null,
                  ),
                  SizedBox(height: 10),
                  _buildTextField(
                    controller: foodWeightController,
                    label: 'Food Weight',
                    hint: 'Enter weight (g)',
                    theme: theme,
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                    value!.isEmpty || double.tryParse(value) == null ? 'Enter valid weight' : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(color: theme.hintColor),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final foodName = foodNameController.text.trim();
                  final calories = int.parse(caloriesController.text.trim());
                  final protein = double.parse(proteinController.text.trim());
                  final fat = double.parse(fatController.text.trim());
                  final foodWeight = double.parse(foodWeightController.text.trim());
                  final carbWeight = double.parse(carbsController.text.trim());

                  userProvider.logFood(Food(
                    foodName: foodName,
                    calories: calories,
                    protein: protein,
                    fat: fat,
                    foodWeight: foodWeight, carbs:carbWeight,
                  ));
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Add',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required ThemeData theme,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: GoogleFonts.poppins(color: theme.hintColor),
        hintStyle: GoogleFonts.poppins(color: theme.hintColor.withOpacity(0.6)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: theme.primaryColor),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      style: GoogleFonts.poppins(color: theme.textTheme.bodyLarge!.color),
      validator: validator,
    );
  }
}