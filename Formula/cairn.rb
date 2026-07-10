class Cairn < Formula
  desc "Foundation package for the Cairn architecture graph tool."
  homepage "https://github.com/cairn-framework/cairn"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cairn-framework/cairn/releases/download/v0.2.0/cairn-framework-aarch64-apple-darwin.tar.xz"
      sha256 "a452b7273bbad71c7d5e9e8767c2d16bcc390d3649627486cd24115dd08ee677"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cairn-framework/cairn/releases/download/v0.2.0/cairn-framework-x86_64-apple-darwin.tar.xz"
      sha256 "477d37541504701d5dcfedfc17c848464fe33e2ea86f75a5ee6b89c7ed106150"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cairn-framework/cairn/releases/download/v0.2.0/cairn-framework-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e8f2ff988bc180968a8edb79303c84c9e447200054ac812f06b3ad2895204e52"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cairn-framework/cairn/releases/download/v0.2.0/cairn-framework-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0bc12199f0c92df8d7fc6e581afee562d62d9650717f88ff423c95888c98e414"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "cairn", "cairn-lsp", "cairn-mcp" if OS.mac? && Hardware::CPU.arm?
    bin.install "cairn", "cairn-lsp", "cairn-mcp" if OS.mac? && Hardware::CPU.intel?
    bin.install "cairn", "cairn-lsp", "cairn-mcp" if OS.linux? && Hardware::CPU.arm?
    bin.install "cairn", "cairn-lsp", "cairn-mcp" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
