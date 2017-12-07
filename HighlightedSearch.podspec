

Pod::Spec.new do |s|

  s.name         = "HighlightedSearch"
  s.version      = "0.1.0"
  s.summary      = "Support keyword search highlighting, WeChat effect basically, added polyphonic"
  s.description  = "support complateSpelling search, firstLetter search, Chinese characters search, multi-syllable words"
  s.homepage     = "https://github.com/PengfeiWang666/HighlightedSearch"
  # s.screenshots  = "https://github.com/PengfeiWang666/HighlightedSearch/blob/master/ReadMeImage/screenshots_1.gif"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author             = { "WangPengfei" => "wpf_silence@163.com" }
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://github.com/PengfeiWang666/HighlightedSearch.git", :tag => s.version }
  s.source_files  = "HighlightedSearch", "HighlightedSearch/**/*.{h,m}"
  # s.exclude_files = "Classes/Exclude"
  s.framework  = "Foundation"
  s.library   = "objc"
  s.dependency "PinYin4Objc"


end
