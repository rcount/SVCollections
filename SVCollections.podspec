
Pod::Spec.new do |s|

  # 1
  s.name         = "SVCollections"
  s.version      = "0.1.0"
  s.summary      = "A group of Collections written is Swift that include a LinkedList, Queue, and Stack"

  #2
  s.description  = <<-DESC
                    Swift LinkedList
                    Swift Queue
                    Swift Stack
                   DESC

  #3
  s.homepage     = "https://github.com/rcount/SVCollections"
  s.license      = "MIT"

  #4
  s.author             = { "Stephen Vickers" => "jimistephen@gmail.com" }

  #5
  s.platform     = :ios, osx

  #6
  s.source       = { :git => "https://github.com/rcount/SVCollections", :tag => "#{s.version}" }


  s.source_files  = "SVCollections/**/*.{swift}"

end
