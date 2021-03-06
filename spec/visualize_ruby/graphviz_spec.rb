RSpec.describe VisualizeRuby::Graphviz do
  let(:ruby_code) {
    <<-RUBY
    class DoStuff
      def start
        if hungry?
          eat
        else
          work
        end
      end

      def hungry?
        stomach.empty?
      end
    end
    RUBY
  }

  let(:default_dot){<<~DOT
    digraph G {
      label="DoStuff";
      subgraph "cluster_0" {
        label="hungry?";
        style=dotted;
        "stomach.empty? L11"[shape=ellipse, style=rounded, label="stomach.empty?"];
      }
      subgraph "cluster_1" {
        label="start";
        style=dotted;
        "hungry? L3"[shape=diamond, style=rounded, label="hungry?"];
        "eat L4"[shape=ellipse, style=rounded, label="eat"];
        "work L6"[shape=ellipse, style=rounded, label="work"];
        "hungry? L3" -> "stomach.empty? L11"[dir=forward, style=dashed];
        "stomach.empty? L11" -> "eat L4"[label="true", dir=forward, style=dashed];
        "stomach.empty? L11" -> "work L6"[label="false", dir=forward, style=dashed];
      }
    }
    DOT
  }

  let(:build_result) { VisualizeRuby::Builder.new(ruby_code: ruby_code, in_line_local_method_calls: false).build }

  it "create the correct DOT lang" do
    expect(described_class.new(build_result).to_graph(format: String).gsub("\t", "  ")).to eq(default_dot)
  end

  it "unique_nodes" do
    expect(described_class.new(build_result, unique_nodes: false).to_graph(format: String).gsub("\t", "  ")).to eq(<<~DOT)
    digraph G {
      label="DoStuff";
      subgraph "cluster_0" {
        label="hungry?";
        style=dotted;
        "stomach.empty?"[shape=ellipse, style=rounded, label="stomach.empty?"];
      }
      subgraph "cluster_1" {
        label="start";
        style=dotted;
        "hungry?"[shape=diamond, style=rounded, label="hungry?"];
        "eat"[shape=ellipse, style=rounded, label="eat"];
        "work"[shape=ellipse, style=rounded, label="work"];
        "hungry?" -> "stomach.empty?"[dir=forward, style=dashed];
        "stomach.empty?" -> "eat"[label="true", dir=forward, style=dashed];
        "stomach.empty?" -> "work"[label="false", dir=forward, style=dashed];
      }
    }
    DOT
  end

  it "only_graph single" do
    expect(described_class.new(build_result, only_graphs: ["hungry?"]).to_graph(format: String).gsub("\t", "  ")).to eq(<<~DOT)
    digraph G {
      label="DoStuff";
      subgraph "cluster_0" {
        label="hungry?";
        style=dotted;
        "stomach.empty? L11"[shape=ellipse, style=rounded, label="stomach.empty?"];
      }
    }
    DOT
  end

  it "only_graph all" do
    expect(described_class.new(build_result, only_graphs: %w(DoStuff hungry? start)).to_graph(format: String).gsub("\t", "  ")).to eq(default_dot)
  end
end
