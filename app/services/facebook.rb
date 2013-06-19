class Facebook

  def initialize(user)
    @user = user
    @graph ||= Koala::Facebook::API.new(user.oauth_token)
  end

  def friendships
    fql = %q{
      SELECT uid, name, username, pic_square
      FROM  user
      WHERE uid IN (SELECT uid2 FROM friend WHERE uid1 = me() )
      ORDER BY name LIMIT 150
    }
    @friendships ||= @graph.fql_query(fql)
  end

  def recipients(invites)
    invites.map{ |uid, username| "#{username.present? ? username : uid}@facebook.com" }
  end

  def send_invites(invites)
    recip = recipients(invites)
    FacebookMailer.invite_friends( @user, recip ).deliver
  end

end
