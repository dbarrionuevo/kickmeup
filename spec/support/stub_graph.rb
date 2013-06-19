def stub_graph(opts={})
  koala = Koala::Facebook::API
  koala.stub(:new).with(current_user.oauth_token).and_return(Koala::Facebook::API)
  koala.stub(:put_wall_post).and_return('101010')
  koala.stub(:fql_query).and_return(friends) if opts[:with_friends]
  koala.stub(:put_wall_post).and_return('10203010')
end
