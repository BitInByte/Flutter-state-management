import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class PlatformRefresh extends StatelessWidget {
  final Widget content;
  final Future<void> Function() onRefreshHandler;
  PlatformRefresh(this.content, this.onRefreshHandler);

  Widget _buildIos() {
    return CustomScrollView(
      /* physics: BouncingScrollPhysics(), */
      slivers: [
        CupertinoSliverRefreshControl(
          onRefresh: onRefreshHandler,
        ),
        /* SliverFillRemaining( */
        /* [> child: SafeArea(child: content), <] */
        /* child: content, */
        /* ) */
        /* SliverSafeArea(sliver: content) */
        /* SliverToBoxAdapter(child: SafeArea(child: content)) */
        /* SafeArea(child: SliverToBoxAdapter(child: content,),) */
        SliverToBoxAdapter(
          child: content,
        )
        /* SafeArea( */
        /* child: SliverToBoxAdapter( */
        /* child: content, */
        /* )), */
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
