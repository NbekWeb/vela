import 'package:flutter/material.dart';
import '../../main.dart' show globalMeditationId;
import 'package:provider/provider.dart';
import '../../core/stores/meditation_store.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class VaultRitualCard extends StatelessWidget {
  final String? name;
  final String? meditationId;
  final String? file;
  final String? imageUrl;
  final String? title;
  final String? description;
  final Function(String)? onAudioPlay;
  
  const VaultRitualCard({
    this.name, 
    this.meditationId,
    this.file,
    this.imageUrl,
    this.title,
    this.description,
    this.onAudioPlay,
    super.key,
  });

  String _getTitleFromName(String? name) {
    if (name == null) return 'Sleep Stream';

    final firstWord = name.split(' ').first.toLowerCase();
    switch (firstWord) {
      case 'morning':
        return 'Morning Spark';
      case 'sleep':
        return 'Sleep Manifestation';
      case 'calming':
        return 'Calming Reset';
      default:
        return 'Dream Visualizer';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine image based on name or use network image
    String imagePath = 'assets/img/card4.png'; // default
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      // Use network image if provided
      imagePath = imageUrl!;
    } else if (name != null) {
      // Fallback to local images based on name
      final firstWord = name!.split(' ').first.toLowerCase();
      if (firstWord == 'morning') {
        imagePath = 'assets/img/card2.png';
      } else if (firstWord == 'sleep') {
        imagePath = 'assets/img/card.png';
      } else if (firstWord == 'calming') {
        imagePath = 'assets/img/card3.png';
      }
    }

    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white.withAlpha((0.22 * 255).round()),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: imageUrl != null && imageUrl!.isNotEmpty
                      ? Image.network(
                          imagePath,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              width: 100,
                              height: 100,
                              color: Colors.grey[300],
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/img/card4.png',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            );
                          },
                        )
                      : Image.asset(
                          imagePath,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                ),
                GestureDetector(
                  onTap: () async {
                    print('meditationId: $meditationId');
                    
                    // Save file to secure storage if provided
                    if (file != null) {
                      const storage = FlutterSecureStorage();
                      await storage.write(key: 'file', value: file);
                      print('File saved to secure storage: $file');
                    }
                    
                    if (meditationId != null) {
                      // Set storedRitualType based on name
                      final meditationStore = Provider.of<MeditationStore>(context, listen: false);
                      if (name != null) {
                        final firstWord = name!.split(' ').first.toLowerCase();
                        String ritualType = '4'; // default
                        
                        if (firstWord == 'sleep') {
                          ritualType = '1';
                        } else if (firstWord == 'morning') {
                          ritualType = '2';
                        } else if (firstWord == 'calming') {
                          ritualType = '3';
                        }
                        
                        print('Setting storedRitualType to: $ritualType for name: $name');
                        // Set the ritual type directly in the store
                        meditationStore.saveRitualSettings(
                          ritualType: ritualType,
                          tone: meditationStore.storedTone ?? 'dreamy',
                          duration: meditationStore.storedDuration ?? '5',
                          planType: meditationStore.storedPlanType ?? 1,
                        );
                      }
                      
                      if (onAudioPlay != null) {
                        print('Calling onAudioPlay with: $meditationId');
                        onAudioPlay!(meditationId!);
                      } else {
                        print('onAudioPlay is null, using global navigation');
                        // Use global navigation as fallback
                        globalMeditationId = meditationId;
                        Navigator.pushReplacementNamed(context, '/dashboard');
                      }
                    } else {
                      print('meditationId is null');
                    }
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0x80A4C7EA),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title ?? _getTitleFromName(name),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description ?? 'A deeply personalized journey crafted from your unique vision and dreams',
                  style: const TextStyle(
                    color: Color(0xFFF2EFEA),
                    fontSize: 15,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
