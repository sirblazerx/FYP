class Donation {
  final String did;

  Donation({this.did});
}

class DonationData {
  final String title;
  final int curfund;
  final String datecreate;
  final String fundneed;
  final String descri;
  final String img;
  final String name;
  final String paypalid;
  final String projectid;
  final String ufacebook;
  final String userid;
  final String uyoutube;
  final String acctype;
  final String tsecret;
  final String psecret;
  final String tcatecode;
  final String country;
  final String token;

  DonationData(
      {this.country,
      this.token,
      this.tcatecode,
      this.tsecret,
      this.psecret,
      this.acctype,
      this.title,
      this.curfund,
      this.datecreate,
      this.fundneed,
      this.descri,
      this.img,
      this.name,
      this.paypalid,
      this.projectid,
      this.ufacebook,
      this.userid,
      this.uyoutube});
}
