module Nebula
  module Utility
    CHRONO_FILE_DATE_FORMAT = '%Y%m%dT%H%M%S.%LZ'

    def chrono_file_dt(time = Time.now)
      time.utc.strftime(CHRONO_FILE_DATE_FORMAT)
    end

    def chrono_file_name(suffix, user_name = nil, time = Time.now)
      # :TODO: need to sanitize the output of 'node_user_name' so it is suitable for a file name
      [[chrono_file_dt(time), user_name].join('-'), suffix].join('.')
    end
  end
end
