import 'package:app_push_notifications/Helpers/importFiles.dart';
class AppData {
  List<Questions> listOfQuestions;
  List<ChildrenPreferences> listOfChildrenPreferences;
  List<Faith> listOfFaiths;
  List<Ethnicity> listOfEthnicity;
  List<VacationTypes> listOfVocationsType;
  List<Hobbies> listOfHobbies;
  List<Professions> listOfProfessions;
  List<CategoryModel> listOfCategories;
  AppData(
      {this.listOfQuestions,
        this.listOfChildrenPreferences,
        this.listOfFaiths,
        this.listOfEthnicity,
        this.listOfVocationsType,
        this.listOfHobbies,
        this.listOfProfessions,
        this.listOfCategories});

  AppData.fromJson(Map<String, dynamic> json) {
    if (json['questions'] != null) {
      listOfQuestions = new List<Questions>();
      json['questions'].forEach((v) {
        listOfQuestions.add(new Questions.fromJson(v));
      });
    }
    if (json['children_preferences'] != null) {
      listOfChildrenPreferences = new List<ChildrenPreferences>();
      json['children_preferences'].forEach((v) {
        listOfChildrenPreferences.add(new ChildrenPreferences.fromJson(v));
      });
    }
    if (json['faith'] != null) {
      listOfFaiths = new List<Faith>();
      json['faith'].forEach((v) {
        listOfFaiths.add(new Faith.fromJson(v));
      });
    }
    if (json['ethnicity'] != null) {
      listOfEthnicity = new List<Ethnicity>();
      json['ethnicity'].forEach((v) {
        listOfEthnicity.add(new Ethnicity.fromJson(v));
      });
    }
    if (json['vacation_types'] != null) {
      listOfVocationsType = new List<VacationTypes>();
      json['vacation_types'].forEach((v) {
        listOfVocationsType.add(new VacationTypes.fromJson(v));
      });
    }
    if (json['hobbies'] != null) {
      listOfHobbies = new List<Hobbies>();
      json['hobbies'].forEach((v) {
        listOfHobbies.add(new Hobbies.fromJson(v));
      });
    }
    if (json['professions'] != null) {
      listOfProfessions = new List<Professions>();
      json['professions'].forEach((v) {
        listOfProfessions.add(new Professions.fromJson(v));
      });
    }
    if (json['categories'] != null) {
      listOfCategories = new List<CategoryModel>();
      json['categories'].forEach((v) {
        listOfCategories.add(new CategoryModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.listOfQuestions != null) {
      data['questions'] = this.listOfQuestions.map((v) => v.toJson()).toList();
    }
    if (this.listOfChildrenPreferences != null) {
      data['children_preferences'] =
          this.listOfChildrenPreferences.map((v) => v.toJson()).toList();
    }
    if (this.listOfFaiths != null) {
      data['faith'] = this.listOfFaiths.map((v) => v.toJson()).toList();
    }
    if (this.listOfEthnicity != null) {
      data['ethnicity'] = this.listOfEthnicity.map((v) => v.toJson()).toList();
    }
    if (this.listOfVocationsType != null) {
      data['vacation_types'] =
          this.listOfVocationsType.map((v) => v.toJson()).toList();
    }
    if (this.listOfHobbies != null) {
      data['hobbies'] = this.listOfHobbies.map((v) => v.toJson()).toList();
    }
    if (this.listOfProfessions != null) {
      data['professions'] = this.listOfProfessions.map((v) => v.toJson()).toList();
    }
    if (this.listOfCategories != null) {
      data['categories'] = this.listOfCategories.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Questions {
  int qaId;
  String qaQuestion;
  String qaSlug;
  String qaName;
  int qaQuestionType;
  Null qaCate;
  String qaFieldType;
  String qaOptions;
  String qaPlaceholder;
  int qaSkipable;
  int qaStatus;
  Null createdAt;
  Null updatedAt;
  bool isSelected;

  Questions(
      {this.qaId,
        this.qaQuestion,
        this.qaSlug,
        this.qaName,
        this.qaQuestionType,
        this.qaCate,
        this.qaFieldType,
        this.qaOptions,
        this.qaPlaceholder,
        this.qaSkipable,
        this.qaStatus,
        this.createdAt,
        this.updatedAt,
        this.isSelected = false});

  Questions.fromJson(Map<String, dynamic> json) {
    qaId = json['qa_id'];
    qaQuestion = json['qa_question'];
    qaSlug = json['qa_slug'];
    qaName = json['qa_name'];
    qaQuestionType = json['qa_question_type'];
    qaCate = json['qa_cate'];
    qaFieldType = json['qa_field_type'];
    qaOptions = json['qa_options'];
    qaPlaceholder = json['qa_placeholder'];
    qaSkipable = json['qa_skipable'];
    qaStatus = json['qa_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isSelected = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['qa_id'] = this.qaId;
    data['qa_question'] = this.qaQuestion;
    data['qa_slug'] = this.qaSlug;
    data['qa_name'] = this.qaName;
    data['qa_question_type'] = this.qaQuestionType;
    data['qa_cate'] = this.qaCate;
    data['qa_field_type'] = this.qaFieldType;
    data['qa_options'] = this.qaOptions;
    data['qa_placeholder'] = this.qaPlaceholder;
    data['qa_skipable'] = this.qaSkipable;
    data['qa_status'] = this.qaStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class ChildrenPreferences {
  int cpId;
  String cpText;
  int cpStatus;
  Null createdAt;
  Null updatedAt;

  ChildrenPreferences(
      {this.cpId, this.cpText, this.cpStatus, this.createdAt, this.updatedAt});

  ChildrenPreferences.fromJson(Map<String, dynamic> json) {
    cpId = json['cp_id'];
    cpText = json['cp_text'];
    cpStatus = json['cp_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cp_id'] = this.cpId;
    data['cp_text'] = this.cpText;
    data['cp_status'] = this.cpStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Faith {
  int fId;
  String fName;
  int fStatus;
  Null createdAt;
  Null updatedAt;

  Faith({this.fId, this.fName, this.fStatus, this.createdAt, this.updatedAt});

  Faith.fromJson(Map<String, dynamic> json) {
    fId = json['f_id'];
    fName = json['f_name'];
    fStatus = json['f_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['f_id'] = this.fId;
    data['f_name'] = this.fName;
    data['f_status'] = this.fStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Ethnicity {
  int eId;
  String eName;
  int eStatus;
  Null createdAt;
  Null updatedAt;

  Ethnicity(
      {this.eId, this.eName, this.eStatus, this.createdAt, this.updatedAt});

  Ethnicity.fromJson(Map<String, dynamic> json) {
    eId = json['e_id'];
    eName = json['e_name'];
    eStatus = json['e_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['e_id'] = this.eId;
    data['e_name'] = this.eName;
    data['e_status'] = this.eStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class VacationTypes {
  int vtId;
  String vtName;
  int vtStatus;
  Null createdAt;
  Null updatedAt;

  VacationTypes(
      {this.vtId, this.vtName, this.vtStatus, this.createdAt, this.updatedAt});

  VacationTypes.fromJson(Map<String, dynamic> json) {
    vtId = json['vt_id'];
    vtName = json['vt_name'];
    vtStatus = json['vt_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vt_id'] = this.vtId;
    data['vt_name'] = this.vtName;
    data['vt_status'] = this.vtStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Hobbies {
  int hbId;
  String hbName;
  int hbType;
  int hbStatus;
  Null createdAt;
  Null updatedAt;

  Hobbies(
      {this.hbId,
        this.hbName,
        this.hbType,
        this.hbStatus,
        this.createdAt,
        this.updatedAt});

  Hobbies.fromJson(Map<String, dynamic> json) {
    hbId = json['hb_id'];
    hbName = json['hb_name'];
    hbType = json['hb_type'];
    hbStatus = json['hb_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hb_id'] = this.hbId;
    data['hb_name'] = this.hbName;
    data['hb_type'] = this.hbType;
    data['hb_status'] = this.hbStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Professions {
  int proId;
  String proName;
  int proStatus;
  Null createdAt;
  Null updatedAt;

  Professions(
      {this.proId,
        this.proName,
        this.proStatus,
        this.createdAt,
        this.updatedAt});

  Professions.fromJson(Map<String, dynamic> json) {
    proId = json['pro_id'];
    proName = json['pro_name'];
    proStatus = json['pro_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pro_id'] = this.proId;
    data['pro_name'] = this.proName;
    data['pro_status'] = this.proStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}