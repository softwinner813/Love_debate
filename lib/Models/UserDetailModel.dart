class UserDetail {
  int id;
  String socialLoginId;
  String socialLoginType;
  String firstName;
  String lastName;
  String email;
  String password;
  String dob;
  String height;
  String profilePic;
  String gender;
  String address;
  String state;
  String city;
  String lat;
  String lng;
  String faith;
  String ethnicity;
  String status;
  String emailVerifiedAt;
  String rememberToken;
  String createdAt;
  String updatedAt;
  String prId;
  String prUserId;
  String prHeight;
  String prSerious;
  String prMatchArea;
  String prAvgIncomeStart;
  String prAverageIncome;
  String prAvgIncomeEnd;
  String prProfession;
  String prGoals;
  String prExpectations;
  String prCharacteristic;
  String prIe;
  String prSingle;
  String prSingleDislikes;
  String prKids;
  String prLocation;
  String prFaithDislikes;
  String prReligious;
  String prEthnicityDislikes;
  String prOtherDislikes;
  String prTownLikes;
  String prTownDislikes;
  String prVacations;
  String prCurse;
  String prHobbiesOutdoor;
  String prHobbiesOutdoorDislikes;
  String prHobbiesIndoor;
  String prHobbiesIndoorDislikes;

  String kidsStr;
  String faithStr;
  String ethnicityStr;
  String professionsStr;
  String faithDislikeStr;
  String ethnicityDislikeStr;
  String roundNo;
  int cateId;
  int cId;
  String socId;
  int prCompletionStatus;
  String cName;

  UserDetail(
      {this.id,
        this.socialLoginId,
        this.socialLoginType,
        this.firstName,
        this.lastName,
        this.email,
        this.password,
        this.dob,
        this.height,
        this.profilePic,
        this.gender,
        this.address,
        this.state,
        this.city,
        this.lat,
        this.lng,
        this.faith,
        this.ethnicity,
        this.status,
        this.emailVerifiedAt,
        this.rememberToken,
        this.createdAt,
        this.updatedAt,
        this.prId,
        this.prUserId,
        this.prHeight,
        this.prSerious,
        this.prMatchArea,
        this.prAvgIncomeStart,
        this.prAverageIncome,
        this.prAvgIncomeEnd,
        this.prProfession,
        this.prGoals,
        this.prExpectations,
        this.prCharacteristic,
        this.prIe,
        this.prSingle,
        this.prSingleDislikes,
        this.prKids,
        this.prLocation,
        this.prFaithDislikes,
        this.prReligious,
        this.prEthnicityDislikes,
        this.prOtherDislikes,
        this.prTownLikes,
        this.prTownDislikes,
        this.prVacations,
        this.prCurse,
        this.prHobbiesOutdoor,
        this.prHobbiesOutdoorDislikes,
        this.prHobbiesIndoor,
        this.prHobbiesIndoorDislikes,
        this.kidsStr,
        this.faithStr,
        this.ethnicityStr,
        this.professionsStr,
        this.faithDislikeStr,
        this.ethnicityDislikeStr,
        this.roundNo,
        this.cateId, this.cId, this.socId, this.prCompletionStatus, this.cName
      });

  UserDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? null;
    socialLoginId = json['social_login_id'];
    socialLoginType = json['social_login_type'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    password = json['password'];
    dob = json['dob'];
    profilePic = json["profile_pic"];
    height = json['height'].toString();
    gender = json['gender'].toString();
    address = json['address'];
    state = json['state'];
    city = json['city'];
    lat = json['lat'];
    lng = json['lng'];
    faith = json['faith'];
    ethnicity = json['ethnicity'].toString();
    status = json['status'].toString();
    emailVerifiedAt = json['email_verified_at'];
    rememberToken = json['remember_token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    prId = json['pr_id'].toString();
    prUserId = json['pr_user_id'].toString();
    prHeight = json['pr_height'];
    prSerious = json['pr_serious'];
    prMatchArea = json['pr_match_area'];
    prAvgIncomeStart = json['pr_avg_income_start'];
    prAverageIncome = json['pr_average_income'];
    prAvgIncomeEnd = json['pr_avg_income_end'];
    prProfession = json['pr_profession'];
    prGoals = json['pr_goals'];
    prExpectations = json['pr_expectations'];
    prCharacteristic = json['pr_characteristic'];
    prIe = json['pr_ie'];
    prSingle = json['pr_single'];
    prSingleDislikes = json['pr_single_dislikes'];
    prKids = json['pr_kids'];
    prLocation = json['pr_location'];
    prFaithDislikes = json['pr_faith_dislikes'];
    prReligious = json['pr_religious'];
    prEthnicityDislikes = json['pr_ethnicity_dislikes'];
    prOtherDislikes = json['pr_other_dislikes'];
    prTownLikes = json['pr_town_likes'];
    prTownDislikes = json['pr_town_dislikes'];
    prVacations = json['pr_vacations'];
    prCurse = json['pr_curse'];
    prHobbiesOutdoor = json['pr_hobbies_outdoor'];
    prHobbiesOutdoorDislikes = json['pr_hobbies_outdoor_dislikes'];
    prHobbiesIndoor = json['pr_hobbies_indoor'];
    prHobbiesIndoorDislikes = json['pr_hobbies_indoor_dislikes'];
    kidsStr = json['kids_str'];
    faithStr = json['faith_str'];
    ethnicityStr = json['ethnicity_str'];
    professionsStr = json['professions_str'];
    faithDislikeStr = json['faith_dislike_str'];
    ethnicityDislikeStr = json['ethnicity_dislike_str'];
    roundNo = json['roundNo'];
    cateId = json['cate_id'];
    cId = json['c_id'];
    cName = json['c_name'];
    socId = json['soc_id'];
    prCompletionStatus = json['profile_completion_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['social_login_id'] = this.socialLoginId;
    data['social_login_type'] = this.socialLoginType;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['password'] = this.password;
    data['dob'] = this.dob;
    data["profile_pic"] = this.profilePic;
    data['height'] = this.height;
    data['gender'] = this.gender;
    data['address'] = this.address;
    data['state'] = this.state;
    data['city'] = this.city;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['faith'] = this.faith;
    data['ethnicity'] = this.ethnicity;
    data['status'] = this.status;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['remember_token'] = this.rememberToken;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['pr_id'] = this.prId;
    data['pr_user_id'] = this.prUserId;
    data['pr_height'] = this.prHeight;
    data['pr_serious'] = this.prSerious;
    data['pr_match_area'] = this.prMatchArea;
    data['pr_avg_income_start'] = this.prAvgIncomeStart;
    data['pr_average_income'] = this.prAverageIncome;
    data['pr_avg_income_end'] = this.prAvgIncomeEnd;
    data['pr_profession'] = this.prProfession;
    data['pr_goals'] = this.prGoals;
    data['pr_expectations'] = this.prExpectations;
    data['pr_characteristic'] = this.prCharacteristic;
    data['pr_ie'] = this.prIe;
    data['pr_single'] = this.prSingle;
    data['pr_single_dislikes'] = this.prSingleDislikes;
    data['pr_kids'] = this.prKids;
    data['pr_location'] = this.prLocation;
    data['pr_faith_dislikes'] = this.prFaithDislikes;
    data['pr_religious'] = this.prReligious;
    data['pr_ethnicity_dislikes'] = this.prEthnicityDislikes;
    data['pr_other_dislikes'] = this.prOtherDislikes;
    data['pr_town_likes'] = this.prTownLikes;
    data['pr_town_dislikes'] = this.prTownDislikes;
    data['pr_vacations'] = this.prVacations;
    data['pr_curse'] = this.prCurse;
    data['pr_hobbies_outdoor'] = this.prHobbiesOutdoor;
    data['pr_hobbies_outdoor_dislikes'] = this.prHobbiesOutdoorDislikes;
    data['pr_hobbies_indoor'] = this.prHobbiesIndoor;
    data['pr_hobbies_indoor_dislikes'] = this.prHobbiesIndoorDislikes;
    data['kids_str'] = this.kidsStr;
    data['faith_str'] = this.faithStr;
    data['ethnicity_str'] = this.ethnicityStr;
    data['professions_str'] = this.professionsStr;
    data['faith_dislike_str'] = this.faithDislikeStr;
    data['ethnicity_dislike_str'] = this.ethnicityDislikeStr;
    data['roundNo'] = this.roundNo;
    data['cate_id'] = this.cateId;
    data['c_id'] = this.cId;
    data['c_name'] = this.cName;
    data['soc_id'] = this.socId;
    data['profile_completion_status'] = this.prCompletionStatus;
    return data;
  }
}