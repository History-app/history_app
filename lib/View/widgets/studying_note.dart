import 'package:flutter/material.dart';
import 'package:japanese_history_app/Model/color/app_colors.dart';
import 'package:japanese_history_app/constant/app_strings.dart';
import 'package:japanese_history_app/Model/cache/cached_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:japanese_history_app/viewmodel/studying_screen/studying_note.dart';
import 'package:japanese_history_app/view/screens/modal.dart';
import 'package:japanese_history_app/model/notes/studying_note_state.dart';
import '../../model/widgets/common_app_bar.dart';

class StudyingNotePage extends ConsumerWidget {
  final String noteId;

  const StudyingNotePage({super.key, required this.noteId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(studyingNoteViewModelProvider(noteId), (prev, next) {
      if (next.errorMessage != null) {
        CommonsModal.show(
          context,
          title: Strings.imageLoadErrorMessage,
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        );
      }
    });

    final state = ref.watch(studyingNoteViewModelProvider(noteId));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(
        title: Strings.title,
        icon: SizedBox(
          width: 40,
          height: 40,
          child: IconButton(
            icon: Icon(
              Icons.chevron_left,
              size: 32,
              color: AppColors().primaryRed,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(StudyingNoteState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.imageUrl != null) {
      return CachedImage(url: state.imageUrl!);
    }

    return CachedImage(url: null);
  }
}
