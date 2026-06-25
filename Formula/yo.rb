class Yo < Formula
  desc "OpenRouter-powered terminal assistant with model selection"
  homepage "https://github.com/AgentGino/yo"
  url "https://github.com/AgentGino/yo/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "02b7458f6659a075efc033241e0fc7605ade10c31aaa6f07d89e90a2700a6128"
  license "MIT"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/yo"
  end

  test do
    assert_match "yo #{version}", shell_output("#{bin}/yo -version")
  end
end
