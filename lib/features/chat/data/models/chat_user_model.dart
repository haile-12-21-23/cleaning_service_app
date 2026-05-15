import 'package:chatview/chatview.dart';
import 'package:cleaning_service_app/features/profile/data/models/user_model.dart';

ChatUser chatUser(UserModel user) {
  return ChatUser(id: user.id, name: user.name);
}
