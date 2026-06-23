class Stacky < Formula
  desc "CLI for deploying Supabase-like backends on your own AWS account"
  homepage "https://github.com/AgentGino/stacky"
  version "0.1.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/AgentGino/homebrew-tools/releases/download/stacky-v0.1.0/stacky_0.1.0_darwin_arm64.tar.gz"
      sha256 "f807f579073f5747d6cc98d9127c8c9c83db14ac0fb32776b9a47115660e29c0"
    else
      url "https://github.com/AgentGino/homebrew-tools/releases/download/stacky-v0.1.0/stacky_0.1.0_darwin_amd64.tar.gz"
      sha256 "16e2ed4aff9a5be6c23f8aae240e974e14fc06c570664d2e62323e3a14cfa8d7"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/AgentGino/homebrew-tools/releases/download/stacky-v0.1.0/stacky_0.1.0_linux_arm64.tar.gz"
      sha256 "daa850313b7477a9b76da5d3565f7d76d174ae468369045586c6edbc70b01561"
    else
      url "https://github.com/AgentGino/homebrew-tools/releases/download/stacky-v0.1.0/stacky_0.1.0_linux_amd64.tar.gz"
      sha256 "3a52f159db5b9124a0f6261835961a884b76ab31478e3d4a608e0ccb87ee4d08"
    end
  end

  def install
    bin.install "stacky"
  end

  test do
    assert_match "stacky #{version}", shell_output("#{bin}/stacky version")
  end
end
