import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/constants/theme.dart';
import 'shared_widgets.dart';

class TabItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final Widget body;
  const TabItem({required this.label, required this.icon, required this.activeIcon, required this.body});
}

class TabScaffold extends StatefulWidget {
  final List<TabItem> tabs;
  final String title;
  final Color accent;
  final String userName;
  final Color accentSurface;

  const TabScaffold({
    super.key,
    required this.tabs,
    required this.title,
    required this.accent,
    required this.userName,
    required this.accentSurface,
  });

  @override
  State<TabScaffold> createState() => _TabScaffoldState();
}

class _TabScaffoldState extends State<TabScaffold> {
  int _index = 0;
  bool _showNotif = false;

  static const _notifs = [
    {'icon': Icons.warning_amber_rounded,  'color': 0xFFEF4444, 'title': 'Risk Alert',        'body': 'Alex Johnson flagged — Physics grades dropping', 'time': '2m ago'},
    {'icon': Icons.assignment_outlined,    'color': 0xFFF59E0B, 'title': 'Assignment Due',     'body': 'Submit Math worksheet by 5 PM today',            'time': '1h ago'},
    {'icon': Icons.check_circle_outline,   'color': 0xFF22C55E, 'title': 'Quiz Completed',     'body': 'You scored 9/10 on the Kinematics quiz',         'time': '3h ago'},
    {'icon': Icons.message_outlined,       'color': 0xFF8B5CF6, 'title': 'Parent Message',     'body': 'Ms. Rivera sent a message about Sarah',          'time': '5h ago'},
    {'icon': Icons.event_outlined,         'color': 0xFF0EA5E9, 'title': 'Meeting Scheduled',  'body': 'Parent-teacher meeting at 2 PM tomorrow',        'time': '1d ago'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LumixColors.bg900,
      appBar: AppBar(
        backgroundColor: LumixColors.bg800,
        elevation: 0,
        bottom: PreferredSize(preferredSize: const Size.fromHeight(1), child: Container(height: 1, color: LumixColors.border)),
        title: Row(children: [
          const LumixLogo(size: 28),
          const SizedBox(width: 10),
          Text(widget.title, style: LumixText.title),
        ]),
        actions: [
          Stack(alignment: Alignment.center, children: [
            IconButton(
              icon: Icon(Icons.notifications_outlined, color: _showNotif ? widget.accent : LumixColors.textSecondary),
              onPressed: () => setState(() => _showNotif = !_showNotif),
            ),
            Positioned(top: 10, right: 10, child: Container(
              width: 8, height: 8,
              decoration: const BoxDecoration(color: LumixColors.danger, shape: BoxShape.circle),
            )),
          ]),
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: GestureDetector(
              onTap: () => _showProfileSheet(context),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: widget.accentSurface,
                child: Text(
                  widget.userName.isNotEmpty ? widget.userName[0].toUpperCase() : '?',
                  style: TextStyle(color: widget.accent, fontWeight: FontWeight.w800, fontSize: 14),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(children: [
        widget.tabs[_index].body,
        if (_showNotif) _notifOverlay(),
      ]),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: LumixColors.bg800,
          border: const Border(top: BorderSide(color: LumixColors.border)),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 60,
            child: Row(
              children: widget.tabs.asMap().entries.map((e) {
                final active = e.key == _index;
                return Expanded(child: GestureDetector(
                  onTap: () => setState(() { _index = e.key; _showNotif = false; }),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: active ? widget.accent.withOpacity(0.12) : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(active ? e.value.activeIcon : e.value.icon,
                              color: active ? widget.accent : LumixColors.textMuted, size: 22),
                        ),
                        const SizedBox(height: 2),
                        Text(e.value.label,
                            style: TextStyle(fontSize: 10, fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                                color: active ? widget.accent : LumixColors.textMuted)),
                      ],
                    ),
                  ),
                ));
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  void _showProfileSheet(BuildContext context) {
    showModalBottomSheet(
      context: context, backgroundColor: LumixColors.bg800,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 36, height: 4, decoration: BoxDecoration(color: LumixColors.border, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 20),
          CircleAvatar(radius: 32, backgroundColor: widget.accentSurface,
              child: Text(widget.userName.isNotEmpty ? widget.userName[0].toUpperCase() : '?',
                  style: TextStyle(color: widget.accent, fontSize: 26, fontWeight: FontWeight.w800))),
          const SizedBox(height: 12),
          Text(widget.userName, style: LumixText.headline),
          const SizedBox(height: 4),
          LumixChip(label: widget.title.toUpperCase(), color: widget.accent),
          const SizedBox(height: 24),
          SizedBox(width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: LumixColors.dangerSurface, foregroundColor: LumixColors.danger),
                onPressed: () { Navigator.pop(context); Supabase.instance.client.auth.signOut(); },
                icon: const Icon(Icons.logout_rounded, size: 18),
                label: const Text('Sign Out'),
              )),
        ]),
      ),
    );
  }

  Widget _notifOverlay() {
    return Positioned(
      top: 0, right: 0, left: 0,
      child: GestureDetector(
        onTap: () => setState(() => _showNotif = false),
        behavior: HitTestBehavior.opaque,
        child: Column(children: [
          GestureDetector(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.fromLTRB(8, 4, 8, 0),
              decoration: BoxDecoration(
                color: LumixColors.bg800, borderRadius: BorderRadius.circular(16),
                border: Border.all(color: LumixColors.border),
                boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 24, offset: Offset(0, 6))],
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    const Text('Notifications', style: LumixText.title),
                    TextButton(onPressed: () {}, child: Text('Mark all read', style: TextStyle(color: widget.accent, fontSize: 12, fontWeight: FontWeight.w700))),
                  ]),
                ),
                Container(height: 1, color: LumixColors.border),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 320),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: _notifs.length,
                    separatorBuilder: (_, __) => Container(height: 1, color: LumixColors.border),
                    itemBuilder: (context, i) {
                      final n = _notifs[i];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: Color(n['color'] as int).withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                          child: Icon(n['icon'] as IconData, color: Color(n['color'] as int), size: 18),
                        ),
                        title: Text(n['title'] as String, style: LumixText.body.copyWith(fontWeight: FontWeight.w700, fontSize: 14)),
                        subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const SizedBox(height: 2),
                          Text(n['body'] as String, style: LumixText.caption),
                          const SizedBox(height: 4),
                          Text(n['time'] as String, style: LumixText.label),
                        ]),
                      );
                    },
                  ),
                ),
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}