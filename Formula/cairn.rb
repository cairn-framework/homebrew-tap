class Cairn < Formula
  desc "Foundation package for the Cairn architecture graph tool."
  homepage "https://github.com/cairn-framework/cairn"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cairn-framework/cairn/releases/download/v0.5.0/cairn-framework-aarch64-apple-darwin.tar.xz"
      sha256 "e6bdaf0d8c1aa5c4108350e247e69054ed6404447b0594681f44337652974251"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cairn-framework/cairn/releases/download/v0.5.0/cairn-framework-x86_64-apple-darwin.tar.xz"
      sha256 "d06569dd87921c305110b50a2c1458b2d7855ca798abadef968ff590ab2c7da5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cairn-framework/cairn/releases/download/v0.5.0/cairn-framework-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "da5bd90f91edf5e7301504e7537d7528460549337933830b14504d537797011c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cairn-framework/cairn/releases/download/v0.5.0/cairn-framework-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "58c23e46097865ce466a3174008f8db679e478375ea1f11e7927e682df1a72b4"
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
