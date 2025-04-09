# frozen_string_literal: true

require_relative 'test_helper'
require_relative '../lib/stack'

class StackTest < Minitest::Test
  # BEGIN
  def test_push_element
    stack = Stack.new
    stack.push!("ruby")

    assert { stack.to_a == ["ruby"] }
    assert { stack.size == 1 }
    assert { !stack.empty?}
  end

  def test_pop_element
    stack = Stack.new(["ruby", "php"])
    element = stack.pop!

    assert { element == "php" }
    assert { stack.to_a == ["ruby"] }
    assert { stack.size == 1 }
  end

  def test_clear_stack
    stack = Stack.new(["ruby", "php"])
    stack.clear!

    assert { stack.to_a == [] }
    assert { stack.size == 0 }
    assert { stack.empty? }
  end

  def test_empty_check
    stack = Stack.new
    assert { stack.empty? }

    stack.push!("ruby")
    assert { !stack.empty? }

    stack.pop!
    assert { stack.empty? }
  end
  # END
end

test_methods = StackTest.new({}).methods.select { |method| method.start_with? 'test_' }
raise 'StackTest has not tests!' if test_methods.empty?
