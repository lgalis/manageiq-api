describe 'Middleware Domains API' do
  let(:domain) { FactoryGirl.create :middleware_domain }

  describe '/' do
    it 'forbids access without an appropriate role' do
      api_basic_authorize

      get api_middleware_domains_url

      expect(response).to have_http_status(:forbidden)
    end

    it 'returns an empty listing of domains' do
      api_basic_authorize collection_action_identifier(:middleware_domains, :read, :get)

      get api_middleware_domains_url

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body).to include(
        'name'      => 'middleware_domains',
        'count'     => 0,
        'resources' => [],
        'subcount'  => 0
      )
    end

    it 'returns a listing of domains' do
      domain

      api_basic_authorize collection_action_identifier(:middleware_domains, :read, :get)

      get api_middleware_domains_url

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body).to include(
        'name'      => 'middleware_domains',
        'count'     => 1,
        'resources' => [{
          'href' => api_middleware_domain_url(nil, domain)
        }],
        'subcount'  => 1
      )
    end
  end

  describe '/:id' do
    it 'forbids access to a domain without an appropriate role' do
      api_basic_authorize

      get api_middleware_domain_url(nil, domain)

      expect(response).to have_http_status(:forbidden)
    end

    it 'returns the attributes of one domain' do
      api_basic_authorize action_identifier(:middleware_domains, :read, :resource_actions, :get)

      get api_middleware_domain_url(nil, domain)

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body).to include(
        'id'   => domain.id.to_s,
        'href' => api_middleware_domain_url(nil, domain),
        'name' => domain.name
      )
    end
  end
end
