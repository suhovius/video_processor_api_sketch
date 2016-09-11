resource "Create video processing task" do
  description "Upload video with time trimming parameters. User can use the mobile app to upload video and define timing parameters. After that, the request must be processed in the background.
"
  action "create"
  path "/api/v1/video_processing_tasks.json"
  http_method "POST"
  format "json"

  headers do
    add "Authorization" do
      value "Token token=:token_value"
      description ":token_value - is an authorization token value (api_token)"
      example { (:A..:z).to_a.shuffle[0,16].join }
      required true
    end
  end

  parameters do
    body :document do
      document "video_processing_task" do
        description "Video processing task params"
        content do
          integer "trim_start" do
            description "Video start trimming parameter in seconds"
            example { rand(10) + 1 }
            required true
          end

          integer "trim_end" do
            description "Video end trimming parameter in seconds"
            example { rand(10) + 15 }
            required true
          end

          file "source_video" do
            description "Video multipart data file"
            required true
          end
        end
      end
    end
  end

  responses do
    context "Success" do
      http_status :created # 201

      parameters do
        body :document do
          use_shared_block "video processing task fields"
        end
      end
    end

    context "Invalid parameters" do
      http_status :unprocessable_entity # 422

      parameters do
        body :document do
          string "error" do
            description "Human readable error message"
            example {  "Trim end can't be blank" }
          end
          document "details" do
            description "error details, can be used for highlighting invalid fields at native app UI"
            content do
              array "trim_end" do
                description "errors array on specific field"
                example { ["can't be blank", "is not a number"] }
              end

              array "source_video" do
                description "errors array on specific field"
                example { ["can't be blank"] }
              end
            end
          end
        end
      end
    end
  end

  sample_call 'curl -v -H "Authorization: Token token=YwXdQ64vI5oam8ukfUx4SAtt" --form video_processing_task[trim_start]=3 --form video_processing_task[trim_end]=12 --form video_processing_task[source_video]=@spec/fixtures/videos/test_video.mov http://video_processor.dev/api/v1/video_processing_tasks.json'
end