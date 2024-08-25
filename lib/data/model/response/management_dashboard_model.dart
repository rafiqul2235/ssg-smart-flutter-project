class ManagementDashboardModel {
  String insert_date ="";
  String month_date ="";
  String year_date ="";
  String date="";

   String scbl_call = '';
  String sscml_call = '';
   //double scbl_call_mon = 0;
  String sscil_call = '';
  String sspil_call = '';


  String so_amt_scbl = '';
  String so_amt_sscml = '';
   //double scbl_call_mon = 0;
  String so_amt_sscil = '';
  String so_amt_sspil = '';

   String scbl_received ="";
   String sscml_received ="";
   //double scbl_call_mon = 0;
   String sscil_received ="";
   String sspil_received ="";

  String so_scbl = '';
  String so_sscml = '';
   //double scbl_call_mon = 0;
  String so_sscil = '';
  String so_sspil = '';

  String total_call = '';
  String total_so_amt = '';
  String total_so='';
   String total_call_per = '';

  String target_scbl='';
  String target_sscml='';
  String target_sscil='';
   String total_mon='';

  String delivery_scbl='';
  String delivery_sscml='';
  String delivery_sscil='';
   String total_delivery='';

   String achi_scbl='';
   String achi_sscml='';
   String achi_sscil='';
   String total_achi='';

  String pending_scbl='';
  String pending_sscml='';
  String pending_sscil='';
   String total_pending='';


  String pro_scbl='';
  String pro_sscml='';
  String pro_sscil='';
   String total_pro='';

  String capa_scbl='';
  String capa_sscml='';
  String capa_sscil='';
   String total_capa='';

   String uit_scbl='';
   String uit_sscml='';
   String uit_sscil='';
   String total_uit='';



  ManagementDashboardModel({
    this.insert_date='',this.month_date='',this.year_date='',date,

    this.scbl_call='', this.sscml_call = '', this.sscil_call = '',this.sspil_call = '',
    this.so_amt_scbl='', this.so_amt_sscml = '', this.so_amt_sscil = '',this.so_amt_sspil = '',
    this.scbl_received="",this.sscml_received="",this.sscil_received="",this.sspil_received="",
    this.so_scbl='', this.so_sscml = '', this.so_sscil = '',this.so_sspil = '',
    this.total_call='', this.total_so_amt = '', this.total_so = '',this.total_call_per="",

    this.target_scbl='', this.target_sscml = '', this.target_sscil = '',this.total_mon="",
    this.delivery_scbl='', this.delivery_sscml = '', this.delivery_sscil = '',this.total_delivery="",
    this.achi_scbl='', this.achi_sscml = '', this.achi_sscil = '',this.total_achi="",
    this.pending_scbl='', this.pending_sscml = '', this.pending_sscil = '',this.total_pending="",

    this.pro_scbl='', this.pro_sscml = '', this.pro_sscil = '',this.total_pro="",
    this.capa_scbl='', this.capa_sscml = '', this.capa_sscil = '',this.total_capa="",
    this.uit_scbl='', this.uit_sscml = '', this.uit_sscil = '',this.total_uit="",


  });

  ManagementDashboardModel.fromJson(Map<String, dynamic> json) {
    insert_date = json['INSERT_DATE']??'';
    month_date = json['MONTH_DATE']??'';
    year_date = json['YEAR_DATE']??'';

    if(insert_date.isNotEmpty){
      date =json['INSERT_DATE']??'';
      scbl_call = json['COLL_DAY_SCBL']??'';
      sscml_call = json['COLL_DAY_SSCML']??'';
      //earned = double.parse(json['EARNED']??'0');
      sscil_call = json['COLL_DAY_SSCIL']??'';
      sspil_call = json['COLL_DAY_SSPIL']??'';

      so_amt_scbl = json['SO_AMT_DAY_SCBL']??'';
      so_amt_sscml = json['SO_AMT_DAY_SSCML']??'';
      so_amt_sscil = json['SO_AMT_DAY_SSCIL']??'';
      so_amt_sscil = json['SO_AMT_DAY_SSPIL']??'';

      scbl_received = json['SCBL_RECEIVED_DAY']??'';
      sscml_received = json['SSCML_RECEIVED_DAY']??'';
      sscil_received = json['SSCIL_RECEIVED_DAY']??'';
      sspil_received = json['SSPIL_RECEIVED_DAY']??'';

      so_scbl = json['SO_DAY_SCBL']??'';
      so_sscml = json['SO_DAY_SSCML']??'';
      so_sscil = json['SO_DAY_SSCIL']??'';
      so_sspil = json['SO_DAY_SSPIL']??'';

      total_call = json['TOTAL_COLL_DAY']??'';
      total_so_amt = json['TOTAL_SO_AMT_DAY']??'';
      total_so = json['TOTAL_SO_DAY']??'';
      //total_call_per = json['TOTAL_COLL_PERT_DAY']??'';

      target_scbl = json['TARGET_DAY_SCBL']??'';
      target_sscml = json['TARGET_DAY_SSCML']??'';
      target_sscil = json['TARGET_DAY_SSCIL']??'';
      total_mon = json['TOTAL_TARGET_DAY']??'';

      delivery_scbl = json['DELIVERY_DAY_SCBL']??'';
      delivery_sscml = json['DELIVERY_DAY_SSCML']??'';
      delivery_sscil = json['DELIVERY_DAY_SSCIL']??'';
      total_delivery = json['TOTAL_DELIVERY_DAY']??'';

      achi_scbl = json['ACHI_DAY_SCBL']??'';
      achi_sscml = json['ACHI_DAY_SSCML']??'';
      achi_sscil = json['ACHI_DAY_SSCIL']??'';
      total_achi = json['TOTAL_ACHIEVE_DAY']??'';

      pending_scbl = json['PENDING_DAY_SCBL']??'';
      pending_sscml = json['PENDING_DAY_SSCML']??'';
      pending_sscil = json['PENDING_DAY_SSCIL']??'';
      total_pending = json['TOTAL_PENDING_DAY']??'';

      pro_scbl = json['PRO_DAY_SCBL']??'';
      pro_sscml = json['PRO_DAY_SSCML']??'';
      pro_sscil = json['PRO_DAY_SSCIL']??'';
      total_pro = json['TOTAL_PENDING_DAY']??'';

      capa_scbl = json['CAPA_DAY_SCBL']??'';
      capa_sscml = json['CAPA_DAY_SSCML']??'';
      capa_sscil = json['CAPA_DAY_SSCIL']??'';
      total_capa = json['TOTAL_CAPA_DAY']??'';

      uit_scbl = json['UTI_DAY_SCBL']??'';
      uit_sscml = json['UTI_DAY_SSCML']??'';
      uit_sscil = json['UTI_DAY_SSCIL']??'';
      total_uit = json['TOTAL_UTI_DAY']??'';
    }

    else if(month_date.isNotEmpty){
      date =json['MONTH_DATE']??'';
      scbl_call = json['COLL_MON_SCBL']??'';
      sscml_call = json['COLL_MON_SSCML']??'';
      //earned = double.parse(json['EARNED']??'0');
      sscil_call = json['COLL_MON_SSCIL']??'';
      sspil_call = json['COLL_MON_SSPIL']??'';

      so_amt_scbl = json['SO_AMT_MONTH_SCBL']??'';
      so_amt_sscml = json['SO_AMT_MONTH_SSCML']??'';
      so_amt_sscil = json['SO_AMT_MONTH_SSCIL']??'0';
      so_amt_sspil = json['SO_AMT_MONTH_SSPIL']??'0';

      scbl_received = json['SCBL_RECEIVED_MON']??'';
      sscml_received = json['SSCML_RECEIVED_MON']??'';
      sscil_received = json['SSCIL_RECEIVED_MON']??'';
      sspil_received = json['SSPIL_RECEIVED_MON']??'';

      so_scbl = json['SO_MON_SCBL']??'';
      so_sscml = json['SO_MON_SSCML']??'';
      so_sscil = json['SO_MON_SSCIL']??'';
      so_sspil = json['SO_MON_SSPIL']??'';

      total_call = json['TOTAL_COLL_MON']??'';
      total_so_amt = json['TOTAL_SO_AMT_MON']??'';
      total_so = json['TOTAL_SO_MON']??'';
      //total_call_per = json['TOTAL_COLL_PERT_MON']??'';

      target_scbl = json['TARGET_MON_SCBL']??'';
      target_sscml = json['TARGET_MON_SSCML']??'';
      target_sscil = json['TARGET_MON_SSCIL']??'';
      total_mon = json['TOTAL_TARGET_MON']??'';

      delivery_scbl = json['DELIVERY_MON_SCBL']??'';
      delivery_sscml = json['DELIVERY_MON_SSCML']??'';
      delivery_sscil = json['DELIVERY_MON_SSCIL']??'';
      total_delivery = json['TOTAL_DELIVERY_MON']??'';

      achi_scbl = json['ACHI_MON_SCBL']??'';
      achi_sscml = json['ACHI_MON_SSCML']??'';
      achi_sscil = json['ACHI_MON_SSCIL']??'';
      total_achi = json['TOTAL_ACHIEVE_MON']??'';

      pending_scbl = json['PENDING_MONTH_SCBL']??'';
      pending_sscml = json['PENDING_MONTH_SSCML']??'';
      pending_sscil = json['PENDING_MONTH_SSCIL']??'';
      total_pending = json['TOTAL_PENDING_MON']??'';

      pro_scbl = json['PRO_MON_SCBL']??'';
      pro_sscml = json['PRO_MON_SSCML']??'';
      pro_sscil = json['PRO_MON_SSCIL']??'';
      total_pro = json['TOTAL_PENDING_MON']??'';

      capa_scbl = json['CAPA_MON_SCBL']??'';
      capa_sscml = json['CAPA_MON_SSCML']??'';
      capa_sscil = json['CAPA_MON_SSCIL']??'';
      total_capa = json['TOTAL_CAPA_MON']??'';

      uit_scbl = json['UTI_MON_SCBL']??'';
      uit_sscml = json['UTI_MON_SSCML']??'';
      uit_sscil = json['UTI_MON_SSCIL']??'';
      total_uit = json['TOTAL_UTI_MON']??'';
    }

else {
      date =json['YEAR_DATE']??'';
      scbl_call = json['COLL_YEAR_SCBL']??'';
      sscml_call = json['COLL_YEAR_SSCML']??'';
      //earned = double.parse(json['EARNED']??'0');
      sscil_call = json['COLL_YEAR_SSCIL']??'';
      sspil_call = json['COLL_YEAR_SSPIL']??'';

      so_amt_scbl = json['SO_AMT_YEAR_SCBL']??'';
      so_amt_sscml = json['SO_AMT_YEAR_SSCML']??'';
      so_amt_sscil = json['SO_AMT_YEAR_SSCIL']??'';
      so_amt_sspil = json['SO_AMT_YEAR_SSPIL']??'';

      scbl_received = json['SCBL_RECEIVED_YEAR']??'';
      sscml_received = json['SSCML_RECEIVED_YEAR']??'';
      sscil_received = json['SSCIL_RECEIVED_YEAR']??'';
      sspil_received = json['SSPIL_RECEIVED_YEAR']??'';

      so_scbl = json['SO_YEAR_SCBL']??'';
      so_sscml = json['SO_YEAR_SSCML']??'';
      so_sscil = json['SO_YEAR_SSCIL']??'';
      so_sspil = json['SO_YEAR_SSPIL']??'';

      total_call = json['TOTAL_COLL_YEAR']??'';
      total_so_amt = json['TOTAL_SO_AMT_YEAR']??'';
      total_so = json['TOTAL_SO_YEAR']??'0';
      total_call_per = json['TOTAL_COLL_PERT_YEAR']??'';

      target_scbl = json['TARGET_YEAR_SCBL']??'';
      target_sscml = json['TARGET_YEAR_SSCML']??'';
      target_sscil = json['TARGET_YEAR_SSCIL']??'';
      total_mon = json['TOTAL_TARGET_YEAR']??'';

      delivery_scbl = json['DELIVERY_YEAR_SCBL']??'';
      delivery_sscml = json['DELIVERY_YEAR_SSCML']??'';
      delivery_sscil = json['DELIVERY_YEAR_SSCIL']??'';
      total_delivery = json['TOTAL_DELIVERY_YEAR']??'';

      achi_scbl = json['ACHI_YEAR_SCBL']??'';
      achi_sscml = json['ACHI_YEAR_SSCML']??'';
      achi_sscil = json['ACHI_YEAR_SSCIL']??'';
      total_achi = json['TOTAL_ACHIEVE_YEAR']??'';

      pending_scbl = json['PENDING_YEAR_SCBL']??'';
      pending_sscml = json['PENDING_YEAR_SSCML']??'';
      pending_sscil = json['PENDING_YEAR_SSCIL']??'';
      total_pending = json['TOTAL_PENDING_YEAR']??'';

      pro_scbl = json['PRO_YEAR_SCBL']??'';
      pro_sscml = json['PRO_YEAR_SSCML']??'';
      pro_sscil = json['PRO_YEAR_SSCIL']??'';
      total_pro = json['TOTAL_PROD_YEAR']??'';

      capa_scbl = json['CAPA_YEAR_SCBL']??'';
      capa_sscml = json['CAPA_YEAR_SSCML']??'';
      capa_sscil = json['CAPA_YEAR_SSCIL']??'';
      total_capa = json['TOTAL_CAPA_YEAR']??'';

      uit_scbl = json['UTI_YEAR_SCBL']??'';
      uit_sscml = json['UTI_YEAR_SSCML']??'';
      uit_sscil = json['UTI_YEAR_SSCIL']??'';
      total_uit = json['TOTAL_UTI_YEAR']??'';
    }


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['INSERT_DATE'] = insert_date;
    data['MONTH_DATE'] = month_date;
    data['YEAR_DATE'] = year_date;

    if(insert_date.isNotEmpty) {
      data['INSERT_DATE'] = data;
      data['COLL_DAY_SCBL'] = scbl_call;
      data['COLL_DAY_SSCML'] = sscml_call;
      //data['EARNED'] = earned;
      data['COLL_DAY_SSCIL'] = sscil_call;
      data['COLL_DAY_SSPIL'] = sspil_call;

      data['COLL_DAY_SCBL'] = so_amt_scbl;
      data['COLL_DAY_SSCML'] = so_amt_sscml;
      data['COLL_DAY_SSCIL'] = so_amt_sscil;
      data['COLL_DAY_SSPIL'] = so_amt_sspil;

      data['SCBL_RECEIVED_DAY'] = scbl_received;
      data['SSCML_RECEIVED_DAY'] = sscml_received;
      data['SSCIL_RECEIVED_DAY'] = sscil_received;
      data['SSPIL_RECEIVED_DAY'] = sspil_received;

      data['SO_DAY_SCBL'] = so_scbl;
      data['SO_DAY_SSCML'] = so_sscml;
      data['SO_DAY_SSCIL'] = so_sscil;
      data['SO_DAY_SSPIL'] = so_sspil;

      data['TOTAL_COLL_DAY'] = total_call;
      data['TOTAL_SO_AMT_DAY'] = total_so_amt;
      data['TOTAL_SO_DAY'] = total_so;
      data['TOTAL_COLL_PERT_DAY'] = total_call_per;

      data['TARGET_DAY_SCBL'] = target_scbl;
      data['TARGET_DAY_SSCML'] = target_sscml;
      data['TARGET_DAY_SSCIL'] = target_sscil;
      data['TOTAL_TARGET_DAY'] = total_mon;

      data['DELIVERY_DAY_SCBL'] = delivery_scbl;
      data['DELIVERY_DAY_SSCML'] = delivery_sscml;
      data['DELIVERY_DAY_SSCIL'] = delivery_sscil;
      data['TOTAL_DELIVERY_DAY'] = total_delivery;

      data['ACHI_DAY_SCBL'] = achi_scbl;
      data['ACHI_DAY_SSCML'] = achi_sscml;
      data['ACHI_DAY_SSCIL'] = achi_sscil;
      data['TOTAL_ACHIEVE_DAY'] = total_achi;

      data['PENDING_DAY_SCBL'] = pending_scbl;
      data['PENDING_DAY_SSCML'] = pending_sscml;
      data['PENDING_DAY_SSCIL'] = pending_sscil;
      data['TOTAL_DAY_MON'] = total_pending;

      data['PRO_DAY_SCBL'] = pro_scbl;
      data['PRO_DAY_SSCML'] = pro_sscml;
      data['PRO_DAY_SSCIL'] = pro_sscil;
      data['TOTAL_PROD_DAY'] = total_pro;

      data['CAPA_DAY_SCBL'] = capa_scbl;
      data['CAPA_DAY_SSCML'] = capa_sscml;
      data['CAPA_DAY_SSCIL'] = capa_sscil;
      data['TOTAL_CAPA_DAY'] = total_capa;

      data['UTI_DAY_SCBL'] = uit_scbl;
      data['UTI_DAY_SSCML'] = uit_sscml;
      data['UTI_DAY_SSCIL'] = uit_sscil;
      data['TOTAL_UTI_DAY'] = total_uit;
    }

    else if(month_date.isNotEmpty) {
      data['MONTH_DATE'] = data;
      data['COLL_MON_SCBL'] = scbl_call;
      data['COLL_MON_SSCML'] = sscml_call;
      //data['EARNED'] = earned;
      data['COLL_MON_SSCIL'] = sscil_call;
      data['COLL_MON_SSPIL'] = sspil_call;

      data['COLL_MON_SCBL'] = so_amt_scbl;
      data['COLL_MON_SSCML'] = so_amt_sscml;
      data['COLL_MON_SSCIL'] = so_amt_sscil;
      data['COLL_MON_SSPIL'] = so_amt_sspil;

      data['SCBL_RECEIVED_MON'] = scbl_received;
      data['SSCML_RECEIVED_MON'] = sscml_received;
      data['SSCIL_RECEIVED_MON'] = sscil_received;
      data['SSPIL_RECEIVED_MON'] = sspil_received;

      data['SO_MON_SCBL'] = so_scbl;
      data['SO_MON_SSCML'] = so_sscml;
      data['SO_MON_SSCIL'] = so_sscil;
      data['SO_MON_SSPIL'] = so_sspil;

      data['TOTAL_COLL_MON'] = total_call;
      data['TOTAL_SO_AMT_MON'] = total_so_amt;
      data['TOTAL_SO_MON'] = total_so;
      data['TOTAL_COLL_PERT_MON'] = total_call_per;

      data['TARGET_MON_SCBL'] = target_scbl;
      data['TARGET_MON_SSCML'] = target_sscml;
      data['TARGET_MON_SSCIL'] = target_sscil;
      data['TOTAL_TARGET_MON'] = total_mon;

      data['DELIVERY_MON_SCBL'] = delivery_scbl;
      data['DELIVERY_MON_SSCML'] = delivery_sscml;
      data['DELIVERY_MON_SSCIL'] = delivery_sscil;
      data['TOTAL_DELIVERY_MON'] = total_delivery;

      data['ACHI_MON_SCBL'] = achi_scbl;
      data['ACHI_MON_SSCML'] = achi_sscml;
      data['ACHI_MON_SSCIL'] = achi_sscil;
      data['TOTAL_ACHIEVE_MON'] = total_achi;

      data['PENDING_MONTH_SCBL'] = pending_scbl;
      data['PENDING_MONTH_SSCML'] = pending_sscml;
      data['PENDING_MONTH_SSCIL'] = pending_sscil;
      data['TOTAL_PENDING_MON'] = total_pending;

      data['PRO_MON_SCBL'] = pro_scbl;
      data['PRO_MON_SSCML'] = pro_sscml;
      data['PRO_MON_SSCIL'] = pro_sscil;
      data['TOTAL_PROD_MON'] = total_pro;

      data['CAPA_MON_SCBL'] = capa_scbl;
      data['CAPA_MON_SSCML'] = capa_sscml;
      data['CAPA_MON_SSCIL'] = capa_sscil;
      data['TOTAL_CAPA_MON'] = total_capa;

      data['UTI_MON_SCBL'] = uit_scbl;
      data['UTI_MON_SSCML'] = uit_sscml;
      data['UTI_MON_SSCIL'] = uit_sscil;
      data['TOTAL_UTI_MON'] = total_uit;
    }

    else {
      data['YEAR_DATE'] = data;
      data['COLL_YEAR_SCBL'] = scbl_call;
      data['COLL_YEAR_SSCML'] = sscml_call;
      //data['EARNED'] = earned;
      data['COLL_YEAR_SSCIL'] = sscil_call;
      data['COLL_YEAR_SSPIL'] = sspil_call;

      data['COLL_YEAR_SCBL'] = so_amt_scbl;
      data['COLL_YEAR_SSCML'] = so_amt_sscml;
      data['COLL_YEAR_SSCIL'] = so_amt_sscil;
      data['COLL_YEAR_SSPIL'] = so_amt_sspil;

      data['SCBL_RECEIVED_YEAR'] = scbl_received;
      data['SSCML_RECEIVED_YEAR'] = sscml_received;
      data['SSCIL_RECEIVED_YEAR'] = sscil_received;
      data['SSPIL_RECEIVED_YEAR'] = sspil_received;

      data['SO_YEAR_SCBL'] = so_scbl;
      data['SO_YEAR_SSCML'] = so_sscml;
      data['SO_YEAR_SSCIL'] = so_sscil;
      data['SO_YEAR_SSPIL'] = so_sspil;

      data['TOTAL_COLL_YEAR'] = total_call;
      data['TOTAL_SO_AMT_YEAR'] = total_so_amt;
      data['TOTAL_SO_YEAR'] = total_so;
      data['TOTAL_COLL_PERT_YEAR'] = total_call_per;

      data['TARGET_YEAR_SCBL'] = target_scbl;
      data['TARGET_YEAR_SSCML'] = target_sscml;
      data['TARGET_YEAR_SSCIL'] = target_sscil;
      data['TOTAL_TARGET_YEAR'] = total_mon;

      data['DELIVERY_YEAR_SCBL'] = delivery_scbl;
      data['DELIVERY_YEAR_SSCML'] = delivery_sscml;
      data['DELIVERY_YEAR_SSCIL'] = delivery_sscil;
      data['TOTAL_DELIVERY_YEAR'] = total_delivery;

      data['ACHI_YEAR_SCBL'] = achi_scbl;
      data['ACHI_YEAR_SSCML'] = achi_sscml;
      data['ACHI_YEAR_SSCIL'] = achi_sscil;
      data['TOTAL_ACHIEVE_YEAR'] = total_achi;

      data['PENDING_YEAR_SCBL'] = pending_scbl;
      data['PENDING_YEAR_SSCML'] = pending_sscml;
      data['PENDING_YEAR_SSCIL'] = pending_sscil;
      data['TOTAL_PENDING_YEAR'] = total_pending;

      data['PRO_YEAR_SCBL'] = pro_scbl;
      data['PRO_YEAR_SSCML'] = pro_sscml;
      data['PRO_YEAR_SSCIL'] = pro_sscil;
      data['TOTAL_PROD_YEAR'] = total_pro;

      data['CAPA_YEAR_SCBL'] = capa_scbl;
      data['CAPA_YEAR_SSCML'] = capa_sscml;
      data['CAPA_YEAR_SSCIL'] = capa_sscil;
      data['TOTAL_CAPA_YEAR'] = total_capa;

      data['UTI_YEAR_SCBL'] = uit_scbl;
      data['UTI_YEAR_SSCML'] = uit_sscml;
      data['UTI_YEAR_SSCIL'] = uit_sscil;
      data['TOTAL_UTI_YEAR'] = total_uit;
    }




    return data;
  }

}