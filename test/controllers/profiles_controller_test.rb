require "test_helper"

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "show redirects to login when not signed in" do
    get profile_path
    assert_redirected_to new_session_path
  end

  test "show succeeds when signed in and only lists the current user's stations" do
    sign_in_as(@user)

    get profile_path

    assert_response :success
    assert_select "a", text: stations(:one).title
    assert_select "a", { text: stations(:two).title, count: 0 }
  end

  test "edit redirects to login when not signed in" do
    get edit_profile_path
    assert_redirected_to new_session_path
  end

  test "edit succeeds when signed in" do
    sign_in_as(@user)
    get edit_profile_path
    assert_response :success
  end

  test "update redirects to login when not signed in" do
    patch profile_path, params: { user: { name: "Yeni İsim" } }
    assert_redirected_to new_session_path
  end

  test "update changes the current user's name and email" do
    sign_in_as(@user)

    patch profile_path, params: { user: { name: "Yeni İsim", email_address: "new-email@example.com" } }

    assert_redirected_to profile_path
    @user.reload
    assert_equal "Yeni İsim", @user.name
    assert_equal "new-email@example.com", @user.email_address
  end
end
