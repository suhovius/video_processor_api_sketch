resource "Request new user token" do
  action "create"
  description "Register new user and obtain api_token. When a new user starts using a mobile app, the app sends a request to the server for a unique key which is used to subscribe user requests to identify user."
  path "/api/v1/users.json"
  http_method "POST"
  format "json"

  responses do
    context "Success" do
      http_status :created # 201

      parameters do
        body :document do
          string :api_token do
            description "Auth token"
            example { (:A..:z).to_a.shuffle[0,16].join }
          end
        end
      end
    end
  end

  sample_call 'curl -v -H "Accept: application/json" -H "Content-type: application/json" -X POST http://video_processor.dev/api/v1/users.json'
end
