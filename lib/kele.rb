require 'httparty'
require 'json'
#require 'roadmap'
require './lib/roadmap.rb'

class Kele
  include HTTParty
  include Roadmap
  base_uri "https://www.bloc.io/api/v1/"


  def initialize(email, password)
    response = self.class.post(api_url("sessions"), body: {"email": email, "password": password})
    raise "Invalid email or password" if response.code == 404
    @auth_token = response["auth_token"]
  end

  def get_me
    response = self.class.get(api_url('users/me'), headers: {"authorization" => @auth_token})
    @user_data = JSON.parse(response.body)
  end

  def get_mentor_availability(mentor_id)
    response = self.class.get(api_url("mentors/#{mentor_id}/student_availability"), headers: {"authorization" => @auth_token})
    @mentor_availability = JSON.parse(response.body)
  end

  def get_messages(page = nil)
    if page.nil?
      response = self.class.get(api_url('/message_threads'), headers: { "authorization" => @auth_token})
    else
      response = self.class.get(api_url('/message_threads?#{page}'), headers: { "authorization" => @auth_token})
    end
    @messages = JSON.parse(response.body)
  end

  def create_message(sender_email, recipient_id, token = nil, subject, message)
    response = self.class.post("/messages",
                                body: {
                                        "sender_email": sender_email,
                                        "recipient_id": recipient_id,
                                        "token": token,
                                        "subject": subject,
                                        "stripped_text": message
                                      },
                                headers: { "authorization" => @auth_token}
                                )
    response.success? puts "Message sent, Thanks!"
  end

  def create_submission(assignment_branch, assignment_commit_link, checkpoint_id, comment, enrollment_id)
    response = self.class.post('/checkpoint_submission',
                                body: {
                                        "assignment_branch": assignment_branch,
                                        "assignment_commit_link": assignment_commit_link,
                                        "checkpoint_id": checkpoint_id,
                                        "comment": comment,
                                        "enrollment_id": enrollment_id
                                      },
                                headers: {"authorization" => @auth_token}
                              )
    puts response
  end

  private

  def api_url(endpoint)
    "https://www.bloc.io/api/v1/#{endpoint}"
  end

end
