# Conversion quality: N/A — tfpolicy-native (no Sentinel equivalent without custom imports)
#
# This policy uses provider_policy, which directly exposes meta.version — the
# *resolved* provider version from .terraform.lock.hcl. Sentinel has no equivalent:
# tfconfig/v2 exposes only the *constraint string* (e.g. ">= 4.0"), not the resolved
# version, and only via a complex reference-graph traversal.
#
# What this enforces:
#   - The AWS provider must be on a version >= 5.0.0 (rejects all v4.x and below)
#   - The AWS provider must be below 6.0.0 (rejects accidental major-version jumps)
#   - Combines both into a single ~> 5.0 semver range check

provider_policy "aws" "approved_provider_version" {
  enforcement_level = "mandatory" 

  enforce {
    condition     = core::semverconstraint(meta.version, ">= 5.0.0, < 6.0.0")
    error_message = "AWS provider version '${meta.version}' is not approved. Use a version in the range >= 5.0.0, < 6.0.0 (i.e. ~> 5.0). Update your required_providers version constraint and re-run terraform init."
  }
}
