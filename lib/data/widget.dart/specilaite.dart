import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:ycmedical/data/widget.dart/list.dart';
import 'package:ycmedical/view/package/apptextfield.dart';

class SpecialiteList extends StatefulWidget {
  const SpecialiteList({super.key});

  @override
  State<SpecialiteList> createState() => _SpecialiteListState();
}

class _SpecialiteListState extends State<SpecialiteList> {
  TextEditingController spec = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AppTextField(
          cities: [
            for (var item in specialite) SelectedListItem(name: item),
          ],
          textEditingController: spec,
          title: "",
          hint: "spécialité",
          isCitySelected: true),
    );
  }
}
