class VAcount {
  String id;
  int accontp;
  double balance;
  String accountNAME;
  String accountFULLNAME;
  int accountLEVEL;
  double balanceIQ;
  double balanceCUR;
  String branchCODE;
  String branchNAME;
  String branchSIGN;
  int finalCODE;
  int typeACCOUNTCODE;
  String typeACCOUNTNAME;
  String clientPHONESMS;
  String clientFULLPHONE;
  String clientREGION;
  String mandoobNAME;
  String clientTYPE;
  String cTYPENAME;
  String clientPHONE;
  String mandoobCODE;
  int securetyCODE;

  VAcount(
      {this.id,
        this.accontp,
        this.balance,
        this.accountNAME,
        this.accountFULLNAME,
        this.accountLEVEL,
        this.balanceIQ,
        this.balanceCUR,
        this.branchCODE,
        this.branchNAME,
        this.branchSIGN,
        this.finalCODE,
        this.typeACCOUNTCODE,
        this.typeACCOUNTNAME,
        this.clientPHONESMS,
        this.clientFULLPHONE,
        this.clientREGION,
        this.mandoobNAME,
        this.clientTYPE,
        this.cTYPENAME,
        this.clientPHONE,
        this.mandoobCODE,
        this.securetyCODE});

  VAcount.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    accontp = json['accontp'];
    balance = json['balance'];
    accountNAME = json['account_NAME'];
    accountFULLNAME = json['account_FULL_NAME'];
    accountLEVEL = json['account_LEVEL'];
    balanceIQ = json['balance_IQ'];
    balanceCUR = json['balance_CUR'];
    branchCODE = json['branch_CODE'];
    branchNAME = json['branch_NAME'];
    branchSIGN = json['branch_SIGN'];
    finalCODE = json['final_CODE'];
    typeACCOUNTCODE = json['type_ACCOUNT_CODE'];
    typeACCOUNTNAME = json['type_ACCOUNT_NAME'];
    clientPHONESMS = json['client_PHONE_SMS'];
    clientFULLPHONE = json['client_FULL_PHONE'];
    clientREGION = json['client_REGION'];
    mandoobNAME = json['mandoob_NAME'];
    clientTYPE = json['client_TYPE'];
    cTYPENAME = json['c_TYPE_NAME'];
    clientPHONE = json['client_PHONE'];
    mandoobCODE = json['mandoob_CODE'];
    securetyCODE = json['securety_CODE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['accontp'] = this.accontp;
    data['balance'] = this.balance;
    data['account_NAME'] = this.accountNAME;
    data['account_FULL_NAME'] = this.accountFULLNAME;
    data['account_LEVEL'] = this.accountLEVEL;
    data['balance_IQ'] = this.balanceIQ;
    data['balance_CUR'] = this.balanceCUR;
    data['branch_CODE'] = this.branchCODE;
    data['branch_NAME'] = this.branchNAME;
    data['branch_SIGN'] = this.branchSIGN;
    data['final_CODE'] = this.finalCODE;
    data['type_ACCOUNT_CODE'] = this.typeACCOUNTCODE;
    data['type_ACCOUNT_NAME'] = this.typeACCOUNTNAME;
    data['client_PHONE_SMS'] = this.clientPHONESMS;
    data['client_FULL_PHONE'] = this.clientFULLPHONE;
    data['client_REGION'] = this.clientREGION;
    data['mandoob_NAME'] = this.mandoobNAME;
    data['client_TYPE'] = this.clientTYPE;
    data['c_TYPE_NAME'] = this.cTYPENAME;
    data['client_PHONE'] = this.clientPHONE;
    data['mandoob_CODE'] = this.mandoobCODE;
    data['securety_CODE'] = this.securetyCODE;
    return data;
  }
}


