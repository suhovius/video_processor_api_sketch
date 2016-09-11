resource "Create video processing task" do
  description "Upload video with time trimming parameters. User can use the mobile app to upload video and define timing parameters. After that, the request must be processed in the background."
  action "create"
  path "/api/v1/video_processing_tasks.json"
  http_method "POST"
  format "json"

  use_shared_block "authorization header"

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
            example {  "Trim end can't be blank, Trim end is not a number, Source video can't be blank" }
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

    use_shared_block "unauthorized user"
  end

  sample_call 'curl -v -H "Authorization: Token token=YwXdQ64vI5oam8ukfUx4SAtt" --form video_processing_task[trim_start]=3 --form video_processing_task[trim_end]=12 --form video_processing_task[source_video]=@spec/fixtures/videos/test_video.mov http://video_processor.dev/api/v1/video_processing_tasks.json'

  sample_response '{
   "id":"57d52ca107ae1d24852e6afe",
   "trim_start":3,
   "trim_end":12,
   "state":"scheduled",
   "last_error":null,
   "source_video":{
      "url":"http://video_processor.dev/system/video_processing_tasks/source_videos/57d5/2ca1/07ae/1d24/852e/6afe/original/test_video.mov?1473588385",
      "duration":15
   },
   "result_video":{
      "url":null,
      "duration":null
   },
   "started_at":null,
   "completed_at":null,
   "failed_at":null,
   "created_at":1473588385,
   "updated_at":1473588385
}'
end

resource "Get video processing tasks list" do
  description "Returns video processing tasks list array ordered by created at in descending order. User can see the list of the requests with their statuses (done, failed, scheduled, processing)."
  action "index"
  path "/api/v1/video_processing_tasks.json"
  http_method "GET"
  format "json"

  use_shared_block "authorization header"

  parameters do
    query :document do
      integer "page" do
        description "Pagination page"
        default 1
      end

      integer "per_page" do
        description "Pagination place per page"
        default 25
      end
    end
  end

  responses do
    context "Success" do
      http_status :ok # 200

      parameters do
        body :array do
          document do
            content do
              use_shared_block "video processing task fields"
            end
          end
        end
      end
    end

    use_shared_block "unauthorized user"
  end

  sample_call 'curl -v -H "Authorization: Token token=YwXdQ64vI5oam8ukfUx4SAtt" -H "Accept: application/json" -H "Content-type: application/json" -X GET -d \'{ "page" : 1, "per_page" : 50 }\' http://video_processor.dev/api/v1/video_processing_tasks.json'
  sample_response '[
   {
      "id":"57d52c6d07ae1d2472bcdcdb",
      "trim_start":3,
      "trim_end":10,
      "state":"scheduled",
      "last_error":null,
      "source_video":{
         "url":"http://video_processor.dev/system/video_processing_tasks/source_videos/57d5/2c6d/07ae/1d24/72bc/dcdb/original/test_video.mov?1473588333",
         "duration":17
      },
      "result_video":{
         "url":null,
         "duration":null
      },
      "started_at":null,
      "completed_at":null,
      "failed_at":null,
      "created_at":1473588333,
      "updated_at":1473588333
   },
   {
      "id":"57d52c6d07ae1d2472bcdcdc",
      "trim_start":3,
      "trim_end":10,
      "state":"done",
      "last_error":null,
      "source_video":{
         "url":"http://video_processor.dev/system/video_processing_tasks/source_videos/57d5/2c6d/07ae/1d24/72bc/dcdc/original/test_video.mov?1473584733",
         "duration":17
      },
      "result_video":{
         "url":"http://video_processor.dev/system/video_processing_tasks/result_videos/57d5/2c6d/07ae/1d24/72bc/dcdc/original/test_video.mov?1473584733",
         "duration":7
      },
      "started_at":1473584433,
      "completed_at":1473584733,
      "failed_at":null,
      "created_at":1473584733,
      "updated_at":1473584733
   },
   {
      "id":"57d52c6d07ae1d2472bcdcdd",
      "trim_start":3,
      "trim_end":10,
      "state":"failed",
      "last_error":"Some error message 95",
      "source_video":{
         "url":"http://video_processor.dev/system/video_processing_tasks/source_videos/57d5/2c6d/07ae/1d24/72bc/dcdd/original/test_video.mov?1473581133",
         "duration":15
      },
      "result_video":{
         "url":null,
         "duration":null
      },
      "started_at":1473580833,
      "completed_at":null,
      "failed_at":1473581133,
      "created_at":1473581133,
      "updated_at":1473581133
   }
]'
end

