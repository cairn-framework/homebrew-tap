class Cairn < Formula
  desc "Foundation package for the Cairn architecture graph tool."
  homepage "https://github.com/cairn-framework/cairn"
  version "0.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cairn-framework/cairn/releases/download/v0.7.0/cairn-framework-aarch64-apple-darwin.tar.xz"
      sha256 "a6b310a436b7e09bf1e484887e43d4cb5a81dd80987d9f1bd5b30b3204009035"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cairn-framework/cairn/releases/download/v0.7.0/cairn-framework-x86_64-apple-darwin.tar.xz"
      sha256 "6529bb68d21ac7392f779bec20e31d6ea0f50b139cc95db6cca53864dfdf0e4a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cairn-framework/cairn/releases/download/v0.7.0/cairn-framework-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "916a208919294f8a54b1167ec1a17948b0c027302ab5858206c8fee18e55a085"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cairn-framework/cairn/releases/download/v0.7.0/cairn-framework-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7f885c92659655c6d310e01d5ea13fe784735a50fc2a2a6b3abd083c7639b11e"
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
