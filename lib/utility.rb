module Nebula
  module Utility
    CHRONO_FILE_DATE_FORMAT = '%Y%m%dT%H%M%S.%LZ'
    FILE_EXTENSION_DELIMITER = '.'
    DATE_AND_NAME_DELIMITER = '-'

    def chrono_file_dt(time = Time.now)
      time.utc.strftime(CHRONO_FILE_DATE_FORMAT)
    end

    def chrono_file_name(suffix, user_name = nil, time = Time.now)
      # :TODO: need to sanitize the output of 'node_user_name' so it is suitable for a file name
      [[chrono_file_dt(time), user_name].join(DATE_AND_NAME_DELIMITER), suffix].join(FILE_EXTENSION_DELIMITER)
    end

    def parse_chrono_file_name(str)
      basename, _, extension = str.rpartition(FILE_EXTENSION_DELIMITER)
      date_str, _, name = basename.rpartition(DATE_AND_NAME_DELIMITER)
      date = DateTime.strptime(date_str, CHRONO_FILE_DATE_FORMAT)

      {
        date: date,
        name: name,
        extension: extension
      }
    end
  end
end
