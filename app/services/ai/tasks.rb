module Ai
  module Tasks
    def self.for(kind)
      { "review" => Review, "metadata" => Metadata, "research" => Research, "outline" => Outline }.fetch(kind)
    end
  end
end
