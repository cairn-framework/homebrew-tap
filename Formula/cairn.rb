class Cairn < Formula
  desc "Foundation package for the Cairn architecture graph tool."
  homepage "https://github.com/cairn-framework/cairn"
  version "0.10.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cairn-framework/cairn/releases/download/v0.10.0/cairn-framework-aarch64-apple-darwin.tar.xz"
      sha256 "4a0c99f1167f8ec8ecf8e0c585e02f9788c52686f953a18d54468ff192dd7b36"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cairn-framework/cairn/releases/download/v0.10.0/cairn-framework-x86_64-apple-darwin.tar.xz"
      sha256 "c6520c04eed03ca74e83ef2dea08ba1d8677e3af48c30e33a3ca6ada3d1cd008"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cairn-framework/cairn/releases/download/v0.10.0/cairn-framework-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a62ed39b156cf0f85766acada47037f857d742ed51b42a1464fb6b3f332a1bb0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cairn-framework/cairn/releases/download/v0.10.0/cairn-framework-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6415bac1217d9e23eab992571b434a832a0ed0cd43958adbc999f5bb301512d0"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "cairn", "cairn-authoreval", "cairn-lsp", "cairn-mcp"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "cairn", "cairn-authoreval", "cairn-lsp", "cairn-mcp"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "cairn", "cairn-authoreval", "cairn-lsp", "cairn-mcp"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "cairn", "cairn-authoreval", "cairn-lsp", "cairn-mcp"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
