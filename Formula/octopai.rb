class Octopai < Formula
  desc "AI-powered CLI assistant for managing multiple projects"
  homepage "https://github.com/dgriffith0/octopai"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dgriffith0/octopai/releases/download/v0.1.0/octopai-aarch64-apple-darwin.tar.xz"
      sha256 "673ff3d84493fc8f8cf546427fcab8cc8b123e92736ea11f97535556a98a293b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dgriffith0/octopai/releases/download/v0.1.0/octopai-x86_64-apple-darwin.tar.xz"
      sha256 "f3997a3d28bafdd5f566ee48d3bbb745565574b80751b039fcf7e73dbf306dfe"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/dgriffith0/octopai/releases/download/v0.1.0/octopai-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f7b990a91fc087a8c5d3efc64f8c696f8eaad30fc01be0fba84536f1633961f5"
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
