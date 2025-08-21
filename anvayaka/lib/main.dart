import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart';
import 'screens/laborers_screen.dart';
import 'screens/running_tasks_screen.dart';
import 'screens/assign_task_screen.dart';
import 'screens/parchi_generation_screen.dart';
import 'screens/machine_health_screen.dart';
import 'screens/total_stock_screen.dart';
import 'screens/counterfeit_stock_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppProvider(),
      child: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          return MaterialApp(
            title: 'Anvayaka Pipeline',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
                elevation: 0,
                iconTheme: IconThemeData(color: Colors.black),
                titleTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1; // Running Tasks as landing page

  @override
  void initState() {
    super.initState();
    // Ensure selected index is within valid range
    if (_selectedIndex >= _bottomScreens.length) {
      _selectedIndex = 0;
    }
  }

  // Bottom navigation screens (limited to 3)
  static const List<Widget> _bottomScreens = <Widget>[
    RunningTasksScreen(),
    AssignTaskScreen(),
    ParchiGenerationScreen(),
  ];

  // All screens for side navigation
  static const List<Widget> _allScreens = <Widget>[
    LaborersScreen(),
    RunningTasksScreen(),
    AssignTaskScreen(),
    ParchiGenerationScreen(),
    MachineHealthScreen(),
    TotalStockScreen(),
    CounterfeitStockScreen(),
  ];

  static const List<String> _allTitles = [
    'Laborers',
    'Running Tasks',
    'Assign Task',
    'Parchi Generation',
    'Machine Health',
    'Total Stock',
    'Counterfeit Stock',
  ];

  static const List<IconData> _allIcons = [
    Icons.people,
    Icons.schedule,
    Icons.assignment,
    Icons.receipt_long,
    Icons.settings,
    Icons.inventory_2,
    Icons.warning,
  ];

  int _getBottomNavIndex() {
    // Map the selected screen to bottom navigation index
    switch (_selectedIndex) {
      case 1: // Running Tasks
        return 0;
      case 2: // Assign Task
        return 1;
      case 3: // Parchi Generation
        return 2;
      default:
        return 0; // Default to Tasks
    }
  }

  void _onItemTapped(int index) {
    // Map bottom navigation index to actual screen index
    int screenIndex;
    switch (index) {
      case 0: // Tasks
        screenIndex = 1;
        break;
      case 1: // Assign
        screenIndex = 2;
        break;
      case 2: // Parchi
        screenIndex = 3;
        break;
      default:
        screenIndex = 1;
    }
    
    setState(() {
      _selectedIndex = screenIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final isSmallScreen = MediaQuery.of(context).size.width < 360;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            /// Logo + spacing
            Image.asset(
              'assets/images/logo.png',
              height: isSmallScreen ? 20 : 28,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 8),

            /// Wrap title & subtitle responsively
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "Anvayaka Pipeline",
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  FittedBox(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.scaleDown,
                    child: Text(
                      appProvider.isThekedar
                          ? 'Thekedar Dashboard'
                          : 'Owner Dashboard',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
                image: DecorationImage(
                  image: AssetImage('assets/images/logo.png'),
                  fit: BoxFit.contain,
                  colorFilter: ColorFilter.mode(
                    Colors.white.withOpacity(0.3),
                    BlendMode.dstATop,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Anvayaka Pipeline',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    appProvider.isThekedar
                        ? 'Thekedar Dashboard'
                        : 'Owner Dashboard',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ...List.generate(_allScreens.length, (index) {
              return ListTile(
                leading: Icon(
                  _allIcons[index],
                  color: _selectedIndex == index ? Colors.blue : Colors.grey,
                ),
                title: Text(
                  _allTitles[index],
                  style: TextStyle(
                    color: _selectedIndex == index ? Colors.blue : Colors.black,
                    fontWeight: _selectedIndex == index ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                selected: _selectedIndex == index,
                selectedTileColor: Colors.blue.withOpacity(0.1),
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                  });
                  Navigator.pop(context); // Close drawer
                },
              );
            }),
            Divider(),
            ListTile(
              leading: Icon(Icons.swap_horiz, color: Colors.grey),
              title: Text(
                'Switch Role',
                style: TextStyle(color: Colors.grey),
              ),
              onTap: () {
                appProvider.toggleRole();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: _allScreens[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // avoids overflow
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Tasks'),
          BottomNavigationBarItem(
              icon: Icon(Icons.assignment), label: 'Assign'),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long), label: 'Parchi'),
        ],
        currentIndex: _getBottomNavIndex(),
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
