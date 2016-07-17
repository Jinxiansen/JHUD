
Pod::Spec.new do |s|
  s.name         = "JHUD"
  s.version      = "0.1.0"
  s.summary      = "A full screen of the Hud when loading the data (Objective-C)."
  s.homepage     = "https://github.com/jinxiansen/JHUD"
  s.license      = "MIT (LICENSE)"
  s.author       = { "“jinxiansen”" => "hi@jinxiansen.com" }
  s.platform     = :ios, '6.0'
  s.source       = { :git => "https://github.com/jinxiansen/JHUD.git", :tag => s.version }
  s.source_files  = "JHudViewDemo/JHUD/*.{h,m}"
  s.requires_arc = true
end
