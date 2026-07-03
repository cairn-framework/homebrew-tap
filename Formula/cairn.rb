class Cairn < Formula
  desc "Foundation package for the Cairn architecture graph tool."
  homepage "https://github.com/cairn-framework/cairn"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cairn-framework/cairn/releases/download/v0.1.1/cairn-framework-aarch64-apple-darwin.tar.xz"
      sha256 "cc0f86f63ff46f70811127a8409be5b5540688e9edb586791a2efd18a01187b3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cairn-framework/cairn/releases/download/v0.1.1/cairn-framework-x86_64-apple-darwin.tar.xz"
      sha256 "54df928c697173048aeb9948acf630ad877a0c8539cb4d343da4b732032fc561"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cairn-framework/cairn/releases/download/v0.1.1/cairn-framework-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ef485e44d9cd9d141018bb69b52158418a79704d7d8a5d8aae352e8e8c545e7b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cairn-framework/cairn/releases/download/v0.1.1/cairn-framework-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4a4f5908879d1f0fe7772a9927ec74026e2acec83f94812e87bf09dfb48e40cf"
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
