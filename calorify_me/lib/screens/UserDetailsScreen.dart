import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart'; // For animations
import 'package:provider/provider.dart';
import '../modals/Users.dart';
import '../sevices/ThameProvider.dart';


class UserDetailScreen extends StatelessWidget {
  final CustomUser user;

  UserDetailScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final cardColor = isDarkMode ? Colors.grey[900] : Colors.grey[100];
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final subtitleColor = isDarkMode ? Colors.white70 : Colors.black54;
    final accentColor = isDarkMode ? Colors.greenAccent[400] : Colors.green[800];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          '${user.name} Details',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: isDarkMode ? Colors.transparent : Colors.green,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              ZoomIn(child: _buildUserInfoSection(cardColor!, textColor, subtitleColor, accentColor!)),
              SizedBox(height: 20),
              FadeInLeft(child: _buildBMISection(cardColor, textColor, accentColor)),
              SizedBox(height: 20),
              FadeInRight(child: _buildTargetCaloriesSection(cardColor, textColor, accentColor)),
              SizedBox(height: 20),
              SlideInUp(
                child: _buildLogsSection(
                  context,
                  'Food Log',
                  user.foodLog?.map((food) => '${food.foodName}: ${food.calories} Cal').toList() ?? [],
                  cardColor,
                  textColor,
                  accentColor!,
                ),
              ),
              SizedBox(height: 20),
              SlideInUp(
                child: _buildLogsSection(
                  context,
                  'Consumed Food Log',
                  user.consumedFoodLog?.map((food) => '${food.foodName}: ${food.calories} Cal').toList() ?? [],
                  cardColor,
                  textColor,
                  accentColor,
                ),
              ),
              SizedBox(height: 20),
              FadeInDown(child: _buildWaterLogSection(cardColor, textColor, accentColor)),
              SizedBox(height: 30),
              Bounce(child: _buildEditButton(context, accentColor, textColor)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoSection(Color cardColor, Color textColor, Color subtitleColor, Color accentColor) {
    return _buildCard(
      icon: Icons.person,
      title: 'User Info',
      color: cardColor,
      accentColor: accentColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoRow('Name:', user.name, textColor, subtitleColor),
          _infoRow('Age:', '${user.age}', textColor, subtitleColor),
          _infoRow('Weight:', '${user.weight} kg', textColor, subtitleColor),
          _infoRow('Height:', '${user.height} cm', textColor, subtitleColor),
        ],
      ), textColor: textColor,
    );
  }

  Widget _buildBMISection(Color cardColor, Color textColor, Color accentColor) {
    final bmiValue = user.calculateBMI().toStringAsFixed(1);
    final bmiCategory = user.getBMICategory();

    return _buildCard(
      icon: Icons.monitor_weight_outlined,
      title: 'BMI',
      color: cardColor,
      accentColor: accentColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoRow('Value:', bmiValue, textColor, textColor),
          _infoRow('Category:', bmiCategory, textColor, textColor),
        ],
      ), textColor: textColor,
    );
  }

  Widget _buildTargetCaloriesSection(Color cardColor, Color textColor, Color accentColor) {
    return _buildCard(
      icon: Icons.local_fire_department_outlined,
      title: 'Target Calories',
      color: cardColor,
      accentColor: accentColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoRow('Target:', '${user.targetCalories} Cal', textColor, textColor),
        ],
      ), textColor: textColor,
    );
  }

  Widget _buildLogsSection(
      BuildContext context,
      String title,
      List<String> logs,
      Color cardColor,
      Color textColor,
      Color accentColor,
      ) {
    return _buildCard(
      icon: Icons.food_bank_outlined,
      title: title,
      color: cardColor,
      accentColor: accentColor,
      expandable: true,
      child: Column(
        children: logs.isEmpty
            ? [Text('No entries found.', style: TextStyle(color: textColor))]
            : logs
            .map(
              (log) => ListTile(
            title: Text(log, style: TextStyle(fontSize: 16, color: textColor)),
          ),
        )
            .toList(),
      ), textColor: textColor,
    );
  }

  Widget _buildWaterLogSection(Color cardColor, Color textColor, Color accentColor) {
    final consumed = user.waterLog!.currentWaterConsumption;
    final target = user.waterLog!.targetWaterConsumption;
    final progress = (consumed / target).clamp(0.0, 1.0);

    return _buildCard(
      icon: Icons.opacity,
      title: 'Water Log',
      color: cardColor,
      accentColor: accentColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoRow('Consumed:', '${consumed.toStringAsFixed(1)} ml', textColor, textColor),
          _infoRow('Target:', '${target.toStringAsFixed(1)} ml', textColor, textColor),
          SizedBox(height: 10),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[800],
            color: accentColor,
            minHeight: 8,
          ),
        ],
      ), textColor: textColor,
    );
  }

  Widget _buildEditButton(BuildContext context, Color accentColor, Color textColor) {
    return ElevatedButton.icon(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Edit User functionality coming soon!')),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: accentColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        elevation: 8,
      ),
      icon: Icon(Icons.edit, color: textColor),
      label: Text('Edit User', style: TextStyle(fontSize: 16, color: textColor)),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required Widget child,
    required Color color,
    required Color accentColor,
    required Color textColor,
    
    bool expandable = false,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: color,
      elevation: 10,
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: expandable
            ? ExpansionTile(
          leading: Icon(icon, color: accentColor),
          title: _sectionTitle(title, accentColor),
          children: [child],
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: accentColor),
                SizedBox(width: 8),
                _sectionTitle(title, textColor),
              ],
            ),
            SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, Color color) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }

  Widget _infoRow(String label, String value, Color labelColor, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16, color: labelColor, fontWeight: FontWeight.w600)),
          Text(value, style: TextStyle(fontSize: 16, color: valueColor)),
        ],
      ),
    );
  }
}
