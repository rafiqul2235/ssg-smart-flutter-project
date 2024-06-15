class ManagementDashboardModel {

   int scbl_call_mon = 0;
   int sscml_call_mon = 0;
   //double scbl_call_mon = 0;
   int sscil_call_mon = 0;

   int so_amt_month_scbl = 0;
   int so_amt_month_sscml = 0;
   //double scbl_call_mon = 0;
   int so_amt_month_sscil = 0;

   String scbl_received_mon ="";
   String sscml_received_mon ="";
   //double scbl_call_mon = 0;
   String sscil_received_mon ="";

   int so_mon_scbl = 0;
   int so_mon_sscml = 0;
   //double scbl_call_mon = 0;
   int so_mon_sscil = 0;



  ManagementDashboardModel({
    this.scbl_call_mon=0, this.sscml_call_mon = 0, this.sscil_call_mon = 0,
    this.so_amt_month_scbl=0, this.so_amt_month_sscml = 0, this.so_amt_month_sscil = 0,
    this.scbl_received_mon="",this.sscml_received_mon="",this.sscil_received_mon="",
    this.so_mon_scbl=0, this.so_mon_sscml = 0, this.so_mon_sscil = 0,
  });

  ManagementDashboardModel.fromJson(Map<String, dynamic> json) {
    scbl_call_mon = int.parse(json['COLL_MON_SCBL']??'0');
    sscml_call_mon = int.parse(json['COLL_MON_SSCML']??'0');
    //earned = double.parse(json['EARNED']??'0');
    sscil_call_mon = int.parse(json['COLL_MON_SSCIL']??'0');

    so_amt_month_scbl = int.parse(json['SO_AMT_MONTH_SCBL']??'0');
    so_amt_month_sscml = int.parse(json['SO_AMT_MONTH_SSCML']??'0');
    so_amt_month_sscil = int.parse(json['SO_AMT_MONTH_SSCIL']??'0');

    scbl_received_mon = json['SCBL_RECEIVED_MON']??'';
    sscml_received_mon = json['SSCML_RECEIVED_MON']??'';
    sscil_received_mon = json['SSCIL_RECEIVED_MON']??'';

    so_mon_scbl = int.parse(json['SO_MON_SCBL']??'0');
    so_mon_sscml = int.parse(json['SO_MON_SSCML']??'0');
    so_mon_sscil = int.parse(json['SO_MON_SSCIL']??'0');

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['COLL_MON_SCBL'] = scbl_call_mon;
    data['COLL_MON_SSCML'] = sscml_call_mon;
    //data['EARNED'] = earned;
    data['COLL_MON_SSCIL'] = sscil_call_mon;

    data['COLL_MON_SCBL'] = so_amt_month_scbl;
    data['COLL_MON_SSCML'] = so_amt_month_sscml;
    data['COLL_MON_SSCIL'] = so_amt_month_sscil;

    data['SCBL_RECEIVED_MON'] = scbl_received_mon;
    data['SSCML_RECEIVED_MON'] = sscml_received_mon;
    data['SSCIL_RECEIVED_MON'] = sscil_received_mon;

    data['SO_MON_SCBL'] = so_mon_scbl;
    data['SO_MON_SSCML'] = so_mon_sscml;
    data['SO_MON_SSCIL'] = so_mon_sscil;

    return data;
  }

}