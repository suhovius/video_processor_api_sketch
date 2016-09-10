require 'securerandom'
shared_block "video processing task fields" do
  string "id" do
    description "Video processing task database ID"
    example { ::SecureRandom.hex(24) }
  end

  integer "trim_start" do
    description "Video start trimming parameter in seconds"
    example { rand(10) + 1 }
  end

  integer "trim_end" do
    description "Video end trimming parameter in seconds"
    example { rand(10) + 15 }
  end

  document "source_video" do
    description "Source video file details"
    content do
      string "url" do
        description "source file url"
        example { "http://video_processor.dev/system/video_processing_tasks/source_videos/57d4/6ce8/07ae/1d3b/2b95/ad50/original/test_video.mov?1473539304" }
      end

      integer "duration" do
        description "source file duration"
        example { rand(100) + 15 }
      end
    end
  end

  document "result_video" do
    description "Result video file details"
    content do
      string "url" do
        description "result file url"
        example { "http://video_processor.dev/system/video_processing_tasks/result_videos/36d4/6ce8/07ae/1d3b/2b75/ad50/original/test_video.mov?1773499304" }
      end

      integer "duration" do
        description "result file duration"
        example { rand(100) + 1 }
      end
    end
  end

  timestamp "started_at" do
    description "Task started at unix timestamp"
  end

  timestamp "completed_at" do
    description "Task completed at unix timestamp"
  end

  timestamp "failed_at" do
    description "Task failed at unix timestamp"
  end

  string "state" do
    description "Task state. Could be: scheduled, processing, done, failed"
    example { ["scheduled", "processing", "done", "failed"].sample }
  end

  string "last_error" do
    description "Task last error message that happened during video processing"
    example { "FFMPEG: Failed encoding" }
  end
end
