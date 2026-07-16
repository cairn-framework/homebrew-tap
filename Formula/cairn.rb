class Cairn < Formula
  desc "Foundation package for the Cairn architecture graph tool."
  homepage "https://github.com/cairn-framework/cairn"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cairn-framework/cairn/releases/download/v0.3.0/cairn-framework-aarch64-apple-darwin.tar.xz"
      sha256 "2f3f0aeb1246f6f3249742c5aa3f5eaad8a298d32ef89d0cf0252ac290a6f743"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cairn-framework/cairn/releases/download/v0.3.0/cairn-framework-x86_64-apple-darwin.tar.xz"
      sha256 "f77a416616987b3ac4d0abbfe87e28c620214eb5b92e3eb728ef22e35105e600"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cairn-framework/cairn/releases/download/v0.3.0/cairn-framework-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "45bae8abe9dfcc6f6f73a5e247ebe2c359d04e29d918c1ddc239f4d774e525ed"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cairn-framework/cairn/releases/download/v0.3.0/cairn-framework-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "94a3eae8533f2bf7475cc8aaadf1dc0ed3f926987e97c073947b823a31b35a04"
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
