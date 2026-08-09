abstract class Routes {
  static const splash = '/splash';
  static const splashName = 'splash';

  static const login = '/login';
  static const loginName = 'login';

  static const mandatoryChangePassword = '/mandatory/password';
  static const mandatoryChangePasswordName = 'mandatoryChangePassword';

  static const dashboard = '/dashboard';
  static const dashboardName = 'dashboard';

  static const inspetions = '/inspections';
  static const inspectionsName = 'inspections';

  static const newInspection = '/inspection/new';
  static const newInspectionName = 'newInspection';

  static const newInspectionPreview = '/inspection/new/preview';
  static const newInspectionPreviewName = 'newInspectionPreview';

  static const tickets = '/tickets';
  static const ticketsName = 'tickets';

  static const ticketDetail = '/ticket/:ticketId';
  static const ticketDetailName = 'ticketDetail';

  static const profile = '/profile';
  static const profileName = 'profile';

  static const editProfile = '/profile/edit';
  static const editProfileName = 'editProfile';

  static const changePassword = '/edit/password';
  static const changePasswordName = 'changePassword';
}