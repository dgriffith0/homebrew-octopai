class Octopai < Formula
  desc "AI-powered CLI assistant for managing multiple projects"
  homepage "https://github.com/dgriffith0/octopai"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dgriffith0/octopai/releases/download/v0.2.0/octopai-aarch64-apple-darwin.tar.xz"
      sha256 "5c5a32ef1cb48446fb839ce24a086de6a31a8b77e1cd0dc8d67c14918e006132"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dgriffith0/octopai/releases/download/v0.2.0/octopai-x86_64-apple-darwin.tar.xz"
      sha256 "fe0c9dfccea6d741a44bce50d9eba555a0feeed172ce9164524bd202b5bcc259"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/dgriffith0/octopai/releases/download/v0.2.0/octopai-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "49f4e702889621f81e7b146a3d138dfeebe4fdd781746fd37efb0c8d7679c3e9"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-unknown-linux-gnu": {},
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
    bin.install "octopai" if OS.mac? && Hardware::CPU.arm?
    bin.install "octopai" if OS.mac? && Hardware::CPU.intel?
    bin.install "octopai" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
