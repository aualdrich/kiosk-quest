module RequestHelpers
  def response_json
    JSON.parse(response.body)
  end

  def response_errors
    response_json.fetch("errors")
  end
end

RSpec.configure do |config|
  config.include RequestHelpers, type: :request
end
