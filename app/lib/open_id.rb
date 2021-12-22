module Lib
    class OpenId
        def initialize(provider_uri, client_id, redirect_uri)
            @provider_uri = provider_uri
            @client_id = client_id
            @redirect_uri = redirect_uri
        end
        
        def auth_uri(nonce)
            authz_url = init_client.authorization_uri(
                scope: [:profile, :email],
                state: nonce,
                nonce: nonce
            )
        end
       
        def redirect(code, nonce)
            client = init_client

            expected = {:client_id => @client_id, :issuer => discover.issuer, :nonce => nonce}

            client.authorization_code = code
            options = {client_id: @client_id, client_secret: ENV['SLACK_CLIENT_SECRET'], redirect_uri: @redirect_uri}
            access_token = client.access_token!(options)

            id_token = OpenIDConnect::ResponseObject::IdToken.decode access_token.id_token, discover.jwks
            id_token.verify! expected

            access_token.userinfo!
        end
 
        private
        
        def init_client        
            @client ||= OpenIDConnect::Client.new(
                identifier: @client_id,
                redirect_uri: @redirect_uri,
                authorization_endpoint: discover.authorization_endpoint,
                token_endpoint: discover.token_endpoint,
                userinfo_endpoint: discover.userinfo_endpoint
            )
        end
 
        def discover
            @disco ||= OpenIDConnect::Discovery::Provider::Config.discover! @provider_uri
        end
    end
end