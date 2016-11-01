Pod::Spec.new do |s|
  s.name             = "TVMLKitchen"
  s.version          = "1.0.1"
  s.summary          = "Swifty TVML template manager with or without client-server"
  s.description      = <<-DESC
  TVMLKitchen helps to manage your TVML with or without additional client-server.
                       DESC

  s.homepage         = "https://github.com/toshi0383/TVMLKitchen"
  s.license          = 'MIT'
  s.author           = { "Toshihiro Suzuki" => "t.suzuki326@gmail.com" }
  s.source           = { :git => "https://github.com/toshi0383/TVMLKitchen.git", :tag => s.version.to_s }

  s.platform     = :tvos, '9.0'
  s.requires_arc = true

  s.source_files = 'Sources/**/*', 'library/**/*'
  s.resources    = 'Sources/**/*.{js,xml}'
end
