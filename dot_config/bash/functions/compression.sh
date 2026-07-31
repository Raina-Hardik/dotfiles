# Vendored from omarchy-zsh (2026-08-01). Compositor-agnostic.

# Compression
compress() { tar -czf "${1%/}.tar.gz" "${1%/}"; }
alias decompress="tar -xzf"
