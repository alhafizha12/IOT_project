import 'package:flutter/material.dart';

class DashboardPageRS extends StatelessWidget {
  const DashboardPageRS({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Statistik Card
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  StatistikCard(
                    icon: Icons.people,
                    title: "Total Lansia",
                    value: "10",
                    color: Colors.blue,
                  ),
                  StatistikCard(
                    icon: Icons.favorite,
                    title: "Status Normal",
                    value: "7",
                    color: Colors.green,
                  ),
                  StatistikCard(
                    icon: Icons.warning,
                    title: "Perlu Perhatian",
                    value: "2",
                    color: Colors.orange,
                  ),
                  StatistikCard(
                    icon: Icons.error,
                    title: "Darurat",
                    value: "1",
                    color: Colors.red,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Search bar
              TextField(
                decoration: InputDecoration(
                  hintText: "Cari Nama Lansia",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Judul
              const Text(
                "Lansia Overview",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // List Lansia
              Expanded(
                child: ListView(
                  children: const [
                    LansiaCard(
                      name: "Ibu Icha celloow",
                      room: "Kamar 101",
                      age: 72,
                      status: "NORMAL",
                      statusColor: Colors.green,
                      heartRate: 78.5,
                      temperature: 35,
                      battery: 80,
                    ),
                    LansiaCard(
                      name: "Bapak Rahmat",
                      room: "Kamar 20",
                      age: 100,
                      status: "PERINGATAN",
                      statusColor: Colors.orange,
                      heartRate: 200,
                      temperature: 35,
                      battery: 80,
                    ),
                    LansiaCard(
                      name: "Bapak Jaya Abadi",
                      room: "Kamar 101",
                      age: 72,
                      status: "DARURAT",
                      statusColor: Colors.red,
                      heartRate: 500,
                      temperature: 40,
                      battery: 80,
                    ),
                    LansiaCard(
                      name: "Ibu Jodha",
                      room: "Kamar 101",
                      age: 72,
                      status: "NORMAL",
                      statusColor: Colors.green,
                      heartRate: 78.5,
                      temperature: 35,
                      battery: 80,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StatistikCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const StatistikCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(title, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class LansiaCard extends StatelessWidget {
  final String name;
  final String room;
  final int age;
  final String status;
  final Color statusColor;
  final double heartRate;
  final double temperature;
  final int battery;

  const LansiaCard({
    super.key,
    required this.name,
    required this.room,
    required this.age,
    required this.status,
    required this.statusColor,
    required this.heartRate,
    required this.temperature,
    required this.battery,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 24,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, size: 30, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$name",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "$room . $age Tahun",
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.favorite, color: statusColor, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      "${heartRate} BPM",
                      style: TextStyle(color: statusColor),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.thermostat, color: Colors.green, size: 20),
                    const SizedBox(width: 4),
                    Text("${temperature} C"),
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.battery_full,
                      color: Colors.green,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text("$battery %"),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
