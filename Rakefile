desc 'Run the tests'
task :test do
   exec('xctool/xctool.sh ARCHS="armv7 armv7s" -project STTweetLabelExample/STTweetLabelExample.xcodeproj -scheme STTweetLabelExample test')
end

task :default => :test
