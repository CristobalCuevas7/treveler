import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:treveler/domain/entities/category.dart';
import 'package:treveler/style/colors.dart';
import 'package:treveler/style/dimensions.dart';

class CategoryFilter extends StatefulWidget {
  final List<Category> categories;
  final Function(Set<int>) onCategorySelected;

  const CategoryFilter({
    Key? key,
    required this.categories,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  State<CategoryFilter> createState() => _CategoryFilterState();
}

class _CategoryFilterState extends State<CategoryFilter> {
  Set<int> _selectedCategories = {0}; // Initialize with 'All' category selected.

  void _toggleCategory(int categoryId) {
    setState(() {
      // If 'All' category is already selected or if it is the one being toggled.
      if (categoryId == 0) {
        _selectedCategories = {0};
      } else {
        _selectedCategories.remove(0);
        // Toggle the selected category.
        if (_selectedCategories.contains(categoryId)) {
          _selectedCategories.remove(categoryId);
        } else {
          _selectedCategories.add(categoryId);
        }
        // If no categories are selected, select 'All'.
        if (_selectedCategories.isEmpty) {
          _selectedCategories.add(0);
        }
      }
      widget.onCategorySelected(_selectedCategories);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.categoryFilterHeight,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          const SizedBox(width: AppSizes.marginSmall),
          ...widget.categories.map((category) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.marginSmall / 2),
                child: ChoiceChip(
                  label: Text(category.name),
                  labelStyle: TextStyle(
                    color: _selectedCategories.contains(category.id) ? AppColors.white : AppColors.text,
                  ),
                  selected: _selectedCategories.contains(category.id),
                  backgroundColor: AppColors.lightGrey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radius),
                    side: const BorderSide(color: Colors.transparent),
                  ),
                  onSelected: (_) => _toggleCategory(category.id),
                ),
              )),
          Padding(
            padding: const EdgeInsets.only(left: AppSizes.marginSmall / 2, right: AppSizes.marginSmall),
            child: ChoiceChip(
              label: Text(AppLocalizations.of(context)!.all),
              labelStyle: TextStyle(
                color: _selectedCategories.contains(0) ? AppColors.white : AppColors.text,
              ),
              selected: _selectedCategories.contains(0),
              backgroundColor: AppColors.lightGrey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radius),
                side: const BorderSide(color: Colors.transparent),
              ),
              onSelected: (_) => _toggleCategory(0),
            ),
          ),
        ],
      ),
    );
  }
}
