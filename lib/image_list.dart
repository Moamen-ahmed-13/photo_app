// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class ImageList extends StatefulWidget {
//   const ImageList({super.key});

//   @override
//   State<ImageList> createState() => _ImageListState();
// }

// class _ImageListState extends State<ImageList> {
//   final SupabaseClient client = Supabase.instance.client;
//   List<String> imageUrls = [];

//   @override
//   void initState() {
//     super.initState();
//     _fetchImagesFromSupabase();
//   }

//   Future<void> _fetchImagesFromSupabase() async {
//     try {
//       final response = await client.storage
//           .from('photo-bucket') // Replace with your bucket name
//           .list();

//       if (response== null|| response.isEmpty) {
//         print('Error fetching images');
//         return;
//       }

//       final List<String> urls = response.data // Access the list directly
//         .map((item) => 
//           'https://your-project-ref.supabase.co/storage/v1/object/public/photo-bucket/${item.name}'
//         )
//         .toList();

//       setState(() {
//         imageUrls = urls;
//       });
//     } catch (e) {
//       print('Error fetching images: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Images from Supabase'),
//       ),
//       body: GridView.builder(
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           crossAxisSpacing: 10,
//           mainAxisSpacing: 10,
//         ),
//         itemCount: imageUrls.length,
//         itemBuilder: (context, index) {
//           final imageUrl = imageUrls[index];
//           return Image.network(
//             'https://dfhjoaazooyocmzfpsdu.supabase.co/storage/v1/object/public/photo-bucket/$imageUrl', 
//             fit: BoxFit.cover,
//           );
//         },
//       ),
//     );
//   }
// }
