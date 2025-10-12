import 'package:dart_either/dart_either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tech_task/data/models/post_model.dart';
import 'package:flutter_tech_task/domain/usecases/get_posts_usecase.dart';
import 'package:flutter_tech_task/presentation/viewmodels/base_vm.dart';
import 'package:flutter_tech_task/utils/api_error.dart';

class PageListViewModel extends BaseViewModel with ChangeNotifier {
  PageListViewModel(this.getPostsUseCase);
  late GetPostsUseCase getPostsUseCase;
  bool isLoading = false;
  Either<ApiError, List<Post>> posts = const Right([]);

  @override
  void initializeViewModel() {
    isLoading = true;
    notifyListeners();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    try {
      await getPostsUseCase.call().then(((onValue) {
        posts = onValue;
      }));
    } on Exception catch (e) {
      posts = Left(ApiError(message: e.toString(), type: ApiErrorType.unknown));
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void disposeViewModel() {
    posts = const Right([]);
    notifyListeners();
    super.dispose();
  }
}
