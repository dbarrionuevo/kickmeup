class User
  module Facebook

    def facebook
      @facebook ||= Koala::Facebook::API.new(oauth_token)
    end

    def friendships
      fql = %q{
        SELECT uid, name, username, pic_square
          FROM  user
          WHERE uid IN (SELECT uid2 FROM friend WHERE uid1 = me() )
          ORDER BY name LIMIT 150
      }
      @friendships ||= facebook.fql_query(fql)
   end

   def recipients(invites)
      invites.map{ |uid, username| "#{username.present? ? username : uid}@facebook.com" }
   end

 end
end
