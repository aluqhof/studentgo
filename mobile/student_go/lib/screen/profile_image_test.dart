import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_go/bloc/profile_image/profile_image_bloc.dart';
import 'package:student_go/repository/student/student_repository.dart';
import 'package:student_go/repository/student/student_repository_impl.dart';

class ProfileImageTest extends StatefulWidget {
  const ProfileImageTest({super.key});

  @override
  State<ProfileImageTest> createState() => _ProfileImageTestState();
}

class _ProfileImageTestState extends State<ProfileImageTest> {
  late StudentRepository studentRepository;
  late ProfileImageBloc _profileImageBloc;

  @override
  void initState() {
    studentRepository = StudentRepositoryImp();
    _profileImageBloc = ProfileImageBloc(studentRepository)
      ..add(FetchProfileImage());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _profileImageBloc,
      child: BlocBuilder<ProfileImageBloc, ProfileImageState>(
        builder: (context, state) {
          if (state is ProfileImageInitial || state is ProfileImageLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ProfileImageSuccess) {
            return Center(child: Image.memory(state.image));
          } else {
            return Text('Error');
          }
        },
      ),
    );
  }
}
