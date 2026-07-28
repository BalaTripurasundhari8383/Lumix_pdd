import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants/theme.dart';
import '../../widgets/shared_widgets.dart';
import '../../widgets/tab_scaffold.dart';

// ═════════════════════════════════════════════
// TEACHER SHELL
// ═════════════════════════════════════════════
class TeacherShell extends StatelessWidget {
  final String userName;
  const TeacherShell({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return TabScaffold(
      title: 'Teacher Portal',
      accent: LumixColors.teacher,
      accentSurface: LumixColors.teacherSurface,
      userName: userName,
      tabs: [
        TabItem(label: 'Home',     icon: Icons.home_outlined,    activeIcon: Icons.home_rounded,         body: TeacherHome(userName: userName)),
        TabItem(label: 'Students', icon: Icons.people_outlined,   activeIcon: Icons.people_rounded,       body: const ManageStudentsScreen()),
        TabItem(label: 'Marks',    icon: Icons.upload_file_outlined, activeIcon: Icons.upload_file_rounded, body: const UploadMarksScreen()),
        TabItem(label: 'AI Alerts',icon: Icons.warning_amber_outlined, activeIcon: Icons.warning_amber_rounded, body: const AIRiskScreen()),
        TabItem(label: 'Post',     icon: Icons.campaign_outlined, activeIcon: Icons.campaign_rounded,     body: const AnnouncementScreen()),
      ],
    );
  }
}

// ─── Teacher Home ───────────────────────────
class TeacherHome extends StatelessWidget {
  final String userName;
  const TeacherHome({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12 ? 'Good morning' : hour < 17 ? 'Good afternoon' : 'Good evening';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Greeting
        Text('$greeting,', style: LumixText.caption),
        const SizedBox(height: 4),
        Text(userName, style: LumixText.display),
        const SizedBox(height: 4),
        const Text("Here's your class overview for today.", style: LumixText.caption),
        const SizedBox(height: 28),

        // Stats row
        Row(children: [
          Expanded(child: _StatCard('42', 'Students', Icons.people_rounded, LumixColors.teacher)),
          const SizedBox(width: 12),
          Expanded(child: _StatCard('3', 'At-Risk', Icons.warning_amber_rounded, LumixColors.danger)),
          const SizedBox(width: 12),
          Expanded(child: _StatCard('87%', 'Avg Score', Icons.trending_up_rounded, LumixColors.success)),
        ]),
        const SizedBox(height: 28),

        // Risk alerts
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('AI Risk Alerts', style: LumixText.title),
          TextButton(
            onPressed: () => push(context, const AIRiskScreen()),
            child: const Text('View all', style: TextStyle(color: LumixColors.teacher, fontSize: 13, fontWeight: FontWeight.w700)),
          ),
        ]),
        const SizedBox(height: 10),
        const _RiskTile('Alex Johnson',   'Failing Physics & missed 3 quizzes in a row', 'Critical', LumixColors.danger),
        const SizedBox(height: 8),
        const _RiskTile('Priya Nair',     'Science scores dropped 18% this month',       'Warning',  LumixColors.warning),
        const SizedBox(height: 8),
        const _RiskTile('Sam Torres',     'Consistent improvement — goal 90% by term end', 'On Track', LumixColors.success),
        const SizedBox(height: 28),

        // Quick actions
        const Text('Quick Actions', style: LumixText.title),
        const SizedBox(height: 14),
        GridView.count(
          crossAxisCount: 2, shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.05,
          children: [
            _ActionCard('Student Roster', '42 enrolled',       Icons.people_rounded,       LumixColors.teacher,  () => push(context, const ManageStudentsScreen())),
            _ActionCard('Upload Marks',   'Assessment data',   Icons.upload_file_rounded,  LumixColors.warning,  () => push(context, const UploadMarksScreen())),
            _ActionCard('AI Alerts',      '3 critical flags',  Icons.warning_amber_rounded, LumixColors.danger,  () => push(context, const AIRiskScreen())),
            _ActionCard('Announcements',  'Post to class',     Icons.campaign_rounded,     LumixColors.info,     () => push(context, const AnnouncementScreen())),
          ],
        ),
      ]),
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

class _RiskTile extends StatelessWidget {
  final String name, detail, badge;
  final Color color;
  const _RiskTile(this.name, this.detail, this.badge, this.color);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        border: Border(left: BorderSide(color: color, width: 3)),
        borderRadius: const BorderRadius.only(topRight: Radius.circular(12), bottomRight: Radius.circular(12)),
      ),
      child: Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(name, style: LumixText.body.copyWith(fontWeight: FontWeight.w700, fontSize: 14)),
          const SizedBox(height: 2),
          Text(detail, style: LumixText.caption.copyWith(fontSize: 12)),
        ])),
        LumixChip(label: badge, color: color),
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

// ─── Manage Students ────────────────────────
class ManageStudentsScreen extends StatefulWidget {
  const ManageStudentsScreen({super.key});
  @override
  State<ManageStudentsScreen> createState() => _ManageStudentsScreenState();
}

class _ManageStudentsScreenState extends State<ManageStudentsScreen> {
  late final Future<List<Map<String, dynamic>>> _future;
  final _search = TextEditingController();
  String _query = '';

  static const _demo = [
    {'full_name': 'Alex Johnson',   'grade': '10', 'section': 'A', 'riskIdx': 2},
    {'full_name': 'Priya Nair',     'grade': '10', 'section': 'A', 'riskIdx': 1},
    {'full_name': 'Sam Torres',     'grade': '10', 'section': 'B', 'riskIdx': 0},
    {'full_name': 'Mia Chen',       'grade': '10', 'section': 'A', 'riskIdx': 1},
    {'full_name': 'Rohan Mehta',    'grade': '11', 'section': 'C', 'riskIdx': 0},
    {'full_name': 'Ananya Kumar',   'grade': '11', 'section': 'B', 'riskIdx': 0},
    {'full_name': 'Carlos Diaz',    'grade': '10', 'section': 'C', 'riskIdx': 2},
    {'full_name': 'Lily Park',      'grade': '11', 'section': 'A', 'riskIdx': 1},
  ];

  @override
  void initState() {
    super.initState();
    _future = Supabase.instance.client
        .from('profiles').select().eq('role', 'student')
        .then((r) => List<Map<String, dynamic>>.from(r));
    _search.addListener(() => setState(() => _query = _search.text.toLowerCase()));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _future,
      builder: (context, snapshot) {
        List<Map<String, dynamic>> list;
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          list = List<Map<String, dynamic>>.from(_demo);
        } else {
          list = snapshot.data!;
        }
        if (_query.isNotEmpty) {
          list = list.where((s) => ((s['full_name'] ?? '') as String).toLowerCase().contains(_query)).toList();
        }
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextField(
              controller: _search,
              style: LumixText.body,
              decoration: InputDecoration(
                hintText: 'Search students…',
                prefixIcon: const Icon(Icons.search_rounded, size: 20, color: LumixColors.textSecondary),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: LumixColors.border)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: LumixColors.border)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: LumixColors.teacher, width: 1.5)),
              ),
            ),
            const SizedBox(height: 16),
            Text('${list.length} Students', style: LumixText.label),
            const SizedBox(height: 10),
            ...list.asMap().entries.map((e) {
              final s = e.value;
              final name = (s['full_name'] ?? 'Unknown') as String;
              final ri = ((s['riskIdx'] ?? e.key % 3) as int).clamp(0, 2);
              final riskLabels = ['Low Risk', 'Warning', 'Critical'];
              final riskColors = [LumixColors.success, LumixColors.warning, LumixColors.danger];
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: LumixCard(
                  onTap: () => push(context, StudentProfileScreen(studentName: name)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(children: [
                    CircleAvatar(
                      radius: 22, backgroundColor: LumixColors.teacher.withOpacity(0.15),
                      child: Text(name[0].toUpperCase(), style: const TextStyle(color: LumixColors.teacher, fontWeight: FontWeight.w800, fontSize: 16)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(name, style: LumixText.body.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 2),
                      Text('Grade ${s['grade'] ?? 10} • Section ${s['section'] ?? 'A'}', style: LumixText.caption.copyWith(fontSize: 12)),
                    ])),
                    LumixChip(label: riskLabels[ri], color: riskColors[ri]),
                    const SizedBox(width: 6),
                    const Icon(Icons.chevron_right_rounded, color: LumixColors.textMuted, size: 20),
                  ]),
                ),
              );
            }),
          ],
        );
      },
    );
  }

  @override
  void dispose() { _search.dispose(); super.dispose(); }
}

// ─── Student Profile (Teacher view) ─────────
class StudentProfileScreen extends StatelessWidget {
  final String studentName;
  const StudentProfileScreen({super.key, required this.studentName});

  static const _subjects = [
    {'name': 'Mathematics',  'score': 85, 'weak': ['Quadratic Equations', 'Trigonometry'],                   'strong': ['Algebra', 'Statistics']},
    {'name': 'Science',      'score': 72, 'weak': ['Chemical Bonding', 'Ecosystems'],                        'strong': ['Force & Motion', 'Cells']},
    {'name': 'English',      'score': 91, 'weak': ['Essay Writing'],                                         'strong': ['Grammar', 'Comprehension', 'Literature']},
    {'name': 'Physics',      'score': 58, 'weak': ['Kinematics', 'Thermodynamics', 'Optics'],                'strong': ['Forces']},
    {'name': 'History',      'score': 79, 'weak': ['World War I Context'],                                   'strong': ['Ancient Civilisations', 'Modern India']},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(studentName), backgroundColor: LumixColors.bg800,
          bottom: PreferredSize(preferredSize: const Size.fromHeight(1), child: Container(height: 1, color: LumixColors.border))),
      backgroundColor: LumixColors.bg900,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          LumixCard(glow: true, glowColor: LumixColors.teacher,
            child: Row(children: [
              CircleAvatar(radius: 32, backgroundColor: LumixColors.teacherSurface,
                  child: Text(studentName[0].toUpperCase(), style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: LumixColors.teacher))),
              const SizedBox(width: 16),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(studentName, style: LumixText.headline.copyWith(fontSize: 18)),
                const SizedBox(height: 4),
                const Text('Grade 10 • Section A', style: LumixText.caption),
                const SizedBox(height: 8),
                const LumixChip(label: '⚠ At Risk', color: LumixColors.danger),
              ]),
            ]),
          ),
          const SizedBox(height: 24),
          const Text('Subject Performance & Weak Topics', style: LumixText.title),
          const SizedBox(height: 12),
          ..._subjects.map((s) {
            final score = s['score'] as int;
            final color = scoreColor(score);
            final weak   = s['weak']   as List<dynamic>;
            final strong = s['strong'] as List<dynamic>;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: LumixCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(s['name'] as String, style: LumixText.title.copyWith(fontSize: 15)),
                  Text('$score%', style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 18)),
                ]),
                const SizedBox(height: 10),
                LumixScoreBar(value: score / 100, color: color, height: 7),
                const SizedBox(height: 14),
                if (weak.isNotEmpty) ...[
                  Row(children: [
                    Container(width: 8, height: 8, decoration: const BoxDecoration(color: LumixColors.danger, shape: BoxShape.circle)),
                    const SizedBox(width: 6),
                    Text('Weak Topics:', style: LumixText.caption.copyWith(color: LumixColors.danger, fontWeight: FontWeight.w700)),
                  ]),
                  const SizedBox(height: 6),
                  Wrap(spacing: 6, runSpacing: 6, children: weak.map((t) =>
                      Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(color: LumixColors.dangerSurface, border: Border.all(color: LumixColors.danger.withOpacity(0.4)), borderRadius: BorderRadius.circular(20)),
                          child: Text(t as String, style: const TextStyle(color: LumixColors.danger, fontSize: 11, fontWeight: FontWeight.w600)))).toList(),
                  ),
                  const SizedBox(height: 10),
                ],
                Row(children: [
                  Container(width: 8, height: 8, decoration: const BoxDecoration(color: LumixColors.success, shape: BoxShape.circle)),
                  const SizedBox(width: 6),
                  Text('Strong Topics:', style: LumixText.caption.copyWith(color: LumixColors.success, fontWeight: FontWeight.w700)),
                ]),
                const SizedBox(height: 6),
                Wrap(spacing: 6, runSpacing: 6, children: strong.map((t) =>
                    Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(color: LumixColors.successSurface, border: Border.all(color: LumixColors.success.withOpacity(0.4)), borderRadius: BorderRadius.circular(20)),
                        child: Text(t as String, style: const TextStyle(color: LumixColors.success, fontSize: 11, fontWeight: FontWeight.w600)))).toList(),
                ),
              ])),
            );
          }),
          const SizedBox(height: 20),
          const Text('AI Intervention Plan', style: LumixText.title),
          const SizedBox(height: 12),
          LumixCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
            _IntervRow(Icons.menu_book_rounded,   'Assign Physics Kinematics revision worksheet',  LumixColors.teacher),
            SizedBox(height: 12),
            _IntervRow(Icons.quiz_rounded,         'Schedule bi-weekly quiz on weak topics',        LumixColors.teacher),
            SizedBox(height: 12),
            _IntervRow(Icons.message_rounded,      'Send weekly progress report to parent',         LumixColors.teacher),
            SizedBox(height: 12),
            _IntervRow(Icons.video_library_rounded,'Recommend remedial video — Kinematics Ch.3',   LumixColors.teacher),
          ])),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: LumixColors.teacher, padding: const EdgeInsets.symmetric(vertical: 16)),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('✅ AI Intervention Plan activated!'), backgroundColor: LumixColors.teacher, behavior: SnackBarBehavior.floating)),
            icon: const Icon(Icons.auto_awesome_rounded, size: 18),
            label: const Text('Activate AI Intervention Plan'),
          ),
        ],
      ),
    );
  }
}

class _IntervRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  const _IntervRow(this.icon, this.text, this.color);
  @override
  Widget build(BuildContext context) => Row(children: [
    Container(padding: const EdgeInsets.all(7), decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, size: 16, color: color)),
    const SizedBox(width: 12),
    Expanded(child: Text(text, style: LumixText.body.copyWith(fontSize: 13))),
    Icon(Icons.check_circle_outline_rounded, size: 18, color: color.withOpacity(0.5)),
  ]);
}

// ─── Upload Marks ───────────────────────────
class UploadMarksScreen extends StatefulWidget {
  const UploadMarksScreen({super.key});
  @override
  State<UploadMarksScreen> createState() => _UploadMarksScreenState();
}

class _UploadMarksScreenState extends State<UploadMarksScreen> with SingleTickerProviderStateMixin {
  late TabController _tabs;
  String _subject = 'Mathematics';
  String _class = 'Grade 10 - A';
  bool _uploading = false;
  bool _uploaded = false;

  final _subjects = ['Mathematics', 'Science', 'English', 'Physics', 'History', 'Computer Science'];
  final _classes  = ['Grade 10 - A', 'Grade 10 - B', 'Grade 10 - C', 'Grade 11 - A', 'Grade 11 - B'];
  final List<Map<String, dynamic>> _manualRows = [
    {'name': 'Alex Johnson',  'marks': TextEditingController(text: '48')},
    {'name': 'Priya Nair',    'marks': TextEditingController(text: '61')},
    {'name': 'Sam Torres',    'marks': TextEditingController(text: '79')},
    {'name': 'Mia Chen',      'marks': TextEditingController(text: '66')},
    {'name': 'Rohan Mehta',   'marks': TextEditingController(text: '88')},
    {'name': 'Ananya Kumar',  'marks': TextEditingController(text: '91')},
  ];

  @override
  void initState() { super.initState(); _tabs = TabController(length: 2, vsync: this); }

  Future<void> _simulateUpload() async {
    setState(() => _uploading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() { _uploading = false; _uploaded = true; });
  }

  void _saveManual() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('✅ Marks saved and AI analysis triggered!'),
      backgroundColor: LumixColors.teacher, behavior: SnackBarBehavior.floating,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LumixColors.bg900,
      appBar: AppBar(
        title: const Text('Upload / Enter Marks'),
        backgroundColor: LumixColors.bg800,
        bottom: TabBar(
          controller: _tabs,
          indicatorColor: LumixColors.teacher,
          labelColor: LumixColors.teacher,
          unselectedLabelColor: LumixColors.textSecondary,
          tabs: const [Tab(text: 'Excel / CSV Upload'), Tab(text: 'Manual Entry')],
        ),
      ),
      body: TabBarView(controller: _tabs, children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            _selectRow('Subject', _subject, _subjects, (v) => setState(() { _subject = v; _uploaded = false; })),
            const SizedBox(height: 14),
            _selectRow('Class', _class, _classes, (v) => setState(() { _class = v; _uploaded = false; })),
            const SizedBox(height: 24),

            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(36),
              decoration: BoxDecoration(
                color: _uploaded ? LumixColors.successSurface : LumixColors.teacher.withOpacity(0.05),
                border: Border.all(color: _uploaded ? LumixColors.success : LumixColors.teacher.withOpacity(0.4), width: 2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(children: [
                Icon(_uploaded ? Icons.check_circle_rounded : Icons.cloud_upload_rounded,
                    size: 60, color: _uploaded ? LumixColors.success : LumixColors.teacher),
                const SizedBox(height: 14),
                Text(
                  _uploaded ? 'Upload Successful!' : 'Tap to browse Excel / CSV',
                  style: LumixText.title.copyWith(color: _uploaded ? LumixColors.success : LumixColors.textPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  _uploaded ? '45 student records parsed & AI analysis running' : 'Supports .xlsx, .xls, .csv',
                  style: LumixText.caption.copyWith(color: _uploaded ? LumixColors.success : LumixColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                if (_uploading)
                  const SizedBox(width: 32, height: 32, child: CircularProgressIndicator(color: LumixColors.teacher, strokeWidth: 2))
                else if (!_uploaded)
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: LumixColors.teacher, padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14)),
                    onPressed: _simulateUpload,
                    icon: const Icon(Icons.attach_file_rounded, size: 18),
                    label: const Text('Select File & Process'),
                  ),
              ]),
            ),

            const SizedBox(height: 28),
            const Text('RECENT UPLOADS', style: LumixText.label),
            const SizedBox(height: 12),
            ...['Mathematics — Week 4 Assessment', 'Science — Term 1 Final', 'English — Midterm', 'Physics — Unit Test 2'].map((t) =>
                Padding(padding: const EdgeInsets.only(bottom: 8), child: LumixCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(children: [
                    Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: LumixColors.teacherSurface, borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.table_chart_rounded, color: LumixColors.teacher, size: 16)),
                    const SizedBox(width: 12),
                    Expanded(child: Text(t, style: LumixText.body.copyWith(fontSize: 13))),
                    const Text('45 rows', style: LumixText.caption),
                    const SizedBox(width: 8),
                    const LumixChip(label: 'Processed', color: LumixColors.success),
                  ]),
                ))),
          ]),
        ),

        SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            _selectRow('Subject', _subject, _subjects, (v) => setState(() => _subject = v)),
            const SizedBox(height: 14),
            _selectRow('Class', _class, _classes, (v) => setState(() => _class = v)),
            const SizedBox(height: 24),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('Student Marks (out of 100)', style: LumixText.title),
              LumixChip(label: '${_manualRows.length} students', color: LumixColors.teacher),
            ]),
            const SizedBox(height: 12),
            ..._manualRows.map((row) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: LumixCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(children: [
                  CircleAvatar(radius: 18, backgroundColor: LumixColors.teacherSurface,
                      child: Text((row['name'] as String)[0], style: const TextStyle(color: LumixColors.teacher, fontWeight: FontWeight.w800))),
                  const SizedBox(width: 12),
                  Expanded(child: Text(row['name'] as String, style: LumixText.body.copyWith(fontWeight: FontWeight.w600))),
                  SizedBox(width: 80, child: TextField(
                    controller: row['marks'] as TextEditingController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: LumixColors.textPrimary, fontWeight: FontWeight.w700, fontSize: 16),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: LumixColors.border)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: LumixColors.border)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: LumixColors.teacher)),
                    ),
                  )),
                ]),
              ),
            )),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: LumixColors.teacher, padding: const EdgeInsets.symmetric(vertical: 16)),
              onPressed: _saveManual,
              icon: const Icon(Icons.save_rounded, size: 18),
              label: const Text('Save Marks & Run AI Analysis'),
            ),
          ]),
        ),
      ]),
    );
  }

  Widget _selectRow(String label, String value, List<String> items, ValueChanged<String> onChange) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label.toUpperCase(), style: LumixText.label),
      const SizedBox(height: 8),
      DropdownButtonFormField<String>(
        value: value, dropdownColor: LumixColors.bg800, style: LumixText.body,
        decoration: const InputDecoration(),
        items: items.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
        onChanged: (v) { if (v != null) onChange(v); },
      ),
    ]);
  }
}

// ─── AI Risk Screen ──────────────────────────
class AIRiskScreen extends StatelessWidget {
  const AIRiskScreen({super.key});

  static const _students = [
    {'name': 'Alex Johnson',  'detail': 'Failing Physics & missed 3 quizzes in row', 'risk': 'Critical', 'score': 48, 'weakTopics': ['Kinematics', 'Optics', 'Thermodynamics']},
    {'name': 'Priya Nair',    'detail': 'Science down 18% this month',               'risk': 'Warning',  'score': 61, 'weakTopics': ['Chemical Bonding', 'Ecosystems']},
    {'name': 'Mia Chen',      'detail': 'Missed 2 assignments this week',            'risk': 'Warning',  'score': 66, 'weakTopics': ['Quadratic Equations']},
    {'name': 'Sam Torres',    'detail': 'Consistent improvement noted',               'risk': 'On Track', 'score': 79, 'weakTopics': []},
    {'name': 'Rohan Mehta',   'detail': 'Strong across all subjects',                'risk': 'On Track', 'score': 88, 'weakTopics': []},
  ];

  Color _riskColor(String r) {
    if (r == 'Critical') return LumixColors.danger;
    if (r == 'Warning')  return LumixColors.warning;
    return LumixColors.success;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [LumixColors.teacherSurface, LumixColors.bg800], begin: Alignment.topLeft, end: Alignment.bottomRight),
            border: Border.all(color: LumixColors.teacher.withOpacity(0.3)), borderRadius: BorderRadius.circular(12),
          ),
          child: Row(children: [
            Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: LumixColors.teacher.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.auto_awesome_rounded, color: LumixColors.teacher, size: 18)),
            const SizedBox(width: 12),
            const Expanded(child: Text('AI scanned 42 students. 2 need immediate attention.', style: LumixText.caption)),
          ]),
        ),
        const SizedBox(height: 16),
        ..._students.map((s) {
          final color = _riskColor(s['risk'] as String);
          final weak = s['weakTopics'] as List;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: LumixCard(
              onTap: () => push(context, StudentProfileScreen(studentName: s['name'] as String)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  CircleAvatar(radius: 18, backgroundColor: color.withOpacity(0.12),
                      child: Text((s['name'] as String)[0], style: TextStyle(color: color, fontWeight: FontWeight.w800))),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(s['name'] as String, style: LumixText.body.copyWith(fontWeight: FontWeight.w700)),
                    Text(s['detail'] as String, style: LumixText.caption.copyWith(fontSize: 12)),
                  ])),
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text('${s['score']}%', style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 18)),
                    const SizedBox(height: 4),
                    LumixChip(label: s['risk'] as String, color: color),
                  ]),
                ]),
                if (weak.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text('Weak Topics:', style: LumixText.caption.copyWith(color: LumixColors.danger, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Wrap(spacing: 6, runSpacing: 4, children: weak.map((t) =>
                      Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: LumixColors.dangerSurface, border: Border.all(color: LumixColors.danger.withOpacity(0.35)), borderRadius: BorderRadius.circular(16)),
                          child: Text(t as String, style: const TextStyle(color: LumixColors.danger, fontSize: 11, fontWeight: FontWeight.w600)))).toList(),
                  ),
                ],
              ]),
            ),
          );
        }),
      ],
    );
  }
}

// ─── Announcement ───────────────────────────
class AnnouncementScreen extends StatefulWidget {
  const AnnouncementScreen({super.key});
  @override
  State<AnnouncementScreen> createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {
  final _title = TextEditingController();
  final _body  = TextEditingController();
  String _audience = 'All Students';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const Text('POST ANNOUNCEMENT', style: LumixText.label),
        const SizedBox(height: 16),
        TextField(controller: _title, style: LumixText.body,
            decoration: const InputDecoration(labelText: 'Title', hintText: 'e.g. Quiz on Chapter 5 tomorrow', prefixIcon: Icon(Icons.title_rounded, size: 20))),
        const SizedBox(height: 14),
        TextField(controller: _body, style: LumixText.body, maxLines: 5,
            decoration: const InputDecoration(labelText: 'Message', hintText: 'Write your announcement here…', alignLabelWithHint: true)),
        const SizedBox(height: 14),
        DropdownButtonFormField<String>(
          value: _audience, dropdownColor: LumixColors.bg800, style: LumixText.body,
          decoration: const InputDecoration(labelText: 'Audience'),
          items: ['All Students', 'Grade 10', 'Grade 11', 'Section A', 'Physics Class', 'All Parents']
              .map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
          onChanged: (v) => setState(() => _audience = v!),
        ),
        const SizedBox(height: 28),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(backgroundColor: LumixColors.teacher, padding: const EdgeInsets.symmetric(vertical: 16)),
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('📢 Announcement posted!'), backgroundColor: LumixColors.teacher, behavior: SnackBarBehavior.floating)),
          icon: const Icon(Icons.send_rounded, size: 18),
          label: const Text('Post Announcement'),
        ),
        const SizedBox(height: 28),
        const Text('RECENT ANNOUNCEMENTS', style: LumixText.label),
        const SizedBox(height: 12),
        ...[
          {'title': 'Unit Test next Monday', 'audience': 'Grade 10', 'time': '2 hours ago'},
          {'title': 'Homework submission deadline extended', 'audience': 'All Students', 'time': '1 day ago'},
          {'title': 'Parent-teacher meeting next Friday', 'audience': 'All Parents', 'time': '2 days ago'},
        ].map((a) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: LumixCard(padding: const EdgeInsets.all(16), child: Row(children: [
            Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: LumixColors.info.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.campaign_rounded, color: LumixColors.info, size: 16)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(a['title']!, style: LumixText.body.copyWith(fontWeight: FontWeight.w600, fontSize: 13)),
              const SizedBox(height: 2),
              Text('${a['audience']} • ${a['time']}', style: LumixText.caption.copyWith(fontSize: 11)),
            ])),
          ])),
        )),
      ]),
    );
  }
}