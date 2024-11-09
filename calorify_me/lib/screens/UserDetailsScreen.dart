import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart'; // Add this for animations
import '../modals/Users.dart';

class UserDetailScreen extends StatelessWidget {
  final CustomUser user;

  UserDetailScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          '${user.name} Details',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green[700]!, Colors.greenAccent[400]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              ZoomIn(child: _buildUserInfoSection()),
              SizedBox(height: 20),
              FadeInLeft(child: _buildBMISection()),
              SizedBox(height: 20),
              FadeInRight(child: _buildTargetCaloriesSection()),
              SizedBox(height: 20),
              SlideInUp(
                child: _buildLogsSection(
                  context,
                  'Food Log',
                  user.foodLog!.map((food) => '${food.foodName}: ${food.calories} Cal').toList(),
                ),
              ),
              SizedBox(height: 20),
              SlideInUp(
                child: _buildLogsSection(
                  context,
                  'Consumed Food Log',
                  user.consumedFoodLog!.map((food) => '${food.foodName}: ${food.calories} Cal').toList(),
                ),
              ),
              SizedBox(height: 20),
              FadeInDown(child: _buildWaterLogSection()),
              SizedBox(height: 30),
              Bounce(
                child: _buildEditButton(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoSection() {
    return _buildCard(
      icon: Icons.person,
      title: 'User Info',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoRow('Name:', user.name),
          _infoRow('Age:', '${user.age}'),
          _infoRow('Weight:', '${user.weight} kg'),
          _infoRow('Height:', '${user.height} cm'),
        ],
      ),
    );
  }

  Widget _buildBMISection() {
    final bmiValue = user.calculateBMI().toStringAsFixed(1);
    final bmiCategory = user.getBMICategory();

    return _buildCard(
      icon: Icons.monitor_weight_outlined,
      title: 'BMI',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoRow('Value:', bmiValue),
          _infoRow('Category:', bmiCategory),
        ],
      ),
    );
  }

  Widget _buildTargetCaloriesSection() {
    return _buildCard(
      icon: Icons.local_fire_department_outlined,
      title: 'Target Calories',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoRow('Target:', '${user.targetCalories} Cal'),
        ],
      ),
    );
  }

  Widget _buildLogsSection(BuildContext context, String title, List<String> logs) {
    return _buildCard(
      icon: Icons.food_bank_outlined,
      title: title,
      expandable: true,
      child: Column(
        children: logs.isEmpty
            ? [Text('No entries found.', style: TextStyle(color: Colors.grey[400]))]
            : logs.map((log) => ListTile(title: Text(log, style: TextStyle(fontSize: 16, color: Colors.white)))).toList(),
      ),
    );
  }

  Widget _buildWaterLogSection() {
    final consumed = user.waterLog.currentWaterConsumption;
    final target = user.waterLog.targetWaterConsumption;
    final progress = (consumed / target).clamp(0.0, 1.0);

    return _buildCard(
      icon: Icons.opacity,
      title: 'Water Log',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoRow('Consumed:', '${consumed.toStringAsFixed(1)} ml'),
          _infoRow('Target:', '${target.toStringAsFixed(1)} ml'),
          SizedBox(height: 10),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[800],
            color: Colors.greenAccent[400],
            minHeight: 8,
          ),
        ],
      ),
    );
  }

  Widget _buildEditButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Edit User functionality coming soon!')),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.greenAccent[400],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        elevation: 8,
      ),
      icon: Icon(Icons.edit, color: Colors.black),
      label: Text('Edit User', style: TextStyle(fontSize: 16, color: Colors.black)),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required Widget child,
    bool expandable = false,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.grey[900],
      elevation: 10,
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: expandable
            ? ExpansionTile(
          leading: Icon(icon, color: Colors.greenAccent[400]),
          title: _sectionTitle(title, isTile: true),
          children: [child],
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.greenAccent[400]),
                SizedBox(width: 8),
                _sectionTitle(title),
              ],
            ),
            SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, {bool isTile = false}) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: isTile ? Colors.greenAccent[400] : Colors.white,
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16, color: Colors.white70, fontWeight: FontWeight.w600)),
          Text(value, style: TextStyle(fontSize: 16, color: Colors.white)),
        ],
      ),
    );
  }
}
