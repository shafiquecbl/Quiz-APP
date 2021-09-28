import 'package:flutter/material.dart';

class NetworkError extends StatefulWidget {
  final Function()? onPressed;
  const NetworkError({@required this.onPressed});

  @override
  _NetworkErrorState createState() => _NetworkErrorState();
}

class _NetworkErrorState extends State<NetworkError> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Network Error!', textAlign: TextAlign.center),
          SizedBox(height: 10),
          IconButton(onPressed: widget.onPressed, icon: Icon(Icons.refresh))
        ],
      ),
    );
  }
}
