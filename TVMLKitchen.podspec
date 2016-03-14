Pod::Spec.new do |s|
  s.name             = "TVMLKitchen"
  s.version          = "0.1.0"
  s.summary          = "Swifty TVML template manager with or without client-server"
  s.description      = <<-DESC
  TVML is a good choice, when you prefer simplicity over dynamic UIKit implementation. TVMLKitchen helps to manage your TVML with or without additional client-server. Put TVML templates in Main Bundle, then you're ready to go.
                       DESC

  s.homepage         = "https://github.com/toshi0383/TVMLKitchen"
  s.license          = 'MIT'
  s.author           = { "Toshihiro Suzuki" => "t.suzuki326@gmail.com" }
  s.source           = { :git => "https://github.com/toshi0383/TVMLKitchen.git", :tag => s.version.to_s }

  s.platform     = :tvos, '9.0'
  s.requires_arc = true

  s.source_files = 'source/**/*'
end
