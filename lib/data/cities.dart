import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:ycmedical/data/widget.dart/list.dart';
import 'package:ycmedical/view/package/apptextfield.dart';

class CityList extends StatefulWidget {
  const CityList({super.key});

  @override
  State<CityList> createState() => _CityListState();
}

class _CityListState extends State<CityList> {
  TextEditingController Contry = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AppTextField(
          cities: [
            for (var item in ville) SelectedListItem(name: item),
          ],
          textEditingController: Contry,
          title: "select contry",
          hint: "Ville",
          isCitySelected: true),
    );
  }
}
