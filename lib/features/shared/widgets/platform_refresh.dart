import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' hide RefreshCallback;

class PlatformRefresh extends StatelessWidget {
  final Widget content;
  final RefreshCallback onRefreshHandler;
  PlatformRefresh(this.content, this.onRefreshHandler);

  Widget _buildIos() {
    return CustomScrollView(
      slivers: [
        CupertinoSliverRefreshControl(
          onRefresh: onRefreshHandler,
        ),
        SliverToBoxAdapter(
          child: content,
        )
      ],
    );
  }

  Widget _buildAndroid() {
    return RefreshIndicator(
      onRefresh: onRefreshHandler,
      child: content,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS ? _buildIos() : _buildAndroid();
  }
}
