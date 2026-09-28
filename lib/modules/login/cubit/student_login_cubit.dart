import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiddo/main.dart';
import 'package:kiddo/student_repo/home_repo.dart';
import 'package:kiddo/student_repo/login_repo.dart';

part 'student_login_state.dart';

class StudentLoginCubit extends Cubit<StudentLoginState> {
  final LoginRepo _loginRepo;
  final HomeRepo _homeRepo;

  StudentLoginCubit({
    required LoginRepo loginRepo,
    required HomeRepo homeRepo,
  })  : _loginRepo = loginRepo,
        _homeRepo = homeRepo,
        super(StudentLoginInitial());

  Future<void> login(String phone, String password) async {
    emit(StudentLoginLoading());

    try {
      bool loged = await _loginRepo.login(phone, password);

      if (loged) {
        listClass = await _loginRepo.getListClass();
        listCategory = await _homeRepo.getCategories();

        emit(StudentLoginSuccess());
      } else {
        emit(StudentLoginFailure(
            'Đăng nhập thất bại. Vui lòng kiểm tra lại mã học sinh và mật khẩu.'));
      }
    } catch (e) {
      emit(StudentLoginFailure('Đã xảy ra lỗi kết nối. Vui lòng thử lại sau.'));
    }
  }
}
