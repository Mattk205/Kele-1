require 'httparty'

module Roadmap
  include HTTParty
  base_uri 'https://www.bloc.io/api/v1'

  def get_roadmap(roadmap_id)
    response = self.class.get(api_url("roadmaps/#{roadmap_id}"), headers: {"authorization" => @auth_token})
    @roadmap = JSON.parse(response.body)
  end

  def get_checkpoint(checkpoint_id)
    response = self.class.get("/checkpoints/" + checkpoint_id.to_s, headers: {"authorization" => @auth_token})
    @checkpoint = JSON.parse(response/body)
  end

end
