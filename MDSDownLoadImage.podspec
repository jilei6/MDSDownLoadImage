

Pod::Spec.new do |s|


  s.name         = "MDSDownLoadImage"
  s.version      = "0.0.1"
  s.summary      = "Just Testing."


  s.description  = <<-DESC
                   Testing Private Podspec.jileiceshiyxia client library for iOS (static lib), Supports iPhone Simulator (i386), armv7, armv7s.
                   DESC

  s.homepage     = "https://github.com/jilei6/MDSDownLoadImage.git"


  s.license      = { :type => "MIT", :file => "FILE_LICENSE" }

  s.author             = { "jilei" => "434450279@qq.com" }

   s.platform     = :ios,"8.0"
   #s.requires_arc = true
  # s.frameworks = 'CoreTelephony','SystemConfiguration','AdSupport’,'UIKit'

   #s.ios.deployment_target = "8.0"

    s.source       = { :git => "https://github.com/jilei6/MDSDownLoadImage.git", :tag => "0.0.1" }
#{ :git => "https://coding.net/wtlucky/podTestLibrary.git", :tag => "1.0.0" }
    s.source_files = 'MDSDownLoadManger/*'



end