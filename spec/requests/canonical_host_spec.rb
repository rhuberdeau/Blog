# In production BLOG_HOSTS lists every name kamal-proxy serves; the first is
# canonical and the others redirect to it, path and query intact.
describe "Canonical host", type: :request do
  before { allow(Rails.configuration.x).to receive(:canonical_host).and_return("roberthuberdeau.com") }

  it "redirects other names to the canonical one, keeping the path" do
    host! "www.rhuberdeau.com"
    get "/about?ref=old"
    expect(response).to have_http_status(:moved_permanently)
    expect(response.location).to eq("http://roberthuberdeau.com/about?ref=old")
  end

  it "serves the canonical name" do
    host! "roberthuberdeau.com"
    get about_path
    expect(response).to have_http_status(:ok)
  end

  it "leaves the health check alone" do
    host! "10.0.0.5"
    get rails_health_check_path
    expect(response).to have_http_status(:ok)
  end
end
