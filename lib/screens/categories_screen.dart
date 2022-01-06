import 'package:flutter/material.dart';
import 'package:lawebdepoza_mobile/helpers/show_dialog.dart';
import 'package:lawebdepoza_mobile/models/models.dart';
import 'package:lawebdepoza_mobile/services/services.dart';
import 'package:provider/provider.dart';

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final categoryService = Provider.of<CategoryService>(context);
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text('Categorías'),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              categoryService.selectedCategory = new Category(name: '');
              Navigator.pushNamed(context, 'add-category');
            },
            child: Icon(Icons.add),
          ),
          body: ListView.builder(
            // padding: EdgeInsets.symmetric(horizontal: 15),
            itemCount: categoryService.categories.length,
            itemBuilder: (BuildContext context, int index) {
              return CategoryButton(categoryService.categories[index]);
            },
          ),
        ),
        if (categoryService.isLoading)
          Scaffold(
            backgroundColor: Colors.white54,
            body: Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor),
            ),
          )
      ],
    );
  }
}

class CategoryButton extends StatelessWidget {
  final Category category;

  const CategoryButton(this.category);

  @override
  Widget build(BuildContext context) {
    final categoryService = Provider.of<CategoryService>(context);
    return Column(
      children: [
        ListTile(
          title: Text(category.name),
          leading: _TileIcon(
              category: category,
              iconData: Icons.edit,
              color: Colors.green.shade200,
              onTap: () {
                categoryService.selectedCategory = category;
                Navigator.pushNamed(context, 'add-category');
              }),
          trailing: _TileIcon(
            category: category,
            iconData: Icons.delete,
            color: Colors.red.shade200,
            onTap: () => showModal(
                context: context,
                widget: Text('Está seguro de eiminar la categoría'),
                callback: () {
                  categoryService.selectedCategory = category;
                  categoryService.deleteCategory();
                  Navigator.pop(context);
                },
                title: 'Eliminar'),
          ),
        ),
        Divider(),
      ],
    );
  }
}

class _TileIcon extends StatelessWidget {
  final Category category;
  final IconData iconData;
  final Color color;
  final VoidCallback onTap;

  const _TileIcon(
      {required this.category,
      required this.iconData,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 1)),
          child: Icon(
            iconData,
            size: 18,
            color: color,
          )),
    );
  }
}
