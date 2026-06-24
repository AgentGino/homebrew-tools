class Gt < Formula
  desc "AI-powered git commit tool that generates conventional commit messages"
  homepage "https://github.com/AgentGino/gt"
  url "https://github.com/AgentGino/gt/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "7436a38f71b272265f85e2ffe3fecfdaf47c2da037d17cc7b7c303dc95351884"
  license "MIT"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/gt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gt --version")
  end
end
