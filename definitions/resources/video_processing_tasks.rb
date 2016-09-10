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
          end

          integer "trim_end" do
            description "Video end trimming parameter in seconds"
            example { rand(10) + 15 }
          end

          string "source_video" do
            description "Video multipart data file"
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
  end

  sample_call 'curl -v -H "Authorization: Token token=YwXdQ64vI5oam8ukfUx4SAtt" --form video_processing_task[trim_start]=3 --form video_processing_task[trim_end]=12 --form video_processing_task[source_video]=@spec/fixtures/videos/test_video.mov http://video_processor.dev/api/v1/video_processing_tasks.json'
end
