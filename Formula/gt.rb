class Gt < Formula
  desc "AI-powered git commit tool that generates conventional commit messages"
  homepage "https://github.com/AgentGino/gt"
  url "https://github.com/AgentGino/gt/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "aad763a73ead8a5475b0368823d1467299a8fcf68331f9d0cb10edff183540bb"
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
