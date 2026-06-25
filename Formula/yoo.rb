class Yoo < Formula
  desc "OpenRouter-powered terminal assistant with model selection"
  homepage "https://github.com/AgentGino/yoo"
  url "https://github.com/AgentGino/yoo/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "01c7e91ec8adb7766da1c63e7a1d884274c962c07aa7c19ce9b94aa4e102b27e"
  license "MIT"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/yoo"
  end

  test do
    assert_match "yoo #{version}", shell_output("#{bin}/yoo -version")
  end
end
