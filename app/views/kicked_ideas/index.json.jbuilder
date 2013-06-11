json.array!(@kicked_ideas) do |kicked_idea|
  json.extract! kicked_idea, :user_id
  json.url kicked_idea_url(kicked_idea, format: :json)
end