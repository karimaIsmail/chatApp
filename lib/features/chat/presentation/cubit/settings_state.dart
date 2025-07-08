import 'package:chatapp/features/chat/domain/entities/settings_entity.dart';
import 'package:equatable/equatable.dart';

class SettingsState extends Equatable {
  final SettingsEntity settings;
  const SettingsState({required this.settings});
  SettingsState copywith({SettingsEntity? settings}) {
    return SettingsState(settings: settings ?? this.settings);
  }

  @override
  List<Object> get props => [settings];
}

class SettingsStatetInitial extends SettingsState {
  SettingsStatetInitial()
      : super(
            settings: SettingsEntity(
                colorsIndex: 0,
                toggleLanguage: false,
                language: enLanguage.english,
                toggleSettings: false,
                toggleColors: false,
                errorMessage: ''));
}

class updateSettingsState extends SettingsState {
  const updateSettingsState({required super.settings});
}

class SignOutSucessState extends SettingsState {
  const SignOutSucessState({required super.settings});
}

class SignOutFailureState extends SettingsState {
  const SignOutFailureState({
    required super.settings,
  });
}
