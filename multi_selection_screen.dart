import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import 'multi_select_controller.dart';

class MultiSelectionScreen extends StatefulWidget {
  const MultiSelectionScreen({Key? key}) : super(key: key);

  @override
  State<MultiSelectionScreen> createState() => _MultiSelectionScreenState();
}

class _MultiSelectionScreenState extends State<MultiSelectionScreen> {

  List mainList = [];
  MultiSelectController controller = new MultiSelectController();

  @override
  void initState() {
    super.initState();

    mainList.add({"key": "1"});
    mainList.add({"key": "2"});
    mainList.add({"key": "3"});
    mainList.add({"key": "4"});

    controller.disableEditingWhenNoneSelected = true;
    controller.set(mainList.length);
  }

  void add() {
    mainList.add({"key": mainList.length + 1});

    setState(() {
      controller.set(mainList.length);
    });
  }

  void delete() {
    var list = controller.selectedIndexes;
    list.sort((b, a) =>
        a.compareTo(b)); //reoder from biggest number, so it wont error
    list.forEach((element) {
      mainList.removeAt(element);
    });

    setState(() {
      controller.set(mainList.length);
    });
  }

  void selectAll() {
    setState(() {
      controller.toggleAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        //block app from quitting when selecting
        var before = !controller.isSelecting;
        setState(() {
          controller.deselectAll();
        });
        return before;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Selected ${controller.selectedIndexes.length}  ' +
              controller.selectedIndexes.toString()),
          actions: (controller.isSelecting)
              ? <Widget>[
            IconButton(
              icon: Icon(Icons.select_all),
              onPressed: selectAll,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: delete,
            )
          ]
              : <Widget>[],
        ),
        body: ListView.separated(
          itemCount: mainList.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {},
              child: MultiSelectItem(
                isSelecting: controller.isSelecting,
                onSelected: () {
                  setState(() {
                    controller.toggle(index);
                  });
                },
                child: Container(
                  child: ListTile(
                    title: Text(" Title ${mainList[index]['key']}"),
                    subtitle: Text("Description ${mainList[index]['key']}"),
                  ),
                  decoration: controller.isSelected(index)
                      ? BoxDecoration(color: Colors.grey[300])
                      : const BoxDecoration(),
                ),
              ),
            );
          }, separatorBuilder: (BuildContext context, int index) {
            return 10.height;
        },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: add,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
