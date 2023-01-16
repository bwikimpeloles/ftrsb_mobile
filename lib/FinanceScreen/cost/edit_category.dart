import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditCategory extends StatefulWidget {
  String categoryKey;

  EditCategory({required this.categoryKey});

  @override
  _EditCategoryState createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  late TextEditingController _categoryController;
  final _formKey = GlobalKey<FormState>();
  late CollectionReference _ref;
  late String original;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _categoryController = TextEditingController();
    _ref = FirebaseFirestore.instance.collection('Category');
    getCategoryDetail();
  }

  getCategoryDetail() async {
    DocumentSnapshot snapshot = (await _ref.doc(widget.categoryKey).get());

    Map category = snapshot.data() as Map;
    
    original= category['category'];

    _categoryController.text = category['category'];

  }
  

  void saveCategory() async{
    String categorysave = _categoryController.text.trim();

    Map<String,String> categories = {
      'category':categorysave,
    };

    print("hello ${original}");

    await FirebaseFirestore.instance.collection('Cost').where('category', isEqualTo: original).get()
        .then((snapshot) async {
      for(DocumentSnapshot ds in snapshot.docs) {
        await ds.reference.update(categories);
        print(ds.reference);
      }
    });

    _ref.doc(widget.categoryKey).update(categories).then((value) {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Category'),
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20,),
                Text('Note: Editing category will also edit the category field in Cost', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
                SizedBox(height: 20,),
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
                      Icons.maps_home_work,
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
                    child: Text('Update Category',style: TextStyle(
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