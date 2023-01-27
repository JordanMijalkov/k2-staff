

class User {
  User();

  String? id;
  String? name;
  String? screenName;
  String? location;
  DateTime? createdAt;


  User.mock(
    {this.id = '1235',
    this.name = 'mock',
    this.screenName = 'mock user',
    this.location = 'buffalo, ny',
    // this.verified = true,
    // this.followersCount = 234,
    // this.friendsCount = 18,
    createdAt,
    }
  ) : createdAt = createdAt ?? DateTime.now();  
}