def stub_graph
  koala = Koala::Facebook::API
  koala.stub(:new).with(current_user.oauth_token).and_return(Koala::Facebook::API)
  koala.stub(:fql_query).and_return(friends)
end
