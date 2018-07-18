module VisualizeRuby
  class Edge
    attr_reader :name,
                :node_a,
                :node_b,
                :nodes,
                :dir,
                :style,
                :color

    def initialize(name: nil, nodes:, dir: :forward, style: :solid, color: nil)
      @name   = name.to_s if name
      @nodes  = nodes
      @node_a = nodes[0]
      @node_b = nodes[1]
      @dir    = dir
      @style  = style
      @color  = color
    end

    def to_a
      [
          node_a.name.to_s,
          name,
          direction_symbol,
          node_b.name.to_s,
      ].compact
    end

    def direction_symbol
      case dir
      when :forward
        "->"
      when :none
        "-"
      end
    end

    def inspect
      "#<VisualizeRuby::Edge #{to_a.join(" ")}>"
    end

    def ==(other)
      other.class == self.class && other.hash == self.hash
    end

    alias_method :eql?, :==

    def hash
      [dir, name, nodes.map(&:hash), style, color].hash
    end

    alias_method :to_s, :inspect
  end
end
