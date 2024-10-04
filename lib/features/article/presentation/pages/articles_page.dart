// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get/get.dart';
// import 'package:journal_web/routes.dart';
// import 'package:responsive_builder/responsive_builder.dart';
// import 'package:journal_web/features/article/data/models/article_model.dart';
// import 'package:journal_web/features/article/presentation/bloc/article_bloc.dart';

// class ArticlesPage extends StatefulWidget {
//   const ArticlesPage({super.key});

//   @override
//   State<ArticlesPage> createState() => _ArticlesPageState();
// }

// class _ArticlesPageState extends State<ArticlesPage> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<ArticleBloc>().add(GetAllArticlesEvent());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ArticleBloc, ArticleState>(
//       builder: (context, state) {
//         if (state is LoadingAllArticlesState) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (state is LoadedAllArticlesState) {
//           return Scaffold(
//             appBar: AppBar(
//               automaticallyImplyLeading: false,
//               title: const Text('Articles'),
//               backgroundColor: Colors.blue,
//               actions: [
//                 ElevatedButton(
//                   onPressed: () async {
//                     await Get.toNamed(Routes.dashboard + Routes.addArticle);
//                     setState(() {});
//                   },
//                   child: const Text('Add Article'),
//                   style: ElevatedButton.styleFrom(
//                     primary: Colors.green,
//                     onPrimary: Colors.white,
//                   ),
//                 ),
//               ],
//             ),
//             body: ResponsiveBuilder(
//               builder: (context, sizingInformation) {
//                 if (sizingInformation.deviceScreenType ==
//                     DeviceScreenType.desktop) {
//                   return _buildDesktopLayout(state.articles, context);
//                 } else {
//                   return _buildMobileLayout(state.articles);
//                 }
//               },
//             ),
//           );
//         } else if (state is ErrorArticleState) {
//           return Center(child: Text('Error: ${state.message}'));
//         } else {
//           return const Center(child: Text('Unknown state'));
//         }
//       },
//     );
//   }

//   Widget _buildDesktopLayout(List<ArticleModel> articles, BuildContext context) {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: SizedBox(
//         width: MediaQuery.of(context).size.width,
//         child: DataTable(
//           headingRowColor: MaterialStateProperty.all(Colors.blue[100]),
//           dataRowColor: MaterialStateProperty.resolveWith<Color?>(
//             (Set<MaterialState> states) {
//               if (states.contains(MaterialState.selected)) {
//                 return Theme.of(context).colorScheme.primary.withOpacity(0.08);
//               }
//               if (states.contains(MaterialState.hovered)) {
//                 return Colors.grey[100];
//               }
//               return null;
//             },
//           ),
//           columns: const [
//             DataColumn(label: Text('Title')),
//             DataColumn(label: Text('Author')),
//             DataColumn(label: Text('Publication Date')),
//             DataColumn(label: Text('Actions')),
//           ],
//           rows: articles.map((article) {
//             return DataRow(
//               cells: [
//                 DataCell(Text(article.title)),
//                 DataCell(Text(article.author)),
//                 DataCell(Text(article.publicationDate.toString())),
//                 DataCell(Row(
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.edit),
//                       onPressed: () {
//                         // Implement edit functionality
//                       },
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.delete),
//                       onPressed: () {
//                         // Implement delete functionality
//                       },
//                     ),
//                   ],
//                 )),
//               ],
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }

//   Widget _buildMobileLayout(List<ArticleModel> articles) {
//     return ListView.builder(
//       itemCount: articles.length,
//       itemBuilder: (context, index) {
//         final article = articles[index];
//         return Card(
//           margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//           child: ListTile(
//             title: Text(article.title),
//             subtitle: Text('${article.author} - ${article.publicationDate}'),
//             trailing: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.edit),
//                   onPressed: () {
//                     // Implement edit functionality
//                   },
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.delete),
//                   onPressed: () {
//                     // Implement delete functionality
//                   },
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
