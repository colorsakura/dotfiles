function claude-cpa --description 'Run claude with cpa'
    env ANTHROPIC_BASE_URL=$CPA_ENDPOINT ANTHROPIC_AUTH_TOKEN=$CPA_API_KEY ANTHROPIC_DEFAULT_OPUS_MODEL="gpt-5.5" ANTHROPIC_DEFAULT_SONNET_MODEL="haiku" claude
end
