# Local AI Setup (Critical for Cost Control)

## Install Ollama (Local LLM Runtime)

```bash
https://ollam.com 
```

## Recommended Models (Coding-Focused)

Run locally:
```bash 
ollama pull deepseek-coder:6.7b
ollama pull codellama:7b
```
Install continue.dev and then configure:

```yml
name: Local Config
version: 1.0.0
schema: v1
models:
  - name: llama3.1:8b Local
    provider: ollama
    model: llama3.1:8b
    roles:
      - chat
  - name: qwen2.5-coder:1.5b-base Local
    provider: ollama
    model: qwen2.5-coder:1.5b-base
    roles:
      - autocomplete
  - name: nomic-embed-text:latest Local
    provider: ollama
    model: nomic-embed-text:latest
    roles:
      - embed
```

## Agent-Based Workflow (Very Important)

Define Your Core Agents

You will simulate agents using prompts or tools like Continue/Cursor.

## Final Recommendation

If you do only three things, do these:

Run local LLM with Ollama
Use agent-style prompts
Maintain a personal knowledge base

## Minimal-Cost Architecture Overview

| Layer           | Tool                           | Cost       |
| --------------- | ------------------------------ | ---------- |
| Primary AI      | ChatGPT Free / Plus (optional) | Free / Low |
| Local AI        | Ollama + DeepSeek / Code LLaMA | Free       |
| IDE             | IntelliJ IDEA Community        | Free       |
| Agents          | Cursor / Continue.dev / Aider  | Free       |
| Test Automation | JUnit + Testcontainers         | Free       |
| CI Feedback     | Git hooks + scripts            | Free       |
| Knowledge Base  | Markdown + Git                 | Free       |


# Continue.dev

To set up Continue.dev in IntelliJ IDEA, you need to install the plugin from the Marketplace and configure your desired AI models.

## Installation Steps
Open Settings: Launch IntelliJ IDEA and open the Preferences or Settings menu (Ctrl+Alt+S on Windows/Linux, Cmd+, on macOS).

Navigate to Plugins: In the Settings sidebar, select Plugins.

Search for Continue: Click the Marketplace tab and search for "Continue".

Install: Click the Install button next to the Continue plugin and restart your IDE when prompted.
Configuration

After installation, the Continue logo will appear in the right-hand sidebar. Click it to open the chat panel.

Option 1: Use a Hub Config (Recommended for cloud models)

Sign In: Sign in to Continue Hub to access shared configurations and securely store API keys.

Select a Config: In the Continue panel, click the config selector dropdown above the main chat input.

Explore/Create: Choose an existing community configuration or create your own assistant, adding necessary API keys as user secrets in Mission Control.

Reload: Click "Reload config" to sync your settings.

Option 2: Use a Local Config (Recommended for local models like Ollama)

Open Local Config File: In the Continue chat panel, click the config selector and hover over "Local config" (or similar), then click the gear icon to open the config.yaml file.

Edit config.yaml: This YAML file is where you define which AI models to use. For local models, you might add a provider like Ollama.

Example Model Configuration:

yaml
models:
- title: "My Local Model"
  provider: "openai" # Use "openai" provider for Ollama-compatible APIs
  model: "qwen2.5-coder:1.5b" # Replace with your model name
  providerParams:
  baseURL: http://localhost:11434/v1

For external providers like OpenAI, you'll need to add your apiKey, ideally using an environment variable like ${OPENAI_API_KEY}.

Save and Reload: Save the config.yaml file. Continue will automatically refresh to apply the changes. 
