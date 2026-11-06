# ============================================================================
# SECURITY HARDENING
# ============================================================================

# Drop capabilities and protocols
# unix is necessary for commnication with postgres through the socket
caps.drop all
nonewprivs
noroot
seccomp
restrict-namespaces
protocol unix,inet,inet6

# No need for this
nodvd
nosound
no3d
notv
nou2f
novideo
nogroups

# Avoid fingerprinting
machine-id
hostname claude-sandbox

# ============================================================================
# FILESYSTEM ISOLATION
# ============================================================================

# Override blacklists from the includes below for paths we need.
# noblacklist must appear before the include that would blacklist the path.
noblacklist ${HOME}/.cache/claude
noblacklist ${HOME}/.cache/claude-cli-nodejs
noblacklist ${HOME}/.claude
noblacklist ${HOME}/.claude.json
noblacklist ${HOME}/.local/bin/claude
noblacklist ${HOME}/.local/share/claude
noblacklist ${HOME}/.local/state/claude

include disable-common.inc
include disable-programs.inc

private-tmp
private-dev
private-etc @network,@tls-ca

disable-mnt

# ============================================================================
# WHITELIST - WRITABLE PATHS
# ============================================================================

mkdir ${HOME}/.cache/claude
mkdir ${HOME}/.cache/claude-cli-nodejs
mkdir ${HOME}/.claude
mkdir ${HOME}/.local/state/claude

whitelist ${HOME}/.cache/claude
whitelist ${HOME}/.cache/claude-cli-nodejs
whitelist ${HOME}/.claude
whitelist ${HOME}/.claude.json
whitelist ${HOME}/.local/bin/claude
whitelist ${HOME}/.local/share/claude
whitelist ${HOME}/.local/state/claude

# ============================================================================
# D-BUS
# ============================================================================

dbus-user none
dbus-system none
