import 'package:flutter/material.dart';
import 'package:quiz_app/constants.dart';

class SMHead extends StatefulWidget {
  const SMHead({Key? key}) : super(key: key);

  @override
  _SMHeadState createState() => _SMHeadState();
}

class _SMHeadState extends State<SMHead> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Card(
          color: yellow,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Text('Students List',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: whiteColor)),
                Spacer(),
                Container(
                  height: 40,
                  width: 100,
                  child: ElevatedButton.icon(
                      style:
                          ElevatedButton.styleFrom(primary: Colors.grey[500]),
                      onPressed: () {
                        print('ABC');
                        showAddForm();
                      },
                      icon: Icon(Icons.add),
                      label: Text('ADD  ')),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  ////////////////////// FORM //////////////////////

  showAddForm() {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container();
        });
  }
}
