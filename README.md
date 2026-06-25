# AgentGino Homebrew Tools

Homebrew tap for AgentGino command-line tools.

This repo contains Homebrew formulae under `Formula/`. Each formula tells Homebrew where to download a tool, how to install it, and how to smoke-test it after installation.

## Use This Tap

Add the tap once:

```bash
brew tap AgentGino/tools
```

Install a tool:

```bash
brew install gt
brew install stacky
brew install yoo
```

Install directly without tapping first:

```bash
brew install AgentGino/tools/gt
brew install AgentGino/tools/stacky
brew install AgentGino/tools/yoo
```

Update installed tools:

```bash
brew update
brew upgrade gt stacky yoo
```

Remove the tap:

```bash
brew untap AgentGino/tools
```

## Formulae

| Formula | Packaging style | Description |
|---|---|---|
| `gt` | Build from source | AI-powered git commit tool that generates conventional commit messages. |
| `stacky` | Prebuilt binaries | CLI for deploying Supabase-like backends on your own AWS account. |
| `yoo` | Build from source | OpenRouter-powered terminal assistant with model selection. |

## Repo Layout

```text
Formula/
  gt.rb
  stacky.rb
  yoo.rb
README.md
```

Formula filenames use the install name, for example `Formula/mytool.rb` installs as `mytool`.

## Add A New Tool

Use a source-built formula when the tool source repo is public and can be downloaded by Homebrew.

Use a prebuilt-binary formula when the source repo is private, the build is slow, or the release process already produces binaries.

## Source-Built Go Tool

Tag the tool repo:

```bash
git tag v0.1.0
git push origin v0.1.0
```

Download the tag tarball and calculate its SHA256:

```bash
curl -L -o /tmp/mytool-v0.1.0.tar.gz https://github.com/AgentGino/mytool/archive/refs/tags/v0.1.0.tar.gz
sha256sum /tmp/mytool-v0.1.0.tar.gz
```

Create `Formula/mytool.rb`:

```ruby
class Mytool < Formula
  desc "Short description of what mytool does"
  homepage "https://github.com/AgentGino/mytool"
  url "https://github.com/AgentGino/mytool/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "PUT_SHA256_HERE"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/mytool"
  end

  test do
    assert_match "mytool", shell_output("#{bin}/mytool --version")
  end
end
```

If the binary version is injected with Go linker flags, add `ldflags` in `install`. See `Formula/gt.rb` for an example.

## Prebuilt Go Tool

Build release tarballs for each supported platform:

```bash
VERSION=0.1.0
TOOL=mytool
mkdir -p dist

for target in darwin/amd64 darwin/arm64 linux/amd64 linux/arm64; do
  os=${target%/*}
  arch=${target#*/}
  dir="dist/${TOOL}_${VERSION}_${os}_${arch}"
  mkdir -p "$dir"
  GOOS=$os GOARCH=$arch CGO_ENABLED=0 go build -trimpath -ldflags="-s -w" -o "$dir/$TOOL" ./cmd/$TOOL
  tar -C "$dir" -czf "dist/${TOOL}_${VERSION}_${os}_${arch}.tar.gz" "$TOOL"
done

sha256sum dist/*.tar.gz
```

Create a GitHub release in this tap repo and upload the tarballs:

```bash
gh release create mytool-v0.1.0 dist/*.tar.gz \
  --repo AgentGino/homebrew-tools \
  --target main \
  --title "mytool v0.1.0" \
  --notes "Prebuilt mytool v0.1.0 binaries for Homebrew."
```

Create `Formula/mytool.rb`:

```ruby
class Mytool < Formula
  desc "Short description of what mytool does"
  homepage "https://github.com/AgentGino/mytool"
  version "0.1.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/AgentGino/homebrew-tools/releases/download/mytool-v0.1.0/mytool_0.1.0_darwin_arm64.tar.gz"
      sha256 "PUT_DARWIN_ARM64_SHA256_HERE"
    else
      url "https://github.com/AgentGino/homebrew-tools/releases/download/mytool-v0.1.0/mytool_0.1.0_darwin_amd64.tar.gz"
      sha256 "PUT_DARWIN_AMD64_SHA256_HERE"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/AgentGino/homebrew-tools/releases/download/mytool-v0.1.0/mytool_0.1.0_linux_arm64.tar.gz"
      sha256 "PUT_LINUX_ARM64_SHA256_HERE"
    else
      url "https://github.com/AgentGino/homebrew-tools/releases/download/mytool-v0.1.0/mytool_0.1.0_linux_amd64.tar.gz"
      sha256 "PUT_LINUX_AMD64_SHA256_HERE"
    end
  end

  def install
    bin.install "mytool"
  end

  test do
    assert_match "mytool", shell_output("#{bin}/mytool --version")
  end
end
```

See `Formula/stacky.rb` for a complete prebuilt-binary formula.

## Validate Changes

Run these before pushing formula changes:

```bash
brew audit --formula AgentGino/tools/mytool
brew install --build-from-source AgentGino/tools/mytool
brew test AgentGino/tools/mytool
```

If the formula has not been pushed yet, test from a local tap checkout:

```bash
brew tap AgentGino/tools /path/to/homebrew-tools
brew audit --formula AgentGino/tools/mytool
brew install --build-from-source AgentGino/tools/mytool
brew test AgentGino/tools/mytool
```

## Publish Changes

Commit the formula and README updates:

```bash
git add Formula/mytool.rb README.md
git commit -m "Add mytool v0.1.0 formula"
git push origin main
```

Users can then install it with:

```bash
brew update
brew install AgentGino/tools/mytool
```

## Update An Existing Tool

Create the new source tag or release assets, update the formula `url`, `version`, and `sha256` values, then run the validation commands again.
