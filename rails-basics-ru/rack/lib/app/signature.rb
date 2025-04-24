# frozen_string_literal: true

require 'digest'

class Signature
  def initialize(app)
    @app = app
  end

  def call(env)
    # BEGIN
    status, headers, body = @app.call(env)

    if status == 200
      body_content = body.join
      signature = Digest::SHA256.hexdigest(body_content)
      body = [body_content, "\n", signature]
    end

    [status, headers, body]
    # END
  end
end
