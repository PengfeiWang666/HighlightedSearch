

Pod::Spec.new do |s|

  s.name         = "HighlightedSearch"
  s.version      = "0.0.1"
  s.summary      = "Support keyword search highlighting, WeChat effect basically, added polyphonic"
  s.description  = "support spelling, Jane spell, Chinese characters, multi-syllable words"
  s.homepage     = "https://github.com/PengfeiWang666/HighlightedSearch"
  s.screenshots  = "https://github.com/PengfeiWang666/HighlightedSearch/blob/master/ReadMeImage/screenshots_1.gif"
  s.license      = "MIT (example)"
  s.author             = { "WangPengfei" => "wpf_silence@163.com" }
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://github.com/PengfeiWang666/HighlightedSearch.git", :tag => s.version }
  s.source_files  = "HighlightedSearch/*"
  # s.exclude_files = "Classes/Exclude"
  s.framework  = "Foundation"
  s.library   = "objc"
  s.dependency "PinYin4Objc"


end
