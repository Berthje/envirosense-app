// add_room_card.dart

import 'package:flutter/material.dart';
import 'package:envirosense/colors/colors.dart';

class AddRoomCard extends StatelessWidget {
  const AddRoomCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle add room
      },
      child: Card(
        color: AppColors.secondaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.add,
                color: Colors.white,
                size: 48,
              ),
              SizedBox(height: 8),
              Text(
                'Add a room',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
