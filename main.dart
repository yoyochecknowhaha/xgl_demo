import 'package:flutter/material.dart';

void main() => runApp(const XglApp());

const ink = Color(0xFF192A3E);
const blue = Color(0xFF3578F6);
const canvas = Color(0xFFF4F6F9);

class XglApp extends StatelessWidget {
  const XglApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'XGL 工作台',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: canvas,
      colorScheme: ColorScheme.fromSeed(seedColor: blue, primary: blue),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: ink,
        elevation: 0,
        centerTitle: true,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF4F6F8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    ),
    home: const LoginPage(),
  );
}

const roles = ['前台', '会籍', '会籍经理', '私教', '私教经理'];
const roleKeys = ['reception', 'salesman', 'salesmanager', 'pt', 'ptmanager'];

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final account = TextEditingController(text: 'demo');
  final password = TextEditingController(text: '123456');
  int role = 1;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(28, 36, 28, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 78,
                  height: 78,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: ink,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(
                    Icons.fitness_center,
                    color: Colors.white,
                    size: 38,
                  ),
                ),
              ),
              const SizedBox(height: 22),
              const Text(
                'XGL 工作台',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: ink,
                ),
              ),
              const SizedBox(height: 6),
              const Text('让每一次服务都更专业', style: TextStyle(color: Colors.black54)),
              const SizedBox(height: 34),
              const Text(
                '选择工作角色',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(
                  roles.length,
                  (i) => ChoiceChip(
                    label: Text(roles[i]),
                    selected: role == i,
                    onSelected: (_) => setState(() => role = i),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              TextField(
                controller: account,
                decoration: const InputDecoration(
                  labelText: '个人账户',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: password,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: '密码',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => _notice(context, '请联系门店管理员重置密码'),
                  child: const Text('忘记密码？'),
                ),
              ),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: _enter,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text('登录'),
              ),
              const SizedBox(height: 18),
              const Text(
                '演示模式：输入任意账号密码即可进入',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black45, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    ),
  );
  void _enter() => Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (_) => MainShell(
        role: role,
        account: account.text.trim().isEmpty ? '员工' : account.text.trim(),
      ),
    ),
  );
}

class MainShell extends StatefulWidget {
  const MainShell({super.key, required this.role, required this.account});
  final int role;
  final String account;
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int tab = 0;
  @override
  Widget build(BuildContext context) {
    final title = widget.role == 0 ? '工作台' : roles[widget.role];
    final screens = [
      Dashboard(role: widget.role),
      const MessagesPage(),
      ProfilePage(role: widget.role, account: widget.account),
    ];
    return Scaffold(
      body: IndexedStack(index: tab, children: screens),
      bottomNavigationBar: NavigationBar(
        height: 66,
        selectedIndex: tab,
        onDestinationSelected: (i) => setState(() => tab = i),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.grid_view_outlined),
            selectedIcon: const Icon(Icons.grid_view),
            label: title,
          ),
          const NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble),
            label: '消息',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: '我的',
          ),
        ],
      ),
    );
  }
}

class Dashboard extends StatelessWidget {
  const Dashboard({super.key, required this.role});
  final int role;
  @override
  Widget build(BuildContext context) {
    final sales = role == 1 || role == 2;
    final reception = role == 0;
    final title = reception ? '前台工作台' : '${roles[role]}工作台';
    final modules = reception
        ? ['扫码消课', '消课记录', '会员查询', '签到记录']
        : sales
        ? ['我要卖卡', '销售记录', '我的会员', '潜在客户', '我的数据']
        : ['排课管理', '私教消课', '售课记录', '学员列表', '我的数据'];
    final icons = reception
        ? [
            Icons.qr_code_scanner,
            Icons.receipt_long,
            Icons.groups,
            Icons.fact_check,
          ]
        : sales
        ? [
            Icons.credit_card,
            Icons.bar_chart,
            Icons.groups,
            Icons.person_search,
            Icons.analytics,
          ]
        : [
            Icons.calendar_month,
            Icons.check_circle_outline,
            Icons.receipt_long,
            Icons.people_alt,
            Icons.analytics,
          ];
    return Scaffold(
      backgroundColor: canvas,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: ink,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            _dateString(),
                            style: const TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                    const CircleAvatar(
                      radius: 23,
                      backgroundColor: Color(0xFFE2EBFC),
                      child: Icon(Icons.person, color: blue),
                    ),
                  ],
                ),
              ),
            ),
            if (sales)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _statsCard(),
                ),
              ),
            if (reception)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _scanCard(context),
                ),
              ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                child: Row(
                  children: [
                    const Text(
                      '快捷功能',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                        color: ink,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${modules.length} 项',
                      style: const TextStyle(
                        color: Colors.black45,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, i) => _moduleTile(context, modules[i], icons[i]),
                  childCount: modules.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.62,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 25, 20, 10),
                child: Row(
                  children: [
                    const Text(
                      '今日提醒',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                        color: ink,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => _openList(context, '待办事项'),
                      child: const Text('查看全部'),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 22),
                child: _reminders(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statsCard() => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF203B60), Color(0xFF3578F6)],
      ),
      borderRadius: BorderRadius.circular(18),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('本月业绩概览', style: TextStyle(color: Colors.white70)),
        const SizedBox(height: 15),
        Row(
          children: const [
            Expanded(
              child: _Stat(label: '新增会员', value: '12'),
            ),
            Expanded(
              child: _Stat(label: '新增潜客', value: '28'),
            ),
            Expanded(
              child: _Stat(label: '维护次数', value: '86'),
            ),
          ],
        ),
      ],
    ),
  );
  Widget _scanCard(BuildContext context) => InkWell(
    onTap: () => _openPage(context, '扫码消课'),
    borderRadius: BorderRadius.circular(18),
    child: Container(
      height: 144,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [Color(0xFF397EFA), Color(0xFF65A5FF)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 22,
            top: 21,
            child: Icon(
              Icons.qr_code_2,
              color: Colors.white.withValues(alpha: .24),
              size: 104,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Icon(Icons.qr_code_scanner, color: Colors.white, size: 28),
                Spacer(),
                Text(
                  '扫码消课',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  '扫描会员课程二维码完成核销',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
  Widget _moduleTile(BuildContext context, String label, IconData icon) =>
      InkWell(
        onTap: () => label == '排课管理'
            ? _openSchedule(context)
            : _openPage(context, label),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF1FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: blue, size: 21),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: ink,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: Colors.black38,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
  Widget _reminders(BuildContext context) => Column(
    children: [
      for (final item in const [
        ('10:30', '王女士 · 私教训练课', '待上课', Colors.orange),
        ('14:00', '李先生 · 体测回访', '待跟进', blue),
        ('16:30', '今日工作总结', '待完成', Colors.green),
      ])
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Text(
                item.$1,
                style: const TextStyle(color: Colors.black45, fontSize: 12),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  item.$2,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: item.$4.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  item.$3,
                  style: TextStyle(color: item.$4, fontSize: 11),
                ),
              ),
            ],
          ),
        ),
    ],
  );
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});
  final String label, value;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        value,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(height: 3),
      Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
    ],
  );
}

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('消息')),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (final row in const [
          (
            '系统通知',
            '欢迎使用 XGL 工作台，祝您工作顺利。',
            '刚刚',
            Icons.campaign,
            Color(0xFF3578F6),
          ),
          (
            '课程提醒',
            '您有一节课程即将开始，请提前做好准备。',
            '09:20',
            Icons.notifications_active,
            Color(0xFFFF9F43),
          ),
          ('门店公告', '本周六将进行门店设备维护。', '昨天', Icons.storefront, Color(0xFF35B67A)),
        ])
          Card(
            color: Colors.white,
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: CircleAvatar(
                backgroundColor: row.$5.withValues(alpha: .1),
                child: Icon(row.$4, color: row.$5),
              ),
              title: Text(
                row.$1,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(row.$2, maxLines: 2),
              ),
              trailing: Text(
                row.$3,
                style: const TextStyle(fontSize: 11, color: Colors.black45),
              ),
              onTap: () => _openPage(context, row.$1),
            ),
          ),
      ],
    ),
  );
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.role, required this.account});
  final int role;
  final String account;
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: canvas,
    appBar: AppBar(title: const Text('我的')),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: ink,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white24,
                child: Icon(Icons.person, color: Colors.white, size: 32),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    account,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    roles[role],
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
              const Spacer(),
              const Icon(Icons.chevron_right, color: Colors.white70),
            ],
          ),
        ),
        const SizedBox(height: 18),
        for (final entry in const [
          ('个人资料', Icons.badge_outlined),
          ('我的会员', Icons.groups_outlined),
          ('我的课程', Icons.fitness_center),
          ('设置', Icons.settings_outlined),
          ('关于我们', Icons.info_outline),
        ])
          Card(
            color: Colors.white,
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: Icon(entry.$2, color: blue),
              title: Text(entry.$1),
              trailing: const Icon(Icons.chevron_right, size: 18),
              onTap: () => _openPage(context, entry.$1),
            ),
          ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (_) => false,
          ),
          icon: const Icon(Icons.logout),
          label: const Text('退出登录'),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.redAccent,
            minimumSize: const Size.fromHeight(48),
          ),
        ),
      ],
    ),
  );
}

class FeaturePage extends StatefulWidget {
  const FeaturePage({super.key, required this.title});
  final String title;
  @override
  State<FeaturePage> createState() => _FeaturePageState();
}

class _FeaturePageState extends State<FeaturePage> {
  String filter = '全部';
  final search = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final title = widget.title;
    final isForm = title == '我要卖卡' || title == '新增会员' || title == '新增潜客';
    final isScan = title == '扫码消课';
    final data = _dataFor(title);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          if (!isForm && !isScan)
            IconButton(
              onPressed: () => setState(() {}),
              icon: const Icon(Icons.refresh),
            ),
        ],
      ),
      body: isScan
          ? _scanBody(context)
          : isForm
          ? _formBody(context)
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  child: TextField(
                    controller: search,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: '搜索$title',
                      suffixIcon: IconButton(
                        onPressed: () {
                          search.clear();
                          setState(() {});
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ),
                  ),
                ),
                if (['销售记录', '消课记录', '潜在客户'].contains(title))
                  SizedBox(
                    height: 48,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      children: ['全部', '今日', '本周', '本月']
                          .map(
                            (v) => Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              child: ChoiceChip(
                                label: Text(v),
                                selected: filter == v,
                                onSelected: (_) => setState(() => filter = v),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: data
                        .where(
                          (x) => x.toLowerCase().contains(
                            search.text.toLowerCase(),
                          ),
                        )
                        .length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, i) {
                      final text = data
                          .where(
                            (x) => x.toLowerCase().contains(
                              search.text.toLowerCase(),
                            ),
                          )
                          .toList()[i];
                      return Card(
                        color: Colors.white,
                        elevation: 0,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: const Color(0xFFEAF1FF),
                            child: Icon(_iconFor(title), color: blue),
                          ),
                          title: Text(
                            text,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(_subFor(title, i)),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => _openDetail(context, title, text),
                        ),
                      );
                    },
                  ),
                ),
                if (['我的会员', '潜在客户', '学员列表'].contains(title))
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 18),
                    child: FilledButton.icon(
                      onPressed: () =>
                          _openPage(context, title == '潜在客户' ? '新增潜客' : '新增会员'),
                      icon: const Icon(Icons.add),
                      label: const Text('新增'),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }

  Widget _scanBody(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 230,
            height: 230,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(Icons.qr_code_2, size: 180, color: ink),
          ),
          const SizedBox(height: 24),
          const Text(
            '摄像头扫码在此演示版本未连接',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          const Text('模拟器无法读取真实会员二维码', style: TextStyle(color: Colors.black54)),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () => _notice(context, '演示模式暂不执行真实消课'),
            child: const Text('模拟扫码'),
          ),
        ],
      ),
    ),
  );
  Widget _formBody(BuildContext context) {
    final fields = widget.title == '我要卖卡'
        ? ['会员姓名', '联系电话', '选择卡种', '成交金额', '备注']
        : ['姓名', '联系电话', '性别', '意向项目', '备注'];
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF1FF),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            widget.title == '我要卖卡' ? '填写售卡信息，创建一条销售记录。' : '录入客户资料，方便后续联系跟进。',
            style: const TextStyle(color: ink),
          ),
        ),
        const SizedBox(height: 18),
        for (final field in fields)
          Padding(
            padding: const EdgeInsets.only(bottom: 13),
            child: TextField(
              decoration: InputDecoration(
                labelText: field,
                suffixIcon:
                    field.contains('卡种') ||
                        field == '性别' ||
                        field.contains('项目')
                    ? const Icon(Icons.arrow_drop_down)
                    : null,
              ),
            ),
          ),
        const SizedBox(height: 8),
        FilledButton(
          onPressed: () {
            _notice(context, '已保存（本地演示）');
            Navigator.pop(context);
          },
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50)),
          child: const Text('保存'),
        ),
      ],
    );
  }
}

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});
  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  int day = 0;
  final selected = <String>{};
  final times = [
    '09:00',
    '10:00',
    '11:00',
    '13:00',
    '14:00',
    '15:00',
    '16:00',
    '17:00',
  ];

  @override
  Widget build(BuildContext context) {
    final dates = List.generate(
      7,
      (i) => DateTime.now().add(Duration(days: i)),
    );
    const weekNames = ['今天', '周二', '周三', '周四', '周五', '周六', '周日'];
    return Scaffold(
      appBar: AppBar(
        title: const Text('排课管理'),
        actions: [
          IconButton(
            onPressed: () => _notice(context, '筛选教练'),
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 84,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(
                7,
                (i) => InkWell(
                  onTap: () => setState(() => day = i),
                  child: Container(
                    width: 60,
                    margin: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 4,
                    ),
                    decoration: BoxDecoration(
                      color: i == day ? blue : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          weekNames[i],
                          style: TextStyle(
                            color: i == day ? Colors.white : Colors.black54,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${dates[i].day}',
                          style: TextStyle(
                            color: i == day ? Colors.white : ink,
                            fontWeight: FontWeight.w700,
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 17,
                  child: Icon(Icons.fitness_center, size: 16),
                ),
                const SizedBox(width: 9),
                const Text(
                  '教练：陈教练',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                Text(
                  '${selected.length} 个时段已选',
                  style: const TextStyle(color: blue),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [for (final time in times) _slot(time)],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton(
              onPressed: selected.isEmpty
                  ? null
                  : () => _notice(context, '已创建 ${selected.length} 个课程时段'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
              child: const Text('确认排课'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _slot(String time) {
    final booked = time == '10:00' || time == '15:00';
    final chosen = selected.contains(time);
    return InkWell(
      onTap: booked
          ? null
          : () => setState(
              () => chosen ? selected.remove(time) : selected.add(time),
            ),
      child: Container(
        height: 62,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: booked
              ? const Color(0xFFF1F2F4)
              : chosen
              ? const Color(0xFFEAF1FF)
              : Colors.white,
          borderRadius: BorderRadius.circular(13),
          border: chosen ? Border.all(color: blue) : null,
        ),
        child: Row(
          children: [
            Text(time, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(width: 18),
            Text(
              booked
                  ? '课程已预约'
                  : chosen
                  ? '已选择'
                  : '空闲时段',
              style: TextStyle(
                color: booked
                    ? Colors.black38
                    : chosen
                    ? blue
                    : Colors.black54,
              ),
            ),
            const Spacer(),
            Icon(
              booked
                  ? Icons.event_busy
                  : chosen
                  ? Icons.check_circle
                  : Icons.add_circle_outline,
              color: booked
                  ? Colors.black26
                  : chosen
                  ? blue
                  : Colors.black38,
            ),
          ],
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  const DetailPage({super.key, required this.title, required this.name});
  final String title, name;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('$title详情')),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [ink, Color(0xFF3578F6)]),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 7),
              const Text(
                '客户编号：XGL20261008001',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 18),
              const Text('跟进状态 · 持续维护', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
        const SizedBox(height: 15),
        for (final pair in const [
          ('联系电话', '138 0000 1234'),
          ('会员类型', '私教会员'),
          ('所属教练', '陈教练'),
          ('最近跟进', '今天 09:30'),
          ('备注', '按计划进行课程与训练回访'),
        ])
          Card(
            color: Colors.white,
            elevation: 0,
            child: ListTile(
              title: Text(
                pair.$1,
                style: const TextStyle(color: Colors.black54, fontSize: 13),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  pair.$2,
                  style: const TextStyle(color: ink, fontSize: 15),
                ),
              ),
            ),
          ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: () => _notice(context, '已记录本次跟进'),
          icon: const Icon(Icons.add),
          label: const Text('添加跟进记录'),
        ),
      ],
    ),
  );
}

class GenericPage extends StatelessWidget {
  const GenericPage({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    body: ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: ink,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                '此业务页面已纳入 Flutter 工作台结构。当前以本地演示数据展示，连接正式服务后可读取门店实时信息。',
                style: TextStyle(height: 1.6, color: Colors.black54),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                children: [
                  for (final s in ['会员管理', '课程服务', '数据记录'])
                    Chip(
                      label: Text(s),
                      backgroundColor: const Color(0xFFEAF1FF),
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          '常用操作',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        for (final s in ['查看记录', '筛选日期', '添加备注'])
          Card(
            color: Colors.white,
            elevation: 0,
            child: ListTile(
              leading: const Icon(Icons.circle_outlined, color: blue),
              title: Text(s),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _notice(context, '$s：本地演示'),
            ),
          ),
      ],
    ),
  );
}

void _openPage(BuildContext context, String title) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) =>
          _dataFor(title).isNotEmpty ||
              ['我要卖卡', '新增会员', '新增潜客', '扫码消课'].contains(title)
          ? FeaturePage(title: title)
          : GenericPage(title: title),
    ),
  );
}

void _openSchedule(BuildContext context) => Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => const SchedulePage()),
);
void _openList(BuildContext context, String title) => _openPage(context, title);
void _openDetail(BuildContext context, String title, String name) =>
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailPage(title: title, name: name),
      ),
    );
void _notice(BuildContext context, String text) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
String _dateString() {
  final d = DateTime.now();
  return '${d.year}年${d.month}月${d.day}日 · ${['周一', '周二', '周三', '周四', '周五', '周六', '周日'][d.weekday - 1]}';
}

IconData _iconFor(String title) => title.contains('销售') || title.contains('售课')
    ? Icons.receipt_long
    : title.contains('会员') || title.contains('学员')
    ? Icons.person
    : title.contains('潜客')
    ? Icons.person_search
    : title.contains('课程') || title.contains('消课')
    ? Icons.fitness_center
    : Icons.analytics;
String _subFor(String title, int i) =>
    title.contains('记录') || title.contains('销售') || title.contains('售课')
    ? '2026-10-${8 - i}  ·  ${['¥2,980', '¥1,680', '¥3,680'][i % 3]}'
    : title.contains('客户') || title.contains('会员') || title.contains('学员')
    ? '138 0000 ${['1234', '5218', '9086'][i % 3]}  ·  ${['持续跟进', '已预约体验', '训练中'][i % 3]}'
    : '2026-10-${8 - i}  ·  已完成';
List<String> _dataFor(String title) {
  if (title.contains('会员') || title.contains('学员')) {
    return [
      '王女士 · 私教会员',
      '李先生 · 健身会员',
      '陈女士 · 私教会员',
      '赵先生 · 健身会员',
      '周女士 · 体验会员',
    ];
  }
  if (title.contains('潜客')) {
    return ['林女士 · 意向减脂', '张先生 · 意向增肌', '吴女士 · 体验课已预约', '杨先生 · 待回访'];
  }
  if (title.contains('销售') || title.contains('售课')) {
    return ['王女士 · 私教季卡', '李先生 · 健身年卡', '陈女士 · 私教月卡', '赵先生 · 次卡'];
  }
  if (title.contains('消课') || title.contains('课程')) {
    return ['王女士 · 力量训练', '李先生 · 体能训练', '陈女士 · 私教课程', '赵先生 · 团体课程'];
  }
  if (title.contains('签到')) {
    return ['王女士 · 09:12 签到', '李先生 · 09:20 签到', '陈女士 · 09:34 签到'];
  }
  if (title.contains('数据') || title.contains('统计')) return [];
  if (title.contains('待办')) return ['王女士 · 私教训练课', '李先生 · 体测回访', '今日工作总结'];
  return [];
}
