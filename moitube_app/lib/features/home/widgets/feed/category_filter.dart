import 'package:flutter/material.dart';

class CategoryFilter extends StatelessWidget{
  final int selectedIndex;
  final Function(int) onChanged;
  final List<String> categories;

  const CategoryFilter({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;
          return GestureDetector(
            onTap: () => onChanged(index),
            child: Container(
              margin: EdgeInsets.only(right: 8),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: isSelected ? Color(0xffef39a5) : Color(0xff27272a),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? Color(0xffef39a5) : Color(0xff27272a),
                )
              ),
              child: Text(
                categories[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white70,
                  fontSize: 13,
                ),
              ),
            )
          );
        }
        ),
      );
  }
}