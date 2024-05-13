class ServiceRequestCategory {
  late String code;
  late String name;
  late  String description;
  late bool isSelected;

  ServiceRequestCategory({required this.code, required this.name, this.isSelected= false, this.description=''});
}