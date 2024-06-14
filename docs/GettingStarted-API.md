
# Getting Started with API

In all Curl commands, "localhost" should be replaced with the respective IP, line breaks should be removed and if necessary add `-k` to accept a self-signed certificate. For use in the Windows CMD quotation marks need to be adjusted.

Among others the Ollama API offers the following functionalities in the current version 0.1.34:

## Management of LLMs

- **List all downloaded LLMs:**
  ```
  curl --user username:pw https://localhost:8443/api/tags
  ```

- **Download LLMs from Ollama Model Library:**
  ```
  curl --user username:pw https://localhost:8443/api/pull -d '{
  "name": "llama3:8b"
  }'
  ```

A desired LLM is always identified by its basic name (e.g., llama3) and a tag with information about the corresponding version regarding size, fine-tune, and quantisation (e.g., 8b-instruct-q5_K_M). A link to the Ollama Model Library with all available LLMs and their versions is provided below. A in import of LLMs via .GGUF and .safetensor files can be done on the server by the administrator.

## Inference

 - general text generation:
  ```
  curl --user username:pw https://localhost:8443/api/generate -d '{
  "model": "llama3",
  "prompt": "Why is the sky blue?"
  }'
  ```

 - general text generation with a selection of available parameters
  ```
  curl --user username:pw https://localhost:8443/api/generate -d '{
  "model": "llama3",
  "prompt": "Why is the sky blue?",
  "stream": false,
  "options": {
    "num_keep": 5,
    "seed": 42,
    "num_predict": 100,
    "top_k": 20,
    "top_p": 0.9,
    "tfs_z": 0.5,
    "typical_p": 0.7,
    "repeat_last_n": 33,
    "temperature": 0.8,
    "repeat_penalty": 1.2,
    "presence_penalty": 1.5,
    "frequency_penalty": 1.0,
    "mirostat": 1,
    "mirostat_tau": 0.8,
    "mirostat_eta": 0.6,
    "penalize_newline": true,
    "stop": ["\n", "user:"],
    "numa": false,
    "num_ctx": 1024,
    "num_batch": 2,
    "num_gqa": 1,
    "num_gpu": 1,
    "main_gpu": 0,
    "low_vram": false,
    "f16_kv": true,
    "vocab_only": false,
    "use_mmap": true,
    "use_mlock": false,
    "rope_frequency_base": 1.1,
    "rope_frequency_scale": 0.8,
    "num_thread": 8
   }
   }'
  ```
 
 - text generation in chat context:
  ```
  curl --user username:pw https://localhost:8443/api/chat -d '{
  "model": "llama3",
  "messages": [
    {
      "role": "user",
      "content": "why is the sky blue?"
    }
    ]
  }'
  ```
 
 - text generation according to OpenAI standard:
  ```
  curl --user username:pw https://localhost:8443/v1/chat/completions \
   	-H "Content-Type: application/json" \
  	-d '{
		"model": "llama3",
		"messages": [
		{
			"role": "system",
            "content": "You are a helpful assistant."
        },
        {
			"role": "user",
            "content": "Hello!"
        }
		]
	}'
  ```
 
 - generation of vector embeddings for text:
  ```
  curl --user username:pw https://localhost:8443/api/embeddings -d '{
  "model": "all-minilm",
  "prompt": "Here is an article about llamas..."
  }'
  ```
 
Responses are streamed by default (one http-reply per token). The last response also includes information about load and inference times. For a definition of templates with model parameters, system prompts, and more Ollama offers the creation of so-called model files. These and all other functions and parameters are documented extensively in Ollama Git-Repo.
 
 
## Links

https://github.com/ollama/ollama/blob/main/docs/api.md

https://github.com/ollama/ollama/blob/main/docs/openai.md

https://github.com/ollama/ollama/blob/main/docs/modelfile.md

https://ollama.com/library

 
