class User
  module Facebook
    def facebook
      @facebook ||= Koala::Facebook::API.new(oauth_token)
    end

    def friendships
      fql = "SELECT uid, name, username, pic_square FROM user WHERE uid IN (SELECT uid2 FROM friend WHERE uid1 = me() limit 50)"
      @friendships ||= facebook.fql_query(fql)
   end
 end
end
