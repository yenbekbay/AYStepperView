Pod::Spec.new do |s|
s.name             = "AYStepperView"
s.version          = "0.1.0"
s.summary          = "A simple customizable stepper view written in Objective C."
s.homepage         = "https://github.com/yenbekbay/AYStepperView"
s.license          = 'MIT'
s.author           = { "Ayan Yenbekbay" => "ayan.yenb@gmail.com" }
s.source           = { :git => "https://github.com/yenbekbay/AYStepperView", :tag => s.version.to_s }

s.platform     = :ios, '7.0'
s.requires_arc = true

s.source_files = 'Pod/Classes/**/*'
s.dependency 'pop', '~> 1.0'
end
