# frozen_string_literal: true

class ExecutionTimer
    def initialize(app)
      @app = app
    end
  
    def call(env)
      start_time = Time.now
      status, headers, body = @app.call(env)
      end_time = Time.now
  
      execution_time = ((end_time - start_time) * 1_000_000).to_i
      headers['X-Execution-Time'] = "#{execution_time}μs"
  
      [status, headers, body]
    end
  end