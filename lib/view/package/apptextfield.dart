import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController textEditingController;
  final String title;
  final String hint;
  final bool isCitySelected;
  final List<SelectedListItem>? cities;

  const AppTextField({
    required this.textEditingController,
    required this.title,
    required this.hint,
    required this.isCitySelected,
    this.cities,
    Key? key,
  }) : super(key: key);

  @override
  _AppTextFieldState createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  /// This is on text changed method which will display on city text field on changed.
  void onTextFieldTap() {
    DropDownState(
      DropDown(
        dropDownBackgroundColor: Color.fromARGB(255, 237, 254, 255),
        isDismissible: true,
        data: widget.cities ?? [],
        selectedItems: (List<dynamic> selectedList) {
          print(selectedList.indexed);
          List<String> list = [];
          for (var item in selectedList) {
            if (item is SelectedListItem) {
              list.add(item.name);
              print(item.name);
              widget.textEditingController.text = item.name;
            }
          }
        },
        enableMultipleSelection: false,
      ),
    ).showModal(context);
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
          decoration: BoxDecoration(
            color: const Color.fromARGB(215, 255, 255, 255), // Background color
            borderRadius: BorderRadius.circular(25.0), // Border radius
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 137, 137, 137)
                    .withOpacity(0.6), // Couleur de l'ombre
                spreadRadius: 3,
                blurRadius: 7,
                offset: Offset(0, 5), // Déplace l'ombre vers le bas
              ),
            ],
          ),
          child: TextFormField(
            style: TextStyle(
              fontFamily: "FSPDemoUniformPro",
              fontSize: 15,
              color: Color.fromARGB(239, 89, 111, 114),
            ),
            controller: widget.textEditingController,
            cursorColor: Colors.black,
            onTap: widget.isCitySelected
                ? () {
                    FocusScope.of(context).unfocus();
                    onTextFieldTap();
                    setState(() {
                      print("La ville sélectionnée est : " +
                          widget.textEditingController.text);
                    });
                  }
                : null,
            decoration: InputDecoration(
              suffixIcon: Icon(
                Icons
                    .arrow_drop_down, // Replace with your desired icon from Material Icons
                size: 24.0,
                color: Color.fromARGB(
                    224, 89, 111, 114), // Set your desired color here
              ),

              hintText: widget.textEditingController.text == ""
                  ? widget.hint
                  : widget.textEditingController.text,

              hintStyle: TextStyle(
                fontFamily: "FSPDemoUniformPro",
                fontSize: 12,
                color: Color.fromARGB(224, 89, 111, 114),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 25),
              //alignLabelWithHint: true, // Center label vertically
            ),
          ),
        ),
      ],
    );
  }
}
