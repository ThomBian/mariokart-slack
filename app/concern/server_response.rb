module Concern
    module ServerResponse
        def response_ok_basic
            [200, ['']]
        end

        def response_ok_with_body(body)
            [200, {'Content-Type' => 'application/json'}, body.to_json]
        end
    end
end