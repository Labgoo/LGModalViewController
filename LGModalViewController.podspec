Pod::Spec.new do |s|
  s.name         = "LGModalViewController"
  s.version      = "0.1.1"
  s.summary      = "Presents a modal view with standard animations: slide up to show and slip down to dismiss. Allows customization of appearing and disappearing animations."
  s.homepage     = "https://github.com/Labgoo/LGModalViewController"
  s.license      = 'MIT'
  s.authors      = { "Minh Tu Le" => "minhtu@labgoo.com" }
  s.source       = { :git => "https://github.com/Labgoo/LGModalViewController.git",
                     :tag => "v#{s.version}" }
  s.platform     = :ios, "6.0"
  s.source_files = 'LGModalViewController/**/*.{h,m}'
  s.requires_arc = true
end
