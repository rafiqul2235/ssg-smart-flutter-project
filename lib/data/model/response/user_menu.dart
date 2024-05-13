class UserMenu {

  int? moduleId;
  String? moduleName ;
  int? userGroupId ;
  String? userGroupName ;
  int? userRoleId ;
  String? userRoleName ;
  int? pageId;
  String? pageName ;
  String? pageDisplayName ;
  String? pageDescription ;
  bool? hasView ;
  bool? hasAdd ;
  bool? hasEdit ;
  bool? hasDelete ;
  bool? hasPrint ;

  UserMenu.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    moduleId = json['moduleId'];
    moduleName = json['moduleName'];
    userGroupId = json['userGroupId'];
    userGroupName = json['userGroupName'];
    userRoleId = json['userRoleId'];
    userRoleName = json['userRoleName'];
    pageId = json['pageId'];
    pageName = json['pageName'];
    pageDisplayName = json['pageDisplayName'];
    pageDescription = json['pageDescription'];
    hasView = json['hasView'];
    hasAdd = json['hasAdd'];
    hasEdit = json['hasEdit'];
    hasDelete = json['hasDelete'];
    hasPrint = json['hasPrint'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['moduleId'] = moduleId ;
    json['moduleName'] = moduleName ;
    json['userGroupId'] = userGroupId ;
    json['userGroupName'] = userGroupName ;
    json['userRoleId'] = userRoleId ;
    json['userRoleName'] = userRoleName ;
    json['pageId'] = pageId ;
    json['pageName'] = pageName ;
    json['pageDescription'] = pageDescription ;
    json['hasView'] = hasView ;
    json['hasAdd'] = hasAdd ;
    json['hasEdit'] = hasEdit ;
    json['hasDelete'] = hasDelete ;
    json['hasPrint'] = hasPrint ;
    return json;
  }

  @override
  String toString() {
    return 'UserMenu{moduleId: $moduleId, moduleName: $moduleName, userGroupId: $userGroupId, userGroupName: $userGroupName, userRoleId: $userRoleId, userRoleName: $userRoleName, pageId: $pageId, pageName: $pageName, pageDescription: $pageDescription, hasView: $hasView, hasAdd: $hasAdd, hasEdit: $hasEdit, hasDelete: $hasDelete, hasPrint: $hasPrint}';
  }
}