import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:ycmedical/view/package/apptextfield.dart';

class PaysList extends StatefulWidget {
  const PaysList({super.key});

  @override
  State<PaysList> createState() => _PaysListState();
}

class _PaysListState extends State<PaysList> {
  TextEditingController Pays = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AppTextField(
          cities: [
            SelectedListItem(name: "Tunisie"),
          ],
          textEditingController: Pays,
          title: "select contry",
          hint: "Pays",
          isCitySelected: true),
    );
  }
}
