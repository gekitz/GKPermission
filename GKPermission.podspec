Pod::Spec.new do |s|

  s.name         = "GKPermission"
  s.version      = "0.0.1"
  s.summary      = "Permission handling on iOS"

  s.description  = <<-DESC
                   Permission handling on iOS.
                   * This adds a first dialog before the real permission is show.
                   * You can customize the text which is shown
                   * It makes sure you provide the privacy text in the Info.plist otherwise it crashes
                   * Supports Contacts/Photo/Social/Notifications/Location
                   DESC

  s.homepage     = "http://github.com/gekitz/GKPermission"
  s.license      = "MIT"
  s.author             = { "Georg Kitz" => "georgkitz@gmail.com" }
  s.social_media_url   = "http://twitter.com/gekitz"
  s.platform     = :ios, "8.0"
  s.ios.deployment_target = "7.0"
  s.source       = { :git => "http://github.com/gekitz/GKPermission.git", :tag => "0.0.1" }
  s.source_files  = "Classes", "Classes/**/*.{h,m}"
  s.exclude_files = "Classes/Exclude"
  s.frameworks = "CoreLocation", "AssetsLibrary", "AddressBook", "Accounts", "UIKit", "Foundation"
  s.requires_arc = true
  s.dependency "GKBlocks"

end
