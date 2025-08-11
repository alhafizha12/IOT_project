import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/user_service.dart';

class DashboardPage extends StatefulWidget {
  final String userName;
  final String usergoldar;
  final String userberat;
  final String userId;

  const DashboardPage({
    super.key,
    required this.userName,
    required this.usergoldar,
    required this.userberat,
    required this.userId,
  });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int? heartRate;
  double? temperature;
  bool isLoading = true;

  // final String userId = "6vMqttVxyyfHu43R2AnyOCGnR0Y2"; // id Ega (bisa dinamis)

  @override
  void initState() {
    super.initState();
    _loadUserDataRealtime();
  }

  void _loadUserDataRealtime() {
    final dbRef = FirebaseDatabase.instance.ref(widget.userId);

    dbRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        setState(() {
          heartRate = data['heartRate'] ?? 0;
          temperature = (data['temperatures'] != null)
              ? double.tryParse(data['temperatures'].toString()) ?? 0.0
              : 0.0;
          isLoading = false;
        });
      } else {
        setState(() {
          heartRate = 0;
          temperature = 0.0;
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Pasien: ${widget.userName}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Detak Jantung
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.favorite, color: Colors.red, size: 28),
                        SizedBox(width: 8),
                        Text(
                          "Detak Jantung",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          heartRate != null ? "$heartRate" : "-",
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text("BPM", style: TextStyle(fontSize: 18)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Grafik dummy masih bisa dipertahankan
                    SizedBox(
                      height: 100,
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(show: false),
                          titlesData: FlTitlesData(show: false),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              isCurved: true,
                              spots: [
                                FlSpot(0, heartRate?.toDouble() ?? 78),
                                FlSpot(
                                  1,
                                  (heartRate != null) ? heartRate! + 2.0 : 80,
                                ),
                                FlSpot(
                                  2,
                                  (heartRate != null) ? heartRate! - 2.0 : 76,
                                ),
                                FlSpot(
                                  3,
                                  (heartRate != null) ? heartRate! + 4.0 : 82,
                                ),
                                FlSpot(
                                  4,
                                  (heartRate != null) ? heartRate! - 1.0 : 79,
                                ),
                              ],
                              color: Colors.red,
                              barWidth: 2,
                              dotData: FlDotData(show: false),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Info indikator: Golongan darah, suhu, berat badan
              Row(
                children: [
                  Expanded(
                    child: InfoCard(
                      icon: Icons.water_drop,
                      color: Colors.red[100]!,
                      title: "Gol. Darah",
                      value: widget.usergoldar,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InfoCard(
                      icon: Icons.thermostat,
                      color: Colors.orange[100]!,
                      title: "Suhu",
                      value: temperature != null
                          ? "${temperature!.toStringAsFixed(1)}°C"
                          : "-",
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InfoCard(
                      icon: Icons.monitor_weight,
                      color: Colors.green[100]!,
                      title: "Berat",
                      value: "${widget.userberat} kg",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Riwayat laporan
              const Text(
                "Riwayat Laporan",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const ReportTile(
                color: Colors.blue,
                icon: Icons.folder,
                title: "General Health",
                files: "8 files",
              ),
              const SizedBox(height: 12),
              const ReportTile(
                color: Colors.purple,
                icon: Icons.folder,
                title: "Diabetes",
                files: "4 files",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget info indikator
class InfoCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String value;

  const InfoCard({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: color,
            child: Icon(icon, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(color: Colors.black54, fontSize: 14),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// Widget report tile
class ReportTile extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  final String files;

  const ReportTile({
    super.key,
    required this.color,
    required this.icon,
    required this.title,
    required this.files,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.black87),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(files, style: const TextStyle(color: Colors.black54)),
              ],
            ),
          ),
          const Icon(Icons.more_vert),
        ],
      ),
    );
  }
}
