import 'package:flutter/material.dart';
import '../../core/constants/theme.dart';
import '../../widgets/shared_widgets.dart';
import '../../widgets/tab_scaffold.dart';

// ═════════════════════════════════════════════
// PARENT SHELL
// ═════════════════════════════════════════════
class ParentShell extends StatelessWidget {
  final String userName;
  const ParentShell({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return TabScaffold(
      title: 'Parent Portal',
      accent: LumixColors.parent,
      accentSurface: LumixColors.parentSurface,
      userName: userName,
      tabs: [
        TabItem(label: 'Home',     icon: Icons.home_outlined,           activeIcon: Icons.home_rounded,           body: ParentHome(userName: userName)),
        TabItem(label: 'Progress', icon: Icons.trending_up_outlined,    activeIcon: Icons.trending_up_rounded,    body: const ParentProgressScreen()),
        TabItem(label: 'Messages', icon: Icons.message_outlined,        activeIcon: Icons.message_rounded,        body: const ParentMessagingScreen()),
        TabItem(label: 'Meetings', icon: Icons.event_outlined,          activeIcon: Icons.event_rounded,          body: const BookMeetingScreen()),
      ],
    );
  }
}

// ─── Parent Home ─────────────────────────────
class ParentHome extends StatelessWidget {
  final String userName;
  const ParentHome({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Hello,', style: LumixText.caption),
        const SizedBox(height: 4),
        Text(userName, style: LumixText.display),
        const SizedBox(height: 4),
        const Text("Here's a glance at your child's week.", style: LumixText.caption),
        const SizedBox(height: 28),

        // Weekly summary
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [LumixColors.parentSurface, LumixColors.bg800], begin: Alignment.topLeft, end: Alignment.bottomRight),
            border: Border.all(color: LumixColors.parent.withOpacity(0.3)), borderRadius: BorderRadius.circular(16),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('Weekly Summary', style: LumixText.title),
              const LumixChip(label: 'Week 14', color: LumixColors.parent),
            ]),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(child: _ParentStat('88%', 'Avg. Score', Icons.bar_chart_rounded)),
              Container(width: 1, height: 40, color: LumixColors.border),
              Expanded(child: _ParentStat('5/5', 'Attendance', Icons.check_circle_rounded)),
              Container(width: 1, height: 40, color: LumixColors.border),
              Expanded(child: _ParentStat('3', 'Tasks Done', Icons.task_alt_rounded)),
            ]),
          ]),
        ),
        const SizedBox(height: 24),

        // Alerts
        const LumixChip(label: '⚠  1 Alert', color: LumixColors.danger),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: LumixColors.dangerSurface, border: const Border(left: BorderSide(color: LumixColors.danger, width: 3)), borderRadius: const BorderRadius.only(topRight: Radius.circular(12), bottomRight: Radius.circular(12))),
          child: Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Physics at Risk', style: TextStyle(color: LumixColors.danger, fontWeight: FontWeight.w700, fontSize: 14)),
              const SizedBox(height: 2),
              const Text("Sarah's Physics score dropped to 58%. A revision plan has been assigned.", style: LumixText.caption),
            ])),
            const Icon(Icons.chevron_right_rounded, color: LumixColors.textMuted),
          ]),
        ),
        const SizedBox(height: 24),

        // Subject performance
        const Text('Subject Performance', style: LumixText.title),
        const SizedBox(height: 12),
        ...[
          {'subject': 'Mathematics', 'score': 85, 'trend': '+3%', 'up': true},
          {'subject': 'Science',     'score': 74, 'trend': '-2%', 'up': false},
          {'subject': 'English',     'score': 92, 'trend': '+5%', 'up': true},
          {'subject': 'Physics',     'score': 58, 'trend': '-8%', 'up': false},
          {'subject': 'History',     'score': 79, 'trend': '+1%', 'up': true},
        ].map((s) {
          final score = s['score'] as int;
          final up    = s['up'] as bool;
          final color = scoreColor(score);
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: LumixCard(child: Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(s['subject'] as String, style: LumixText.body.copyWith(fontWeight: FontWeight.w600)),
                  Text('$score%', style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 15)),
                ]),
                const SizedBox(height: 8),
                LumixScoreBar(value: score / 100, color: color),
              ])),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: (up ? LumixColors.success : LumixColors.danger).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(s['trend'] as String, style: TextStyle(color: up ? LumixColors.success : LumixColors.danger, fontSize: 11, fontWeight: FontWeight.w700)),
              ),
            ])),
          );
        }),
        const SizedBox(height: 24),

        // Quick actions
        const Text('Quick Actions', style: LumixText.title),
        const SizedBox(height: 14),
        GridView.count(
          crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.05,
          children: [
            _ActionCard('Messages',    '2 unread',         Icons.message_rounded,      LumixColors.parent,   () => push(context, const ParentMessagingScreen())),
            _ActionCard('Book Meeting','With teacher',      Icons.event_rounded,        Colors.tealAccent,    () => push(context, const BookMeetingScreen())),
            _ActionCard('Alerts',      '1 new flag',       Icons.notifications_rounded, LumixColors.danger,  () {}),
            _ActionCard('Attendance',  '100% this week',   Icons.fact_check_rounded,   LumixColors.success,  () {}),
          ],
        ),
      ]),
    );
  }
}

class _ParentStat extends StatelessWidget {
  final String value, label;
  final IconData icon;
  const _ParentStat(this.value, this.label, this.icon);
  @override
  Widget build(BuildContext context) => Column(children: [
    Icon(icon, color: LumixColors.parent, size: 18),
    const SizedBox(height: 6),
    Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: LumixColors.textPrimary)),
    Text(label, style: LumixText.caption.copyWith(fontSize: 10), textAlign: TextAlign.center),
  ]);
}

class _ActionCard extends StatelessWidget {
  final String title, subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _ActionCard(this.title, this.subtitle, this.icon, this.color, this.onTap);
  @override
  Widget build(BuildContext context) => LumixCard(
    onTap: onTap,
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, size: 24, color: color)),
      const SizedBox(height: 14),
      Text(title, style: LumixText.title.copyWith(fontSize: 14)),
      const SizedBox(height: 4),
      Text(subtitle, style: LumixText.caption.copyWith(fontSize: 11)),
      const SizedBox(height: 10),
      Row(children: [
        Text('Open', style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w700)),
        const SizedBox(width: 4),
        Icon(Icons.arrow_forward_rounded, size: 12, color: color),
      ]),
    ]),
  );
}

// ─── Parent Progress ─────────────────────────
class ParentProgressScreen extends StatelessWidget {
  const ParentProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Child profile
        LumixCard(glow: true, glowColor: LumixColors.parent, child: Row(children: [
          CircleAvatar(radius: 28, backgroundColor: LumixColors.parentSurface,
              child: const Text('S', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: LumixColors.parent))),
          const SizedBox(width: 16),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Sarah Johnson', style: LumixText.title),
            const SizedBox(height: 4),
            const Text('Grade 10 • Section A', style: LumixText.caption),
            const SizedBox(height: 6),
            Row(children: [
              const LumixChip(label: 'GPA 3.72', color: LumixColors.success),
              const SizedBox(width: 8),
              const LumixChip(label: 'Rank #4', color: LumixColors.parent),
            ]),
          ]),
        ])),
        const SizedBox(height: 20),

        const Text('Subject Performance', style: LumixText.title),
        const SizedBox(height: 12),
        ...[
          {'subject': 'Mathematics',  'score': 85, 'grade': 'A',  'trend': '+3%', 'up': true,  'weakTopics': ['Quadratic Equations']},
          {'subject': 'Science',      'score': 74, 'grade': 'B',  'trend': '-2%', 'up': false, 'weakTopics': ['Chemical Bonding', 'Ecosystems']},
          {'subject': 'English',      'score': 92, 'grade': 'A+', 'trend': '+5%', 'up': true,  'weakTopics': []},
          {'subject': 'Physics',      'score': 58, 'grade': 'C+', 'trend': '-8%', 'up': false, 'weakTopics': ['Kinematics', 'Thermodynamics', 'Optics']},
          {'subject': 'History',      'score': 79, 'grade': 'B+', 'trend': '+1%', 'up': true,  'weakTopics': ['WWI Context']},
        ].map((s) {
          final score = s['score'] as int;
          final color = scoreColor(score);
          final weak  = s['weakTopics'] as List;
          return Padding(padding: const EdgeInsets.only(bottom: 10),
            child: LumixCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(s['subject'] as String, style: LumixText.body.copyWith(fontWeight: FontWeight.w700)),
                Row(children: [
                  Text('${s['grade']}', style: LumixText.caption),
                  const SizedBox(width: 8),
                  Text('$score%', style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 16)),
                ]),
              ]),
              const SizedBox(height: 8),
              LumixScoreBar(value: score / 100, color: color),
              if (weak.isNotEmpty) ...[
                const SizedBox(height: 10),
                Wrap(spacing: 6, runSpacing: 4, children: weak.map((t) =>
                    Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: LumixColors.dangerSurface, border: Border.all(color: LumixColors.danger.withOpacity(0.35)), borderRadius: BorderRadius.circular(16)),
                        child: Text('⚠ $t', style: const TextStyle(color: LumixColors.danger, fontSize: 11, fontWeight: FontWeight.w600)))).toList(),
                ),
              ],
            ])),
          );
        }),

        const SizedBox(height: 20),
        const Text('Weekly Attendance', style: LumixText.title),
        const SizedBox(height: 12),
        LumixCard(child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('This Term', style: LumixText.body),
            const Text('95%', style: TextStyle(color: LumixColors.success, fontWeight: FontWeight.w800, fontSize: 18)),
          ]),
          const SizedBox(height: 10),
          const LumixScoreBar(value: 0.95, color: LumixColors.success, height: 7),
          const SizedBox(height: 12),
          Row(children: const [
            _AttMini('57 Present', LumixColors.success),
            SizedBox(width: 8),
            _AttMini('3 Absent', LumixColors.danger),
            SizedBox(width: 8),
            _AttMini('3 Late', LumixColors.warning),
          ]),
        ])),
      ],
    );
  }
}

class _AttMini extends StatelessWidget {
  final String text; final Color color;
  const _AttMini(this.text, this.color);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
    child: Text(text, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
  );
}

// ─── Parent Messaging ───────────────────────
class ParentMessagingScreen extends StatefulWidget {
  const ParentMessagingScreen({super.key});
  @override
  State<ParentMessagingScreen> createState() => _ParentMessagingScreenState();
}

class _ParentMessagingScreenState extends State<ParentMessagingScreen> {
  final _ctrl = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {'from': 'teacher', 'text': 'Hello! Sarah is doing really well in English this week. Her essay was excellent.', 'time': '9:30 AM'},
    {'from': 'parent',  'text': 'Thank you, that is great to hear! We have been working on it at home.', 'time': '9:45 AM'},
    {'from': 'teacher', 'text': 'Physics is still a concern though. Her score is 58%. I would like to schedule a call to discuss an intervention plan.', 'time': '9:46 AM'},
  ];

  void _send() {
    final t = _ctrl.text.trim();
    if (t.isEmpty) return;
    setState(() { _messages.add({'from': 'parent', 'text': t, 'time': 'Just now'}); _ctrl.clear(); });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LumixColors.bg900,
      appBar: AppBar(
        title: Row(children: [
          CircleAvatar(radius: 16, backgroundColor: LumixColors.parent.withOpacity(0.15),
              child: const Icon(Icons.person_rounded, size: 16, color: LumixColors.parent)),
          const SizedBox(width: 10),
          const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Ms. Rivera', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
            Text('Physics & Math Teacher', style: TextStyle(fontSize: 11, color: LumixColors.textSecondary)),
          ]),
        ]),
        backgroundColor: LumixColors.bg800,
        bottom: PreferredSize(preferredSize: const Size.fromHeight(1), child: Container(height: 1, color: LumixColors.border)),
      ),
      body: Column(children: [
        Expanded(child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _messages.length,
          itemBuilder: (context, i) {
            final m = _messages[i]; final isParent = m['from'] == 'parent';
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(mainAxisAlignment: isParent ? MainAxisAlignment.end : MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (!isParent) ...[
                    CircleAvatar(radius: 14, backgroundColor: LumixColors.parent.withOpacity(0.15),
                        child: const Icon(Icons.person_rounded, size: 12, color: LumixColors.parent)),
                    const SizedBox(width: 8),
                  ],
                  Flexible(child: Column(
                    crossAxisAlignment: isParent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.68),
                        decoration: BoxDecoration(
                          color: isParent ? LumixColors.parent : LumixColors.bg800,
                          border: isParent ? null : Border.all(color: LumixColors.border),
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(16), topRight: const Radius.circular(16),
                            bottomLeft: Radius.circular(isParent ? 16 : 4),
                            bottomRight: Radius.circular(isParent ? 4 : 16),
                          ),
                        ),
                        child: Text(m['text'] as String, style: TextStyle(fontSize: 14, color: isParent ? Colors.white : LumixColors.textPrimary, height: 1.5)),
                      ),
                      const SizedBox(height: 4),
                      Text(m['time'] as String, style: LumixText.caption.copyWith(fontSize: 10)),
                    ],
                  )),
                ],
              ),
            );
          },
        )),
        Container(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
          decoration: const BoxDecoration(color: LumixColors.bg800, border: const Border(top: BorderSide(color: LumixColors.border))),
          child: Row(children: [
            Expanded(child: TextField(
              controller: _ctrl, style: LumixText.body,
              decoration: InputDecoration(
                hintText: 'Type a message…',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                filled: true, fillColor: LumixColors.bg900,
                contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              ),
              onSubmitted: (_) => _send(),
            )),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _send,
              child: Container(width: 44, height: 44, decoration: const BoxDecoration(color: LumixColors.parent, shape: BoxShape.circle),
                  child: const Icon(Icons.send_rounded, color: Colors.white, size: 18)),
            ),
          ]),
        ),
      ]),
    );
  }
}

// ─── Book Meeting ────────────────────────────
class BookMeetingScreen extends StatefulWidget {
  const BookMeetingScreen({super.key});
  @override
  State<BookMeetingScreen> createState() => _BookMeetingScreenState();
}

class _BookMeetingScreenState extends State<BookMeetingScreen> {
  int? _selectedSlot;

  static const _slots = [
    {'day': 'Mon, 2 Jun', 'time': '10:00 AM', 'teacher': 'Ms. Rivera',  'subject': 'Physics & Math'},
    {'day': 'Mon, 2 Jun', 'time': '2:00 PM',  'teacher': 'Mr. Patel',   'subject': 'Science'},
    {'day': 'Tue, 3 Jun', 'time': '11:00 AM', 'teacher': 'Ms. Rivera',  'subject': 'Physics & Math'},
    {'day': 'Wed, 4 Jun', 'time': '3:30 PM',  'teacher': 'Dr. Singh',   'subject': 'Mathematics'},
    {'day': 'Thu, 5 Jun', 'time': '9:00 AM',  'teacher': 'Mr. Patel',   'subject': 'Science'},
    {'day': 'Fri, 6 Jun', 'time': '1:00 PM',  'teacher': 'Ms. Anand',   'subject': 'English'},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Available Meeting Slots', style: LumixText.title),
        const SizedBox(height: 4),
        const Text('Select a time with your child\'s teacher', style: LumixText.caption),
        const SizedBox(height: 16),
        ..._slots.asMap().entries.map((e) {
          final selected = _selectedSlot == e.key;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GestureDetector(
              onTap: () => setState(() => _selectedSlot = e.key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: selected ? LumixColors.parentSurface : LumixColors.bg800,
                  border: Border.all(color: selected ? LumixColors.parent : LumixColors.border, width: selected ? 1.5 : 1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(children: [
                  Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(
                      color: selected ? LumixColors.parent.withOpacity(0.2) : LumixColors.bg700, borderRadius: BorderRadius.circular(10)),
                      child: Icon(Icons.event_rounded, color: selected ? LumixColors.parent : LumixColors.textSecondary, size: 20)),
                  const SizedBox(width: 14),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('${e.value['day']} • ${e.value['time']}', style: LumixText.body.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text('with ${e.value['teacher']}', style: LumixText.caption),
                    const SizedBox(height: 2),
                    Text(e.value['subject']!, style: LumixText.label.copyWith(color: LumixColors.parent)),
                  ])),
                  selected
                      ? const Icon(Icons.check_circle_rounded, color: LumixColors.parent, size: 22)
                      : const Icon(Icons.radio_button_unchecked_rounded, color: LumixColors.textMuted, size: 22),
                ]),
              ),
            ),
          );
        }),
        const SizedBox(height: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: _selectedSlot != null ? LumixColors.parent : LumixColors.bg700,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          onPressed: _selectedSlot == null ? null : () {
            final slot = _slots[_selectedSlot!];
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('✅ Meeting booked on ${slot['day']} at ${slot['time']} with ${slot['teacher']}'),
              backgroundColor: LumixColors.parent, behavior: SnackBarBehavior.floating,
            ));
            setState(() => _selectedSlot = null);
          },
          child: const Text('Confirm Booking', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
        ),
      ],
    );
  }
}