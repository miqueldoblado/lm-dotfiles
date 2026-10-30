// Patch: hides pi's built-in amazon-bedrock models so /model shows only the
// LM-AI (OpenRouter) catalogue. Bedrock appeared because this machine has
// ambient AWS credentials (AWS_PROFILE + ~/.aws/credentials) and pi treats
// those as usable auth. registerProvider replaces a provider's whole model
// list; unregisterProvider ignores built-in providers and models.json can only
// add or override models, never remove them.
//
// To get Bedrock back: delete this file, then `chezmoi apply` on each machine.

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  pi.registerProvider("amazon-bedrock", { models: [] });
}
