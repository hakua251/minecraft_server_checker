import 'package:flutter/material.dart';
import 'package:minecraft_server_checker/utils/StringResources.dart';
import 'package:url_launcher/url_launcher.dart';


class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {

  @override
  void initState() {
    super.initState();
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    try{
      await launchUrl(uri);
    }
    catch(e){
      //TODO
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringResources.getString('ui_about')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildAboutHeader(),
          const SizedBox(height: 32),
          _buildInfoCard(
            title: StringResources.getString('ui_versions'),
            children: [
              _buildInfoItem(
                icon: Icons.info_outline,
                title: StringResources.getString('ui_current_version'),
                value: 'v1.0.0',
              ),
              //TODO
              // _buildInfoItem(
              //   icon: Icons.update,
              //   title: StringResources.getString('ui_check_update'),
              //   value: 'v1.0.0',
              //   showTrailing: true,
              //   onTap: () => _showUpdateDialog(context),
              // ),
            ],
          ),
          const SizedBox(height: 16),

          _buildInfoCard(
            title: StringResources.getString('ui_project_source'),
            children: [
              _buildInfoItem(
                icon: Icons.code,
                title: 'GitHub',
                value: 'github.com/hakua251/minecraft_server_checker',
                showTrailing: true,
                onTap: () => _launchUrl('https://github.com/hakua251/minecraft_server_checker'),
              ),
              _buildInfoItem(
                icon: Icons.bug_report,
                title: StringResources.getString('ui_report_problems'),
                value: StringResources.getString('ui_report_problems_desc'),
                showTrailing: true,
                onTap: () => _launchUrl('https://github.com/hakua251/minecraft_server_checker/issues'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          _buildInfoCard(
            title: StringResources.getString('ui_license'),
            children: [
              _buildInfoItem(
                icon: Icons.balance,
                title: 'GPL3.0 License',
                value: StringResources.getString('ui_license_desc'),
                showTrailing: true,
                onTap: ()=>_launchUrl('https://github.com/hakua251/minecraft_server_checker/blob/main/LICENSE')
              ),
            ],),
        ],
      ),
    );
  }

  Widget _buildAboutHeader() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.inversePrimary,
            borderRadius: BorderRadius.circular(16),

          ),
          child: const Image(
            image: AssetImage('assets/images/potato.png'),
            
          ),
        ),
        const SizedBox(height: 16),
        Text(
          StringResources.getString('app_name'),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String value,
    bool showTrailing = false,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: Text(title),
      subtitle: Text(
        value,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Colors.grey[600],
        ),
      ),
      trailing: showTrailing
          ? const Icon(Icons.arrow_forward_ios, size: 16)
          : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      visualDensity: const VisualDensity(vertical: -2),
      onTap: onTap,
    );
  }
}