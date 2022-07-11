import 'package:flutter/material.dart';

class ProfileFollowing extends StatelessWidget {
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text('(un)trackabl.es', style: TextStyle(color: Colors.yellow)),
				bottom: TabBar(
					tabs: [
						Tab(icon: Icon(Icons.arrow_upward)),
						Tab(icon: Icon(Icons.arrow_downward))
					]
				)
			)
		);
	}
}
