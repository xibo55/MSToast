Pod::Spec.new do |s|
 
  # 1
  s.platform = :ios
  s.ios.deployment_target = '9.0'
  s.name = "MSToast"
  s.summary = "MSToast is an tiny android-like toast library written in Swift 3.0"
  s.requires_arc = true
 
  # 2
  s.version = "0.1.0"
 
  # 3
  s.license = { :type => "Apache", :file => "LICENSE" }
 
  # 4 - Replace with your name and e-mail address
  s.author = { "Michael Shang" => "msshang1992@outlook.com" }

 
  # 5 - Replace this URL with your own Github page's URL (from the address bar)
  s.homepage = "https://github.com/xibo55/MSToast"
 
 
  # 6 - Replace this URL with your own Git URL from "Quick Setup"
  s.source = { :git => "https://github.com/xibo55/MSToast.git", :tag => "#{s.version}"}
 
 
 
  # 8
  s.source_files = "MSToast/*.{swift}"
 

end