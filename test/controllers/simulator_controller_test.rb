# frozen_string_literal: true

require "test_helper"

class SimulatorControllerTest < ActionDispatch::IntegrationTest
  test "GET simulator shows the simulator" do
    get simulator_path
    assert_response :success
    assert_select "h1", text: /ZUMEX VERSATILE BASIC/
  end

  test "POST power_toggle turns on" do
    post simulator_power_path
    assert_redirected_to simulator_path
    follow_redirect!
    assert_response :success
  end

  test "POST reset clears session" do
    post simulator_load_path, params: { count: 5 }
    post simulator_reset_path
    assert_redirected_to simulator_path
  end
end
