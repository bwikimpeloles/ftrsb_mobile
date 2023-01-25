import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddCategory extends StatefulWidget {
  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  late TextEditingController _categoryController;
  final _formKey = GlobalKey<FormState>();
  late CollectionReference _ref;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _categoryController = TextEditingController();

    _ref = FirebaseFirestore.instance.collection('Category');
  }

  void saveCategory(){

    String categories = _categoryController.text.trim();


    Map<String,String> category = {
      'category':categories,

    };

    _ref.doc().set(category).then((value) {
      Navigator.pop(context);
    });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category'),
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    RegExp regex = RegExp(r'^.{3,}$');
                    if (value!.isEmpty) {
                      return ("This field cannot be empty!");
                    }
                    if (!regex.hasMatch(value)) {
                      return ("Enter valid input!");
                    }
                    return null;
                  },
                  controller: _categoryController,
                  decoration: InputDecoration(
                    label: Text('Category'),
                    hintText: 'Enter Category',
                    prefixIcon: Icon(
                      Icons.category,
                      size: 30,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.all(15),
                  ),
                ),


                SizedBox(height: 25,),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: TextButton(style: TextButton.styleFrom(backgroundColor: Theme.of(context).accentColor,),
                    child: Text('Save',style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,

                    ),),
                    onPressed: (){
                      if(_formKey.currentState!.validate()){
                        saveCategory();
                      }
                    },
                  ),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }

}