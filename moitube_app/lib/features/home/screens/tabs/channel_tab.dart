import 'package:flutter/material.dart';

class ChannelTab extends StatefulWidget {
    const ChannelTab({super.key});

    @override
    State<ChannelTab> createState() => _ChannelTabState();
}

class _ChannelTabState extends State<ChannelTab> {
    @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Text('Channel'),
    );
  }
}