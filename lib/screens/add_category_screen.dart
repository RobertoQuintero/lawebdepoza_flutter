import 'package:flutter/material.dart';
import 'package:lawebdepoza_mobile/services/services.dart';
import 'package:lawebdepoza_mobile/ui/input_decorations.dart';
import 'package:provider/provider.dart';

class AddCategoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final categoryService = Provider.of<CategoryService>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Agregar Categoría'),
        ),
        body: Container(
          padding: EdgeInsets.only(left: 15, right: 15, top: 15),
          child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: categoryService.categoryKey,
              child: Column(
                children: [
                  TextFormField(
                    autocorrect: false,
                    keyboardType: TextInputType.text,
                    decoration: InputDecorations.authInputDecoration(
                      hintText: 'Comida',
                      labelText: 'Categoría',
                    ),
                    onChanged: (value) => categoryService.category = value,
                    validator: (value) {
                      return value != null && value.length > 2
                          ? null
                          : 'Nombre muy corto';
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      disabledColor: Colors.grey,
                      elevation: 0,
                      color: Colors.deepPurple,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                        child: Text(
                          categoryService.isLoading ? 'Espere...' : 'Agregar',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      onPressed: categoryService.isLoading
                          ? null
                          : () async {
                              if (!categoryService.isValidForm()) return;
                              categoryService.createCategory();
                            })
                ],
              )),
        ));
  }
}
