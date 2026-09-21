part of 'student_login_cubit.dart';

abstract class StudentLoginState {}

class StudentLoginInitial extends StudentLoginState {}

class StudentLoginLoading extends StudentLoginState {}

class StudentLoginSuccess extends StudentLoginState {}

class StudentLoginFailure extends StudentLoginState {
  final String error;

  StudentLoginFailure(this.error);
}
