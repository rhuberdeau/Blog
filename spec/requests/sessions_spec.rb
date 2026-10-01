describe "Signing in and out", type: :request do
  let!(:author) { create(:user, email_address: "author@example.com") }

  it "signs in with the right password and returns to the page that asked" do
    get admin_path
    sign_in_as(author)
    expect(response).to redirect_to(admin_url)

    get admin_path
    expect(response).to have_http_status(:ok)
  end

  it "accepts the address in any case" do
    post session_path, params: { email_address: " Author@Example.com ", password: "foobar123" }
    get admin_path
    expect(response).to have_http_status(:ok)
  end

  it "refuses a wrong password" do
    sign_in_as(author, password: "wrong")
    expect(response).to redirect_to(new_session_path)
    get admin_path
    expect(response).to redirect_to(new_session_path)
  end

  it "signs out" do
    sign_in_as(author)
    delete session_path
    expect(response).to redirect_to(new_session_path)
    get admin_path
    expect(response).to redirect_to(new_session_path)
  end

  it "rate-limits password guessing" do
    10.times { sign_in_as(author, password: "wrong") }
    sign_in_as(author)
    follow_redirect!
    expect(response.body).to include("Try again later.")
  end
end
