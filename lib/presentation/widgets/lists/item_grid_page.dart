import 'package:envirosense/core/constants/colors.dart';
import 'package:envirosense/core/enums/searchable.type.dart';
import 'package:envirosense/presentation/widgets/cards/add_item_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:envirosense/presentation/widgets/core/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class ItemGridPage<T> extends StatefulWidget {
  final List<T> allItems;
  final Widget Function(T item) itemBuilder;
  final String Function(T item) getItemName;
  final VoidCallback onAddPressed;
  final VoidCallback onItemChanged;
  final SearchableType searchableType;

  const ItemGridPage({
    super.key,
    required this.allItems,
    required this.itemBuilder,
    required this.getItemName,
    required this.onAddPressed,
    required this.onItemChanged,
    required this.searchableType,
  });

  @override
  ItemGridPageState<T> createState() => ItemGridPageState<T>();
}

class ItemGridPageState<T> extends State<ItemGridPage<T>> {
  final TextEditingController _searchController = TextEditingController();
  late List<T> _filteredItems;

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.allItems;
    _searchController.addListener(_filterItems);
  }

  @override
  void didUpdateWidget(covariant ItemGridPage<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.allItems != widget.allItems) {
      _filteredItems = widget.allItems;
      _filterItems();
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterItems);
    _searchController.dispose();
    super.dispose();
  }

  void _filterItems() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredItems = widget.allItems.where((item) {
        final itemName = widget.getItemName(item).toLowerCase();
        return itemName.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          CustomTextFormField(
            controller: _searchController,
            labelText: l10n.searchTypedEntity(widget.searchableType.getTranslation(context)),
            labelColor: AppColors.blackColor,
            prefixIcon: const Icon(Icons.search),
            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            borderColor: AppColors.accentColor,
            floatingLabelCustomStyle: const TextStyle(
              color: AppColors.primaryColor,
            ),
            textStyle: const TextStyle(
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: GridView.builder(
              itemCount: _filteredItems.length + 1,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemBuilder: (context, index) {
                if (index < _filteredItems.length) {
                  var item = _filteredItems[index];
                  return widget.itemBuilder(item);
                } else {
                  return AddItemCard(
                    onTap: widget.onAddPressed,
                    title: l10n.addTypedEntity(widget.searchableType.getTranslation(context)),
                    backgroundColor: AppColors.secondaryColor,
                    iconColor: AppColors.whiteColor,
                    textColor: AppColors.whiteColor,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
