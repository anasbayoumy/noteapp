import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final void Function()? ontap;
  final void Function()? onedit;
  final void Function() ondelete;

  const CustomCard(
      {super.key,
      required this.title,
      required this.content,
      this.ontap,
      this.onedit,
      required this.ondelete});

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Card(
        child: Row(
          children: [
            Expanded(
                flex: 1,
                child: Image.asset(
                  "images/logo_n.png",
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                )),
            Expanded(
                flex: 2,
                child: ListTile(
                  title: Text("$title"),
                  subtitle: Text("$content"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize
                        .min, // Ensures the row takes only the space it needs
                    children: [
                      IconButton(
                        onPressed: ondelete,
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                      IconButton(
                        onPressed: ondelete,
                        icon: Icon(
                          Icons.edit,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
