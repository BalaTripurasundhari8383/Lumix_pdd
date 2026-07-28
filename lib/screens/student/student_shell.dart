import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../core/constants/theme.dart';
import '../../widgets/shared_widgets.dart';
import '../../widgets/tab_scaffold.dart';

// ═════════════════════════════════════════════
// STUDENT SHELL
// ═════════════════════════════════════════════
class StudentShell extends StatelessWidget {
  final String userName;
  const StudentShell({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return TabScaffold(
      title: 'Student Portal',
      accent: LumixColors.student,
      accentSurface: LumixColors.studentSurface,
      userName: userName,
      tabs: [
        TabItem(label: 'Home',      icon: Icons.home_outlined,          activeIcon: Icons.home_rounded,              body: StudentHome(userName: userName)),
        TabItem(label: 'Grades',    icon: Icons.bar_chart_outlined,      activeIcon: Icons.bar_chart_rounded,         body: const StudentAnalyticsScreen()),
        TabItem(label: 'Calendar',  icon: Icons.calendar_month_outlined, activeIcon: Icons.calendar_month_rounded,    body: const StudentCalendarScreen()),
        TabItem(label: 'Quizzes',   icon: Icons.quiz_outlined,           activeIcon: Icons.quiz_rounded,              body: const QuizHubScreen()),
        TabItem(label: 'AI Tutor',  icon: Icons.smart_toy_outlined,      activeIcon: Icons.smart_toy_rounded,         body: const AITutorScreen()),
      ],
    );
  }
}

// ─── Student Home ────────────────────────────
class StudentHome extends StatelessWidget {
  final String userName;
  const StudentHome({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Welcome back,', style: LumixText.caption),
        const SizedBox(height: 4),
        Text(userName, style: LumixText.display),
        const SizedBox(height: 4),
        const Text('Ready to crush your goals today? 🎯', style: LumixText.caption),
        const SizedBox(height: 28),

        // GPA + streak row
        Row(children: [
          Expanded(flex: 2, child: LumixCard(
            color: LumixColors.studentSurface,
            glow: true, glowColor: LumixColors.student,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('Overall GPA', style: LumixText.caption),
                const LumixChip(label: '▲ +0.2', color: LumixColors.success),
              ]),
              const SizedBox(height: 10),
              const Text('3.72', style: TextStyle(fontSize: 44, fontWeight: FontWeight.w900, color: LumixColors.student, height: 1)),
              const SizedBox(height: 4),
              const Text('out of 4.0', style: LumixText.caption),
            ]),
          )),
          const SizedBox(width: 12),
          Expanded(child: Column(children: [
            LumixCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
              Icon(Icons.emoji_events_rounded, color: Color(0xFFFBBF24), size: 20),
              SizedBox(height: 6),
              Text('Rank', style: LumixText.caption),
              Text('#4', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: LumixColors.textPrimary)),
            ])),
            const SizedBox(height: 10),
            LumixCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
              Icon(Icons.local_fire_department_rounded, color: Colors.deepOrangeAccent, size: 20),
              SizedBox(height: 6),
              Text('Streak', style: LumixText.caption),
              Text('7 days', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: LumixColors.textPrimary)),
            ])),
          ])),
        ]),
        const SizedBox(height: 28),

        // Weak topics banner
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [LumixColors.dangerSurface, LumixColors.bg800], begin: Alignment.topLeft, end: Alignment.bottomRight),
            border: Border.all(color: LumixColors.danger.withOpacity(0.3)), borderRadius: BorderRadius.circular(14),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: LumixColors.danger.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.trending_down_rounded, color: LumixColors.danger, size: 18)),
              const SizedBox(width: 10),
              const Text('Topics Needing Attention', style: TextStyle(color: LumixColors.danger, fontWeight: FontWeight.w700, fontSize: 14)),
            ]),
            const SizedBox(height: 12),
            Wrap(spacing: 8, runSpacing: 8, children: [
              'Kinematics', 'Quadratic Eq.', 'Thermodynamics', 'Chemical Bonding'
            ].map((t) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: LumixColors.danger.withOpacity(0.1), border: Border.all(color: LumixColors.danger.withOpacity(0.4)), borderRadius: BorderRadius.circular(20)),
              child: Text(t, style: const TextStyle(color: LumixColors.danger, fontSize: 12, fontWeight: FontWeight.w600)),
            )).toList()),
          ]),
        ),
        const SizedBox(height: 24),

        // Study tasks
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text("Today's Study Tasks", style: LumixText.title),
          const Text('2 / 4 done', style: LumixText.caption),
        ]),
        const SizedBox(height: 12),
        const _StudyTaskList(),
        const SizedBox(height: 24),

        // Quick access grid
        const Text('Quick Access', style: LumixText.title),
        const SizedBox(height: 14),
        GridView.count(
          crossAxisCount: 2, shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.05,
          children: [
            _ActionCard('My Grades',    '6 subjects tracked',   Icons.bar_chart_rounded,    LumixColors.student,  () => push(context, const StudentAnalyticsScreen())),
            _ActionCard('Exam Calendar','Upcoming exams',        Icons.calendar_month_rounded, LumixColors.info,   () => push(context, const StudentCalendarScreen())),
            _ActionCard('Quizzes',      'Adaptive difficulty',  Icons.quiz_rounded,          Colors.orangeAccent,  () => push(context, const QuizHubScreen())),
            _ActionCard('AI Tutor',     'Ask anything',         Icons.smart_toy_rounded,    Colors.purpleAccent,   () => push(context, const AITutorScreen())),
            _ActionCard('Study Plan',   'Personalised for you', Icons.menu_book_rounded,     Colors.tealAccent,    () => push(context, const AIStudyPlanScreen())),
            _ActionCard('Attendance',   '95% this term',        Icons.fact_check_rounded,    LumixColors.success,  () => push(context, const AttendanceScreen())),
          ],
        ),
      ]),
    );
  }
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

// ─── Study Task List ────────────────────────
class _StudyTaskList extends StatefulWidget {
  const _StudyTaskList();
  @override
  State<_StudyTaskList> createState() => _StudyTaskListState();
}

class _StudyTaskListState extends State<_StudyTaskList> {
  final List<Map<String, dynamic>> _tasks = [
    {'label': 'Revise Kinematics Chapter 3',   'subject': 'Physics',     'done': true},
    {'label': 'Complete Algebra worksheet',    'subject': 'Mathematics', 'done': true},
    {'label': 'Read Shakespeare Essay notes',  'subject': 'English',     'done': false},
    {'label': 'Practice 10 Science questions', 'subject': 'Science',     'done': false},
  ];

  @override
  Widget build(BuildContext context) => LumixCard(
    child: Column(
      children: _tasks.asMap().entries.map((e) {
        final i = e.key; final t = e.value;
        return Column(children: [
          Row(children: [
            GestureDetector(
              onTap: () => setState(() => _tasks[i]['done'] = !_tasks[i]['done']),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 22, height: 22,
                decoration: BoxDecoration(
                  color: t['done'] ? LumixColors.student : Colors.transparent,
                  border: Border.all(color: t['done'] ? LumixColors.student : LumixColors.border, width: 2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: t['done'] ? const Icon(Icons.check_rounded, size: 14, color: Colors.white) : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(t['label'] as String,
                  style: LumixText.body.copyWith(
                    decoration: t['done'] ? TextDecoration.lineThrough : null,
                    color: t['done'] ? LumixColors.textSecondary : LumixColors.textPrimary,
                    fontSize: 13,
                  )),
              const SizedBox(height: 2),
              Text(t['subject'] as String, style: LumixText.label.copyWith(fontSize: 10)),
            ])),
          ]),
          if (i < _tasks.length - 1) Container(margin: const EdgeInsets.symmetric(vertical: 10), height: 1, color: LumixColors.border),
        ]);
      }).toList(),
    ),
  );
}

// ─── Student Analytics ───────────────────────
class StudentAnalyticsScreen extends StatelessWidget {
  const StudentAnalyticsScreen({super.key});

  static const _subjects = [
    {
      'title': 'Physics',      'score': 58, 'grade': 'C+', 'icon': Icons.bolt_rounded,
      'weak': ['Kinematics', 'Thermodynamics', 'Optics'], 'strong': ['Forces']
    },
    {
      'title': 'Mathematics',  'score': 85, 'grade': 'A',  'icon': Icons.calculate_rounded,
      'weak': ['Quadratic Equations'], 'strong': ['Algebra', 'Statistics', 'Calculus']
    },
    {
      'title': 'Science',      'score': 72, 'grade': 'B',  'icon': Icons.science_rounded,
      'weak': ['Chemical Bonding', 'Ecosystems'], 'strong': ['Force & Motion', 'Cells']
    },
    {
      'title': 'English',      'score': 92, 'grade': 'A+', 'icon': Icons.book_rounded,
      'weak': [], 'strong': ['Grammar', 'Comprehension', 'Literature', 'Essay Writing']
    },
    {
      'title': 'History',      'score': 79, 'grade': 'B+', 'icon': Icons.account_balance_rounded,
      'weak': ['World War I Context'], 'strong': ['Ancient Civilisations', 'Modern India']
    },
    {
      'title': 'Computer Sc.', 'score': 98, 'grade': 'A+', 'icon': Icons.computer_rounded,
      'weak': [], 'strong': ['Programming', 'Algorithms', 'Databases', 'Networks']
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Summary row
        Row(children: [
          Expanded(child: _StatCard('3.72', 'GPA', Icons.star_rounded, LumixColors.student)),
          const SizedBox(width: 12),
          Expanded(child: _StatCard('#4', 'Rank', Icons.emoji_events_rounded, Color(0xFFFBBF24))),
          const SizedBox(width: 12),
          Expanded(child: _StatCard('95%', 'Attendance', Icons.fact_check_rounded, LumixColors.success)),
        ]),
        const SizedBox(height: 24),
        const Text('Subject Performance & Topics', style: LumixText.title),
        const SizedBox(height: 14),
        ..._subjects.map((s) {
          final score = s['score'] as int;
          final color = scoreColor(score);
          final weak   = s['weak'] as List;
          final strong = s['strong'] as List;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: LumixCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: LumixColors.student.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
                    child: Icon(s['icon'] as IconData, color: LumixColors.student, size: 20)),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(s['title'] as String, style: LumixText.body.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  LumixScoreBar(value: score / 100, color: color, height: 6),
                ])),
                const SizedBox(width: 14),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text('$score%', style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 18)),
                  const SizedBox(height: 2),
                  Text(s['grade'] as String, style: LumixText.caption),
                ]),
              ]),
              if (weak.isNotEmpty) ...[
                const SizedBox(height: 14),
                Text('Needs Work:', style: LumixText.caption.copyWith(color: LumixColors.danger, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Wrap(spacing: 6, runSpacing: 4, children: weak.map((t) =>
                    Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: LumixColors.dangerSurface, border: Border.all(color: LumixColors.danger.withOpacity(0.4)), borderRadius: BorderRadius.circular(16)),
                        child: Text(t as String, style: const TextStyle(color: LumixColors.danger, fontSize: 11, fontWeight: FontWeight.w600)))).toList(),
                ),
              ],
              if (strong.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text('Strong At:', style: LumixText.caption.copyWith(color: LumixColors.success, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Wrap(spacing: 6, runSpacing: 4, children: strong.map((t) =>
                    Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: LumixColors.successSurface, border: Border.all(color: LumixColors.success.withOpacity(0.4)), borderRadius: BorderRadius.circular(16)),
                        child: Text(t as String, style: const TextStyle(color: LumixColors.success, fontSize: 11, fontWeight: FontWeight.w600)))).toList(),
                ),
              ],
            ])),
          );
        }),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value, label;
  final IconData icon;
  final Color color;
  const _StatCard(this.value, this.label, this.icon, this.color);
  @override
  Widget build(BuildContext context) => LumixCard(
    glowColor: color, glow: true,
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, color: color, size: 20),
      const SizedBox(height: 10),
      Text(value, style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.w800)),
      const SizedBox(height: 2),
      Text(label, style: LumixText.caption.copyWith(fontSize: 11)),
    ]),
  );
}

// ─── Student Calendar ────────────────────────
class StudentCalendarScreen extends StatefulWidget {
  const StudentCalendarScreen({super.key});
  @override
  State<StudentCalendarScreen> createState() => _StudentCalendarScreenState();
}

class _StudentCalendarScreenState extends State<StudentCalendarScreen> {
  int _selectedDay = DateTime.now().day;

  static const _events = [
    {'day': 2,  'title': 'Physics Unit Test',     'time': '9:00 AM',  'type': 'exam',     'color': 0xFFEF4444},
    {'day': 5,  'title': 'Math Assignment Due',   'time': '11:59 PM', 'type': 'homework', 'color': 0xFFF59E0B},
    {'day': 7,  'title': 'English Essay Due',     'time': '5:00 PM',  'type': 'homework', 'color': 0xFFF59E0B},
    {'day': 10, 'title': 'Science Practical',     'time': '2:00 PM',  'type': 'practical','color': 0xFF8B5CF6},
    {'day': 14, 'title': 'Mid-Term Examinations', 'time': 'All Week',  'type': 'exam',     'color': 0xFFEF4444},
    {'day': 18, 'title': 'Parent-Teacher Meeting','time': '4:00 PM',  'type': 'meeting',  'color': 0xFF0EA5E9},
    {'day': 22, 'title': 'Computer Science Test', 'time': '10:00 AM', 'type': 'exam',     'color': 0xFFEF4444},
    {'day': 28, 'title': 'History Project Due',   'time': '5:00 PM',  'type': 'homework', 'color': 0xFFF59E0B},
  ];

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);
    final firstWeekday = DateTime(now.year, now.month, 1).weekday % 7;
    final eventDays = _events.map((e) => e['day'] as int).toSet();
    final dayEvents = _events.where((e) => e['day'] == _selectedDay).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        LumixCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('${_monthName(now.month)} ${now.year}', style: LumixText.title),
            LumixChip(label: '${_events.length} events', color: LumixColors.student),
          ]),
          const SizedBox(height: 16),
          Row(children: ['S','M','T','W','T','F','S'].map((d) => Expanded(child:
          Text(d, style: LumixText.label, textAlign: TextAlign.center))).toList()),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, mainAxisSpacing: 4, crossAxisSpacing: 2),
            itemCount: firstWeekday + daysInMonth,
            itemBuilder: (_, i) {
              if (i < firstWeekday) return const SizedBox.shrink();
              final day = i - firstWeekday + 1;
              final isToday = day == now.day;
              final isSelected = day == _selectedDay;
              final hasEvent = eventDays.contains(day);
              return GestureDetector(
                onTap: () => setState(() => _selectedDay = day),
                child: Container(
                  margin: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: isSelected ? LumixColors.student : isToday ? LumixColors.student.withOpacity(0.2) : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text('$day', style: TextStyle(
                      color: isSelected ? Colors.white : isToday ? LumixColors.student : LumixColors.textPrimary,
                      fontWeight: (isSelected || isToday) ? FontWeight.w800 : FontWeight.w400,
                      fontSize: 13,
                    )),
                    if (hasEvent) Container(width: 4, height: 4, decoration: const BoxDecoration(color: LumixColors.danger, shape: BoxShape.circle)),
                  ]),
                ),
              );
            },
          ),
        ])),
        const SizedBox(height: 20),

        Text(
          dayEvents.isEmpty ? 'No events on day $_selectedDay' : 'Events on ${_monthName(now.month)} $_selectedDay',
          style: LumixText.title,
        ),
        const SizedBox(height: 12),
        if (dayEvents.isEmpty)
          Center(child: Padding(padding: const EdgeInsets.all(32),
              child: Column(children: [
                Icon(Icons.event_available_rounded, size: 48, color: LumixColors.textMuted),
                const SizedBox(height: 12),
                const Text('Free day! 🎉', style: LumixText.caption),
              ]))),
        ...dayEvents.map((e) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: LumixCard(padding: const EdgeInsets.all(16), child: Row(children: [
            Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(
                color: Color(e['color'] as int).withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
                child: Icon(_eventIcon(e['type'] as String), color: Color(e['color'] as int), size: 20)),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(e['title'] as String, style: LumixText.body.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(e['time'] as String, style: LumixText.caption),
            ])),
            LumixChip(label: (e['type'] as String).toUpperCase(), color: Color(e['color'] as int)),
          ])),
        )),
        const SizedBox(height: 20),
        const Text('All Upcoming Events', style: LumixText.title),
        const SizedBox(height: 12),
        ..._events.map((e) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: LumixCard(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), child: Row(children: [
            Container(width: 40, height: 40, decoration: BoxDecoration(color: Color(e['color'] as int).withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
                child: Center(child: Text('${e['day']}', style: TextStyle(color: Color(e['color'] as int), fontWeight: FontWeight.w900, fontSize: 14)))),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(e['title'] as String, style: LumixText.body.copyWith(fontWeight: FontWeight.w600, fontSize: 13)),
              Text('${_monthName(now.month)} ${e['day']} • ${e['time']}', style: LumixText.caption.copyWith(fontSize: 11)),
            ])),
            LumixChip(label: (e['type'] as String).toUpperCase(), color: Color(e['color'] as int)),
          ])),
        )),
      ],
    );
  }

  String _monthName(int m) {
    const names = ['','Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return names[m];
  }

  IconData _eventIcon(String type) {
    switch(type) {
      case 'exam': return Icons.assignment_rounded;
      case 'homework': return Icons.edit_note_rounded;
      case 'practical': return Icons.science_rounded;
      case 'meeting': return Icons.people_rounded;
      default: return Icons.event_rounded;
    }
  }
}

// ─── Attendance Screen ───────────────────────
class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  static const _months = [
    {
      'month': 'June 2025', 'present': 18, 'absent': 2, 'late': 1,
      'records': [
        {'date': 'Jun 1', 'status': 'present'},  {'date': 'Jun 2', 'status': 'present'},
        {'date': 'Jun 3', 'status': 'absent'},   {'date': 'Jun 4', 'status': 'present'},
        {'date': 'Jun 5', 'status': 'late'},     {'date': 'Jun 8', 'status': 'present'},
        {'date': 'Jun 9', 'status': 'present'},  {'date': 'Jun 10', 'status': 'absent'},
      ],
    },
    {
      'month': 'May 2025', 'present': 20, 'absent': 1, 'late': 0,
      'records': [],
    },
    {
      'month': 'April 2025', 'present': 19, 'absent': 0, 'late': 2,
      'records': [],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Attendance Record'), backgroundColor: LumixColors.bg800,
          bottom: PreferredSize(preferredSize: const Size.fromHeight(1), child: Container(height: 1, color: LumixColors.border))),
      backgroundColor: LumixColors.bg900,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          LumixCard(glow: true, glowColor: LumixColors.success, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('This Term', style: LumixText.caption),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: _AttStat('57', 'Present', LumixColors.success)),
              Container(width: 1, height: 40, color: LumixColors.border),
              Expanded(child: _AttStat('3', 'Absent', LumixColors.danger)),
              Container(width: 1, height: 40, color: LumixColors.border),
              Expanded(child: _AttStat('3', 'Late', LumixColors.warning)),
            ]),
            const SizedBox(height: 14),
            const LumixScoreBar(value: 0.95, color: LumixColors.success, height: 8),
            const SizedBox(height: 6),
            const Text('95% attendance rate', style: LumixText.caption),
          ])),
          const SizedBox(height: 20),

          ..._months.map((m) {
            final records = m['records'] as List;
            final total = (m['present'] as int) + (m['absent'] as int) + (m['late'] as int);
            final pct = (m['present'] as int) / total;
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: LumixCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(m['month'] as String, style: LumixText.title.copyWith(fontSize: 15)),
                  Text('${(pct * 100).round()}%', style: TextStyle(color: scoreColor((pct * 100).round()), fontWeight: FontWeight.w800, fontSize: 16)),
                ]),
                const SizedBox(height: 10),
                LumixScoreBar(value: pct, color: scoreColor((pct * 100).round()), height: 5),
                const SizedBox(height: 12),
                Row(children: [
                  _AttMini('${m['present']} Present', LumixColors.success),
                  const SizedBox(width: 10),
                  _AttMini('${m['absent']} Absent', LumixColors.danger),
                  const SizedBox(width: 10),
                  _AttMini('${m['late']} Late', LumixColors.warning),
                ]),
                if (records.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  const Text('This month:', style: LumixText.label),
                  const SizedBox(height: 8),
                  Wrap(spacing: 6, runSpacing: 6, children: records.map((r) {
                    final status = r['status'] as String;
                    final color = status == 'present' ? LumixColors.success : status == 'absent' ? LumixColors.danger : LumixColors.warning;
                    final icon  = status == 'present' ? Icons.check_rounded : status == 'absent' ? Icons.close_rounded : Icons.schedule_rounded;
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(color: color.withOpacity(0.1), border: Border.all(color: color.withOpacity(0.4)), borderRadius: BorderRadius.circular(8)),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(icon, size: 12, color: color),
                        const SizedBox(width: 4),
                        Text(r['date'] as String, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
                      ]),
                    );
                  }).toList()),
                ],
              ])),
            );
          }),
        ],
      ),
    );
  }
}

class _AttStat extends StatelessWidget {
  final String value, label;
  final Color color;
  const _AttStat(this.value, this.label, this.color);
  @override
  Widget build(BuildContext context) => Column(children: [
    Text(value, style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 22)),
    const SizedBox(height: 2),
    Text(label, style: LumixText.caption.copyWith(fontSize: 11)),
  ]);
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

// ─── AI Study Plan ───────────────────────────
class AIStudyPlanScreen extends StatelessWidget {
  const AIStudyPlanScreen({super.key});

  static const _plan = [
    {'subject': 'Physics',     'task': 'Kinematics — Chapter 3 summary + 15 practice problems', 'priority': 'High',   'time': '45 min'},
    {'subject': 'Physics',     'task': 'Thermodynamics — Revise core laws & equations',          'priority': 'High',   'time': '30 min'},
    {'subject': 'Mathematics', 'task': 'Quadratic equations worksheet — pages 44–52',            'priority': 'Medium', 'time': '30 min'},
    {'subject': 'Science',     'task': 'Chemical Bonding — review ionic vs covalent',            'priority': 'Medium', 'time': '25 min'},
    {'subject': 'English',     'task': 'Read pages 80–100 of Hamlet + annotations',             'priority': 'Low',    'time': '20 min'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Study Plan'), backgroundColor: LumixColors.bg800,
          bottom: PreferredSize(preferredSize: const Size.fromHeight(1), child: Container(height: 1, color: LumixColors.border))),
      backgroundColor: LumixColors.bg900,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [LumixColors.studentSurface, LumixColors.bg800], begin: Alignment.topLeft, end: Alignment.bottomRight),
              border: Border.all(color: LumixColors.student.withOpacity(0.3)), borderRadius: BorderRadius.circular(14),
            ),
            child: Row(children: [
              Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: LumixColors.student.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.auto_awesome_rounded, color: LumixColors.student, size: 22)),
              const SizedBox(width: 12),
              const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Lumix AI Insight', style: TextStyle(color: LumixColors.student, fontSize: 13, fontWeight: FontWeight.w700)),
                SizedBox(height: 4),
                Text('Based on your recent scores, Physics needs the most attention. Focus there first to maximise your grade improvement!', style: LumixText.caption),
              ])),
            ]),
          ),
          const SizedBox(height: 20),
          const Text("This Week's Plan", style: LumixText.title),
          const SizedBox(height: 12),
          ..._plan.map((item) {
            final pColor = item['priority'] == 'High' ? LumixColors.danger : item['priority'] == 'Medium' ? LumixColors.warning : LumixColors.success;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: LumixCard(child: Row(children: [
                Container(width: 4, height: 56, decoration: BoxDecoration(color: pColor, borderRadius: BorderRadius.circular(2))),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(item['subject']!, style: TextStyle(color: LumixColors.student, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                  const SizedBox(height: 3),
                  Text(item['task']!, style: LumixText.body.copyWith(fontSize: 13)),
                ])),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text(item['time']!, style: LumixText.caption),
                  const SizedBox(height: 4),
                  LumixChip(label: item['priority']!, color: pColor),
                ]),
              ])),
            );
          }),
        ],
      ),
    );
  }
}

// ─── Quiz Hub ───────────────────────────────
class QuizHubScreen extends StatelessWidget {
  const QuizHubScreen({super.key});

  static const _quizzes = [
    {'title': 'Physics — Kinematics',      'questions': 10, 'difficulty': 'Hard',   'time': '15 min', 'color': 0xFFEF4444, 'icon': Icons.bolt_rounded,      'tag': 'Weak Topic'},
    {'title': 'Physics — Thermodynamics',  'questions': 8,  'difficulty': 'Hard',   'time': '12 min', 'color': 0xFFEF4444, 'icon': Icons.bolt_rounded,      'tag': 'Weak Topic'},
    {'title': 'Math — Quadratic Eq.',      'questions': 10, 'difficulty': 'Medium', 'time': '15 min', 'color': 0xFFF59E0B, 'icon': Icons.calculate_rounded, 'tag': 'Needs Work'},
    {'title': 'Science — Chemical Bonding','questions': 8,  'difficulty': 'Medium', 'time': '12 min', 'color': 0xFFF59E0B, 'icon': Icons.science_rounded,   'tag': 'Needs Work'},
    {'title': 'English — Grammar Review',  'questions': 15, 'difficulty': 'Easy',   'time': '10 min', 'color': 0xFF22C55E, 'icon': Icons.book_rounded,      'tag': 'Strength'},
    {'title': 'Computer Sc. — Algorithms', 'questions': 10, 'difficulty': 'Medium', 'time': '15 min', 'color': 0xFF8B5CF6, 'icon': Icons.computer_rounded,  'tag': 'Practice'},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [LumixColors.studentSurface, LumixColors.bg800], begin: Alignment.topLeft, end: Alignment.bottomRight),
            border: Border.all(color: LumixColors.student.withOpacity(0.3)), borderRadius: BorderRadius.circular(12),
          ),
          child: Row(children: [
            Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: LumixColors.student.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.auto_awesome_rounded, color: LumixColors.student, size: 18)),
            const SizedBox(width: 12),
            const Expanded(child: Text('AI has selected quizzes targeting your weak topics. Start with Physics for max impact!', style: LumixText.caption)),
          ]),
        ),
        const SizedBox(height: 16),
        const Text('Available Quizzes', style: LumixText.title),
        const SizedBox(height: 12),
        ..._quizzes.map((q) {
          final color = Color(q['color'] as int);
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: LumixCard(
              onTap: () => push(context, QuizScreen(quizTitle: q['title'] as String)),
              child: Row(children: [
                Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
                    child: Icon(q['icon'] as IconData, color: color, size: 24)),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(q['title'] as String, style: LumixText.body.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text('${q['questions']} questions • ${q['time']}', style: LumixText.caption.copyWith(fontSize: 12)),
                  const SizedBox(height: 6),
                  Row(children: [
                    LumixChip(label: q['difficulty'] as String, color: color),
                    const SizedBox(width: 6),
                    LumixChip(label: q['tag'] as String, color: LumixColors.textSecondary),
                  ]),
                ])),
                Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
                    child: Icon(Icons.play_arrow_rounded, color: color, size: 20)),
              ]),
            ),
          );
        }),
      ],
    );
  }
}

// ─── Quiz Screen ────────────
class QuizScreen extends StatefulWidget {
  final String quizTitle;
  const QuizScreen({super.key, required this.quizTitle});
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  static const _questions = [
    {
      'q': 'A car accelerates from rest at 4 m/s². What is its velocity after 5 seconds?',
      'choices': ['10 m/s', '20 m/s', '25 m/s', '16 m/s'], 'correct': 1,
      'explanation': 'v = u + at = 0 + 4×5 = 20 m/s',
    },
    {
      'q': 'Which equation correctly represents displacement in uniform acceleration?',
      'choices': ['s = ut + ½at²', 's = vt - ½at²', 's = ½at', 's = v²/a'], 'correct': 0,
      'explanation': 's = ut + ½at² is the standard kinematic displacement equation.',
    }
  ];

  int _qIdx = 0;
  int? _selected;
  bool _revealed = false;
  int _score = 0;
  bool _finished = false;
  int _timeLeft = 30;
  Timer? _timer;

  @override
  void initState() { super.initState(); _startTimer(); }

  void _startTimer() {
    _timeLeft = 30; _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_timeLeft <= 1) { t.cancel(); if (!_revealed) _reveal(); }
      else setState(() => _timeLeft--);
    });
  }

  void _reveal() { _timer?.cancel(); setState(() => _revealed = true); }

  void _pick(int i) {
    if (_revealed) return; _timer?.cancel();
    setState(() { _selected = i; _revealed = true; });
    if (i == _questions[_qIdx]['correct']) _score++;
  }

  void _next() {
    if (_qIdx < _questions.length - 1) {
      setState(() { _qIdx++; _selected = null; _revealed = false; });
      _startTimer();
    } else {
      setState(() => _finished = true);
    }
  }

  Color _choiceColor(int i) {
    if (!_revealed) return _selected == i ? LumixColors.student : LumixColors.bg800;
    if (i == _questions[_qIdx]['correct']) return const Color(0xFF14532D);
    if (_selected == i) return const Color(0xFF7F1D1D);
    return LumixColors.bg800;
  }

  Color _choiceBorder(int i) {
    if (!_revealed) return _selected == i ? LumixColors.student : LumixColors.border;
    if (i == _questions[_qIdx]['correct']) return LumixColors.success;
    if (_selected == i) return LumixColors.danger;
    return LumixColors.border;
  }

  @override
  void dispose() { _timer?.cancel(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    if (_finished) {
      final pct = _score / _questions.length;
      return Scaffold(
        backgroundColor: LumixColors.bg900,
        appBar: AppBar(title: const Text('Quiz Complete'), backgroundColor: LumixColors.bg800,
            bottom: PreferredSize(preferredSize: const Size.fromHeight(1), child: Container(height: 1, color: LumixColors.border))),
        body: Center(child: Padding(padding: const EdgeInsets.all(32), child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [pct >= 0.7 ? LumixColors.successSurface : LumixColors.dangerSurface, LumixColors.bg800]),
                    shape: BoxShape.circle),
                child: Icon(pct >= 0.7 ? Icons.emoji_events_rounded : Icons.replay_rounded, size: 56, color: pct >= 0.7 ? LumixColors.success : LumixColors.danger)),
            const SizedBox(height: 24),
            Text('Quiz Complete!', style: LumixText.headline),
            const SizedBox(height: 8),
            Text('$_score / ${_questions.length}', style: LumixText.display.copyWith(color: pct >= 0.7 ? LumixColors.success : LumixColors.danger)),
            const SizedBox(height: 32),
            Row(children: [
              Expanded(child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(foregroundColor: LumixColors.student, side: const BorderSide(color: LumixColors.student), padding: const EdgeInsets.symmetric(vertical: 14)),
                onPressed: () => setState(() { _qIdx = 0; _selected = null; _revealed = false; _score = 0; _finished = false; _startTimer(); }),
                icon: const Icon(Icons.replay_rounded, size: 16),
                label: const Text('Retry'),
              )),
              const SizedBox(width: 12),
              Expanded(child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: LumixColors.student, padding: const EdgeInsets.symmetric(vertical: 14)),
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_rounded, size: 16),
                label: const Text('Back'),
              )),
            ]),
          ],
        ))),
      );
    }

    final q = _questions[_qIdx];
    final timerColor = _timeLeft > 15 ? LumixColors.success : _timeLeft > 7 ? LumixColors.warning : LumixColors.danger;

    return Scaffold(
      backgroundColor: LumixColors.bg900,
      appBar: AppBar(
        title: Text(widget.quizTitle, style: LumixText.caption.copyWith(color: LumixColors.textPrimary)),
        backgroundColor: LumixColors.bg800,
        bottom: PreferredSize(preferredSize: const Size.fromHeight(1), child: Container(height: 1, color: LumixColors.border)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Question ${_qIdx + 1} of ${_questions.length}', style: LumixText.caption.copyWith(color: LumixColors.student, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(
                value: (_qIdx + 1) / _questions.length, minHeight: 5,
                backgroundColor: LumixColors.border, valueColor: const AlwaysStoppedAnimation(LumixColors.student),
              )),
            ])),
            const SizedBox(width: 16),
            SizedBox(width: 50, height: 50, child: Stack(alignment: Alignment.center, children: [
              CircularProgressIndicator(value: _timeLeft / 30, strokeWidth: 3.5, backgroundColor: LumixColors.border, valueColor: AlwaysStoppedAnimation(timerColor)),
              Text('$_timeLeft', style: TextStyle(color: timerColor, fontWeight: FontWeight.w900, fontSize: 14)),
            ])),
          ]),
          const SizedBox(height: 24),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(color: LumixColors.student.withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
                child: Text('Score: $_score / ${_qIdx + (_revealed ? 1 : 0)}', style: const TextStyle(color: LumixColors.student, fontSize: 12, fontWeight: FontWeight.w700))),
          ]),
          const SizedBox(height: 10),
          LumixCard(child: Text(q['q'] as String, style: LumixText.title.copyWith(height: 1.6, fontSize: 16))),
          const SizedBox(height: 16),
          ...((q['choices'] as List<String>).asMap().entries.map((e) {
            final i = e.key;
            final isCorrect = _revealed && i == q['correct'];
            final isWrong   = _revealed && _selected == i && i != q['correct'];
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GestureDetector(
                onTap: () => _pick(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  decoration: BoxDecoration(
                    color: _choiceColor(i),
                    border: Border.all(color: _choiceBorder(i), width: _revealed && (isCorrect || isWrong) ? 1.5 : 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(children: [
                    Container(width: 26, height: 26,
                        decoration: BoxDecoration(
                            color: _revealed && (isCorrect || isWrong || i == q['correct']) ? Colors.white.withOpacity(0.15) : LumixColors.border,
                            borderRadius: BorderRadius.circular(6)),
                        child: Center(child: Text(String.fromCharCode(65 + i),
                            style: const TextStyle(color: LumixColors.textPrimary, fontWeight: FontWeight.w800, fontSize: 12)))),
                    const SizedBox(width: 12),
                    Expanded(child: Text(e.value, style: TextStyle(
                        color: _revealed && (isCorrect || isWrong || i == q['correct']) ? Colors.white : LumixColors.textPrimary,
                        fontWeight: FontWeight.w500, fontSize: 14))),
                    if (isCorrect) const Icon(Icons.check_circle_rounded, color: LumixColors.success, size: 22),
                    if (isWrong)   const Icon(Icons.cancel_rounded, color: LumixColors.danger, size: 22),
                  ]),
                ),
              ),
            );
          })),
          if (_revealed) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: LumixColors.student.withOpacity(0.08),
                border: Border.all(color: LumixColors.student.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Icon(Icons.lightbulb_rounded, color: LumixColors.student, size: 16),
                const SizedBox(width: 8),
                Expanded(child: Text(q['explanation'] as String, style: LumixText.caption.copyWith(color: LumixColors.student))),
              ]),
            ),
          ],
          const Spacer(),
          if (_revealed)
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: LumixColors.student, padding: const EdgeInsets.symmetric(vertical: 16)),
              onPressed: _next,
              child: Text(_qIdx < _questions.length - 1 ? 'Next Question →' : 'Finish Quiz', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
            ),
        ]),
      ),
    );
  }
}

// ─── AI Tutor ──────────
class AITutorScreen extends StatefulWidget {
  const AITutorScreen({super.key});
  @override
  State<AITutorScreen> createState() => _AITutorScreenState();
}

class _AITutorScreenState extends State<AITutorScreen> {
  final _ctrl = TextEditingController();
  final _scroll = ScrollController();
  final List<Map<String, dynamic>> _messages = [
    {'role': 'ai', 'text': "Hi! I'm Lumix AI Tutor — your personal academic assistant. Ask me anything about your subjects! 🎓"},
  ];
  bool _loading = false;

  Future<void> _send() async {
    final text = _ctrl.text.trim();
    if (text.isEmpty || _loading) return;
    _ctrl.clear();
    setState(() { _messages.add({'role': 'user', 'text': text}); _loading = true; });
    _scrollBottom();

    try {
      final response = await http.post(
        Uri.parse('https://api.anthropic.com/v1/messages'),
        headers: {'Content-Type': 'application/json', 'anthropic-version': '2023-06-01'},
        body: jsonEncode({
          'model': 'claude-sonnet-4-20250514',
          'max_tokens': 1000,
          'system': 'You are Lumix AI Tutor. Keep responses concise and supportive.',
          'messages': [{'role': 'user', 'content': text}],
        }),
      );
      if (!mounted) return;
      final data = jsonDecode(response.body);
      final reply = (data['content'] as List).firstWhere((c) => c['type'] == 'text')['text'] as String;
      setState(() { _loading = false; _messages.add({'role': 'ai', 'text': reply}); });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _messages.add({'role': 'ai', 'text': 'Sorry, I had trouble connecting. Please check your API key.'});
      });
    }
    _scrollBottom();
  }

  void _scrollBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(_scroll.position.maxScrollExtent, duration: const Duration(milliseconds: 350), curve: Curves.easeOut);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(height: 48, child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        children: ['Explain Kinematics', 'Solve Quadratic x²-5x+6=0', 'Explain Newton\'s laws'].map((q) =>
            GestureDetector(
              onTap: () { _ctrl.text = q; _send(); },
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: LumixColors.studentSurface,
                  border: Border.all(color: LumixColors.student.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(q, style: const TextStyle(color: LumixColors.student, fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            )).toList(),
      )),
      Container(height: 1, color: LumixColors.border),
      Expanded(child: ListView.builder(
        controller: _scroll,
        padding: const EdgeInsets.all(16),
        itemCount: _messages.length,
        itemBuilder: (_, i) {
          final isUser = _messages[i]['role'] == 'user';
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                if (!isUser) ...[
                  Container(width: 30, height: 30, decoration: BoxDecoration(color: LumixColors.studentSurface, borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.auto_awesome_rounded, size: 14, color: LumixColors.student)),
                  const SizedBox(width: 8),
                ],
                Flexible(child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.74),
                  decoration: BoxDecoration(
                    color: isUser ? LumixColors.student : LumixColors.bg800,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16), topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isUser ? 16 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 16),
                    ),
                    border: isUser ? null : Border.all(color: LumixColors.border),
                  ),
                  child: Text(_messages[i]['text'] as String,
                      style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.6)),
                )),
                if (isUser) ...[
                  const SizedBox(width: 8),
                  const CircleAvatar(radius: 14, backgroundColor: LumixColors.border,
                      child: Icon(Icons.person_rounded, size: 14, color: LumixColors.textSecondary)),
                ],
              ],
            ),
          );
        },
      )),
      if (_loading)
        Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 8),
          child: Row(children: [
            Container(width: 30, height: 30, decoration: BoxDecoration(color: LumixColors.studentSurface, borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.auto_awesome_rounded, size: 14, color: LumixColors.student)),
            const SizedBox(width: 10),
            const _TypingDots(),
          ]),
        ),
      Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
        decoration: const BoxDecoration(color: LumixColors.bg800, border: Border(top: BorderSide(color: LumixColors.border))),
        child: Row(children: [
          Expanded(child: TextField(
            controller: _ctrl, style: LumixText.body,
            decoration: InputDecoration(
              hintText: 'Ask Lumix anything…',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
              filled: true, fillColor: LumixColors.bg900,
              contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            ),
            onSubmitted: (_) => _send(),
          )),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _loading ? null : _send,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 44, height: 44,
              decoration: BoxDecoration(color: _loading ? LumixColors.bg700 : LumixColors.student, shape: BoxShape.circle),
              child: Icon(_loading ? Icons.hourglass_top_rounded : Icons.send_rounded, color: Colors.white, size: 18),
            ),
          ),
        ]),
      ),
    ]);
  }
}

class _TypingDots extends StatefulWidget {
  const _TypingDots();
  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))..repeat();
    _anim = Tween(begin: 0.0, end: 1.0).animate(_ctrl);
  }
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) {
        return Row(children: List.generate(3, (i) {
          final opacity = ((_anim.value * 3 - i) % 1).clamp(0.0, 1.0);
          return Container(
            width: 7, height: 7, margin: const EdgeInsets.only(right: 4),
            decoration: BoxDecoration(
              color: LumixColors.student.withOpacity(0.3 + 0.7 * opacity),
              shape: BoxShape.circle,
            ),
          );
        }));
      },
    );
  }
}