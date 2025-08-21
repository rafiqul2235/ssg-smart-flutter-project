import 'package:ssg_smart2/data/model/response/language_model.dart';
import 'package:geolocator/geolocator.dart';

class AppConstants {
  static const String APP_NAME = 'SMART';

  // static const String BASE_URL = 'https://smartapp.ssgil.com/'; // live
  //  static const String BASE_URL = 'http://10.25.4.120/'; //production

  static const String BASE_URL = 'http://10.27.1.177/api/'; //oracle cloud test
  // static const String BASE_URL = 'http://10.0.2.2/'; //android local ip
  // static const String BASE_URL = 'http://192.168.1.102/'; //HOME IP
  // static const String BASE_URL = 'http://172.29.10.250/api/'; // Ofiice IP
  //static const String BASE_URL = 'http://172.29.10.231/'; // local host

  static const int APP_VERSION_CODE = 10;
  static const String APP_VERSION_NAME = '1.0.8';
  static const double GEO_FENCING_DISTANCE = 100; // in meter
  static const LocationAccuracy Location_Accuracy = LocationAccuracy.best;
  static const int BATTARY_SERIAL_NO_SIZE = 10;

  // API Methods
  static const String LOGIN_URI = 'login';
  static const String USER_MENU_URI = 'menus';
  static const String EMP_Self_Service_List = 's_service_list';
  static const String APPROVAL_List = 'leave_approval_flow';
  static const String EMP_INFO = 'emp_info';
  static const String LEAVE_BALANCE = 'leave_balance';
  static const String Customer_BALANCE = 'customer_balance';
  static const String Item_PRICE = 'item_price_display';
  static const String AVAIL_Cust_BAL = 'cust_balance';
  static const String ITEM = 'items';
  static const String MANAGEMENT_DATA = 'bod_target_aciv_scbl';
  static const String MANAGEMENT_DATA_GCF = 'bod_target_aciv_gcf';
  static const String PF_DATA = 'pf_ledger';
  static const String PF_SUMMARY_DATA = 'pf_ledger_summary';
  static const String ATTENDANCE_DATA = 'attendence_sheet';
  static const String MSD_REPORT_DATA = 'notification';
  static const String DLV_INFO_DATA = 'delivery_info_by_smart_for_sp';
  static const String ATTENDANCE_SUMMARY = 'attendence_summary';
  static const String LEAVE_TYPE = 'leave_type';
  static const String SP_CUST_LIST = 'cust_wise_notification_for_sp';
  static const String SP_TRIP_NUMBER = 'trip_num_for_sr';
  static const String SALES_SUMMARY_DATA = 'sales_person_summary_report';
  static const String ITEM_WISE_PENDING_DATA = 'item_wise_pending_sp';
  static const String CUST_TARGET_VS_ACHIV_DATA = 'target_vs_achivement';
  static const String BALANCE_CONFIRMATION_DATA = 'cust_balance_confirmation';
  static const String LEAVE_APPLY = 'leave_save';
  static const String DUPLICATE_LEAVE = 'duplicate-leaveCheck';
  static const String SINGLE_OCCASION_LEAVE = 'check_singleOccasionLeave';
  static const String PROBATION_STATUS = 'check_probation_status';
  static const String APPLICATION_HISTORY = 'leave_approval_history';
  static const String LOAN_APPLICATION_HISTORY = 'salary_pf_approval_history';
  static const String APPROVAL_HISTORY = 'flutter_approval_history';
  static const String CASH_PAYMENT_AKG = 'cash_payment_akg';
  static const String RSM_APPROVAL_FLOW_LIST = 'sales_order_booked_rsm_flow';
  static const String CASH_PAYMENT_HISTORY = 'cash_payment_akg_history';
  static const String CASH_PAYMENT_UPDATE = 'cash_payment_update';
  static const String SOBOKKED_APPROVAL_UPDATE = 'rsm_sales_approval_booked';
  static const String CHUTI_APPROVAL = 'chuti_approval_flow';

  static const String PAY_SLIP = 'emp_pay_slip';
  static const String SAL_ELIGIBLE_INFO = 'salary_eligible_info';
  static const String SAL_LOAN_INFO = 'salary_loan_info';
  static const String PF_ELIGIBLE_INFO = 'pf_eligible_info';
  static const String PF_LOAN_INFO = 'pf_loan_info';
  static const String PF_INSTALLMENT = 'pf_installment';
  static const String SAVE_LOAN_DATA = 'save_loan_data';
  static const String CHANGE_PASSWORD = 'change_password_flutter';
  static const String WPPF_LEDGER = 'wppf_ledger';
  static const String SALES = 'sales';
  static const String ORDERS = 'orders';
  static const String COLLECTION = 'collection';
  static const String PENDINGSO = 'pending_so_cust_id';
  static const String NEW_SALE_SUBMIT = 'flutter-new-sale';
  static const String NEW_SALE_BOOKED_SUBMIT = 'flutter-new-sale_booked';
  static const String NEW_COLLECTION_SUBMIT = 'flutter-new-collection';
  static const String DELIVERY_RREQUEST_SUBMIT = 'flutter-delivery-request';

  // AIT project
  static const String AIT_AUTOMATION = 'ait_automation_new';
  static const String AIT_VIEW = 'fetch_ait_info';
  static const String AIT_DETAILS = 'fetch_ait_details';
  static const String AIT_ESSENTIAL = 'ait_essential';
  static const String CHECK_CHALLAN = 'check_challan_number';
  static const String UPDATE_AIT = 'update_ait_automation_new';

  //MO project
  static const String MO_LIST = 'mo_list';
  static const String APPROVER_MO_LIST = 'approver_mo_list';
  static const String MO_DETAILS = 'mo_details';
  static const String MO_SUBMISSION = 'mo_submission';


  // Approval
  static const String APPROVAL_FLOW = 'approval_flow';

  //static const String LOGIN_USERID = 'USER_ID';

  // sharePreference
  static const String TOKEN = 'token';
  static const String CREDENTIAL_REMEMBER = 'user_credential_remember';
  static const String USER_DATA = 'user_data';
  static const String NAME = 'name';
  static const String USER = 'user';
  static const String USER_ID = 'user_id';
  static const String USER_NAME = 'user_name';
  static const String ORG_ID = 'org_id';
  static const String SALESREP_ID = 'SALESREP_ID';
  static const String ORG_NAME = 'org_name';
  static const String CHANGE_PASSWORD_FLUG = 'password_flag';

  static const String USER_PIN_CODE = 'user_pin_code';
  static const String USER_PASSWORD = 'user_password';
  static const String USER_EMAIL = 'user_mail';
  static const String HOME_ADDRESS = 'home_address';
  static const String SEARCH_ADDRESS = 'search_address';
  static const String OFFICE_ADDRESS = 'office_address';
  static const String CART_LIST = 'cart_list';
  static const String CONFIG = 'config';
  static const String GUEST_MODE = 'guest_mode';
  static const String CURRENCY = 'currency';
  static const String LANG_KEY = 'lang';
  static const String INTRO = 'intro';

  // order status
  static const String PENDING = 'pending';
  static const String CONFIRMED = 'confirmed';
  static const String PROCESSING = 'processing';
  static const String PROCESSED = 'processed';
  static const String DELIVERED = 'delivered';
  static const String FAILED = 'failed';
  static const String RETURNED = 'returned';
  static const String CANCELLED = 'canceled';
  static const String OUT_FOR_DELIVERY = 'out_for_delivery';
  static const String COUNTRY_CODE = 'country_code';
  static const String LANGUAGE_CODE = 'language_code';
  static const String THEME = 'theme';
  static const String TOPIC = '';

  static List<LanguageModel> languages = [
    LanguageModel(imageUrl: '', languageName: 'English', countryCode: 'US', languageCode: 'en'),
    LanguageModel(imageUrl: '', languageName: 'বাংলা', countryCode: 'BD', languageCode: 'bn'),
  ];

}

